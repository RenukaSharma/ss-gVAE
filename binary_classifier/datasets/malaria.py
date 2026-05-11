"""Malaria patch-based anomaly-detection dataset (WACV 2022).

Two modes are supported via the layout of ``root``:

1. *Cached mode* (recommended): ``root`` contains pre-extracted patch tensors::

       <root>/cached/train_data.pt
       <root>/cached/train_label.pt
       <root>/cached/test_data.pt
       <root>/cached/test_label.pt

   If those four files exist they are loaded directly.

2. *Raw mode* (one-time): ``root`` contains the curated annotations laid out as::

       <root>/curated_malaria_dataset_manual_annotations/   # raw images + `_seg_abnormal*.png` masks
       <root>/segmentations/                                # per-class masks

   On first run the loader walks the images, extracts patches, and writes the
   ``cached/`` ``.pt`` files so subsequent runs are fast.

Salt-and-pepper noise is applied at training time to match the WACV 2022 setup.

To use a different cached folder name pass it via the ``MALARIA_CACHE_DIR``
environment variable (relative to ``root``); defaults to ``cached``.
"""

import logging
import os
import random

import numpy as np
import torch
from PIL import Image, ImageFile
from torch.utils.data import Dataset, Subset
from torchvision import transforms
from tqdm import tqdm

from base.torchvision_dataset import TorchvisionDataset
from .preprocessing import create_semisupervised_setting

ImageFile.LOAD_TRUNCATED_IMAGES = True


# Patch-extraction hyperparameters (must match the WACV 2022 setup).
_PATCH_SIZE = 170
_STEP = 5
_TRAIN_FILE_RANGE = range(1, 1209)
_TEST_FILE_RANGE = range(1209, 1329)
_TARGET_TRAIN_ANOMALIES = 10000
_TARGET_TEST_ANOMALIES = 2500
_ANOMALY_FRACTION_THRESHOLD = 0.5
_ANOMALY_CLASSES = ('ring', 'schizont', 'trophozoite')
# Salt-and-pepper noise parameters used during training.
_SP_AMOUNT_TRAIN = 0.40
_SP_RATIO = 0.5


class Malaria_Dataset(TorchvisionDataset):

    def __init__(self, root: str, normal_class: int = 0, known_outlier_class: int = 1,
                 n_known_outlier_classes: int = 0,
                 ratio_known_normal: float = 0.0, ratio_known_outlier: float = 0.0,
                 ratio_pollution: float = 0.0):
        super().__init__(root)
        logger = logging.getLogger()

        self.n_classes = 2
        self.normal_classes = tuple([normal_class])
        self.outlier_classes = list(range(0, 2))
        self.outlier_classes.remove(normal_class)
        self.outlier_classes = tuple(self.outlier_classes)

        if n_known_outlier_classes == 0:
            self.known_outlier_classes = ()
        elif n_known_outlier_classes == 1:
            self.known_outlier_classes = tuple([known_outlier_class])
        else:
            self.known_outlier_classes = tuple(
                random.sample(self.outlier_classes, n_known_outlier_classes))

        cache_subdir = os.environ.get('MALARIA_CACHE_DIR', 'cached')
        cache_dir = os.path.join(root, cache_subdir)
        train_data_pt = os.path.join(cache_dir, 'train_data.pt')
        train_label_pt = os.path.join(cache_dir, 'train_label.pt')
        test_data_pt = os.path.join(cache_dir, 'test_data.pt')
        test_label_pt = os.path.join(cache_dir, 'test_label.pt')

        if all(os.path.exists(p) for p in (train_data_pt, train_label_pt,
                                           test_data_pt, test_label_pt)):
            logger.info("Loading cached malaria tensors from %s", cache_dir)
            train_data = torch.load(train_data_pt)
            train_label = torch.load(train_label_pt)
            test_data = torch.load(test_data_pt)
            test_label = torch.load(test_label_pt)
        else:
            logger.info("Cache miss \u2014 extracting malaria patches from raw images "
                        "(this takes a while; results will be cached at %s)", cache_dir)
            train_data, train_label = self._extract_patches(
                root, _TRAIN_FILE_RANGE, _TARGET_TRAIN_ANOMALIES, logger)
            test_data, test_label = self._extract_patches(
                root, _TEST_FILE_RANGE, _TARGET_TEST_ANOMALIES, logger)
            os.makedirs(cache_dir, exist_ok=True)
            torch.save(train_data, train_data_pt)
            torch.save(train_label, train_label_pt)
            torch.save(test_data, test_data_pt)
            torch.save(test_label, test_label_pt)

        train_set = _MalariaPatchDataset(train_data, train_label, train=True)
        idx, _, semi_targets = create_semisupervised_setting(
            np.asarray(train_set.targets), self.normal_classes, self.outlier_classes,
            self.known_outlier_classes, ratio_known_normal, ratio_known_outlier, ratio_pollution)
        train_set.semi_targets[idx] = torch.tensor(semi_targets)
        self.train_set = Subset(train_set, idx)

        self.test_set = _MalariaPatchDataset(test_data, test_label, train=False)
        logger.info("Malaria train set length (after semi-sup split): %d", len(self.train_set))
        logger.info("Malaria test set length: %d", len(self.test_set))

    @staticmethod
    def _extract_patches(root, file_range, target_anomalies, logger):
        image_folder = os.path.join(root, 'curated_malaria_dataset_manual_annotations')
        gt_folder = os.path.join(root, 'segmentations')
        if not os.path.isdir(image_folder):
            raise FileNotFoundError(
                f"Expected raw images at {image_folder}.\n"
                f"Either point --data_path at the dataset root with that subdirectory, "
                f"or provide pre-built tensors under {os.path.join(root, 'cached')}/.")

        transform = transforms.Compose([
            transforms.ToPILImage(),
            transforms.Resize((32, 32)),
            transforms.ToTensor(),
        ])

        normal_all, abnormal_all = [], []
        for file_name in tqdm(sorted(os.listdir(image_folder)), desc="Extracting patches"):
            if not file_name.endswith(('.png', '.jpg', '.jpeg', '.tif', '.tiff')):
                continue
            try:
                file_idx = int(file_name[:4])
            except ValueError:
                continue
            if file_idx not in file_range:
                continue

            image = np.asarray(Image.open(os.path.join(image_folder, file_name)).convert('RGB'))
            mask_all_name = f"{file_idx:04d}_seg_abnormal.png"
            mask_all_path = os.path.join(image_folder, mask_all_name)
            if not os.path.exists(mask_all_path):
                logger.warning("Skipping %s \u2014 missing mask %s", file_name, mask_all_name)
                continue
            mask_all = np.asarray(Image.open(mask_all_path).convert('L'))

            normal_data, abnormal_data = [], []
            for x in range(0, image.shape[0], _STEP):
                for y in range(0, image.shape[1], _STEP):
                    if x + _PATCH_SIZE > image.shape[0] or y + _PATCH_SIZE > image.shape[1]:
                        continue
                    patch = image[x:x + _PATCH_SIZE, y:y + _PATCH_SIZE]
                    mask_patch = mask_all[x:x + _PATCH_SIZE, y:y + _PATCH_SIZE]
                    anomaly_frac = mask_patch.sum() / (mask_patch.size * 255.0)
                    if anomaly_frac == 0:
                        normal_data.append(transform(patch))
                    elif anomaly_frac > _ANOMALY_FRACTION_THRESHOLD:
                        abnormal_data.append(transform(patch))

            for class_name in _ANOMALY_CLASSES:
                mask_path = os.path.join(gt_folder, f"{file_idx - 1:04d}_seg_abnormal_{class_name}.png")
                if not os.path.exists(mask_path):
                    continue
                mask = np.asarray(Image.open(mask_path).convert('L'))
                for x in range(0, image.shape[0], _STEP):
                    for y in range(0, image.shape[1], _STEP):
                        if x + _PATCH_SIZE > image.shape[0] or y + _PATCH_SIZE > image.shape[1]:
                            continue
                        patch = image[x:x + _PATCH_SIZE, y:y + _PATCH_SIZE]
                        mask_patch = mask[x:x + _PATCH_SIZE, y:y + _PATCH_SIZE]
                        anomaly_frac = mask_patch.sum() / (mask_patch.size * 255.0)
                        if anomaly_frac > _ANOMALY_FRACTION_THRESHOLD:
                            abnormal_data.append(transform(patch))

            if abnormal_data:
                normal_data = random.sample(normal_data, min(len(normal_data), len(abnormal_data)))
                normal_all.extend(normal_data)
                abnormal_all.extend(abnormal_data)

            if len(abnormal_all) >= target_anomalies:
                break

        data_full = normal_all + abnormal_all
        label_full = [0] * len(normal_all) + [1] * len(abnormal_all)
        return data_full, label_full


class _MalariaPatchDataset(Dataset):
    def __init__(self, tensor_batch, targets, train: bool = False):
        self.train = train
        self.tensor_batch = tensor_batch
        self.targets = targets
        self.semi_targets = torch.zeros_like(torch.tensor(self.targets))

    def __len__(self):
        return len(self.tensor_batch)

    def __getitem__(self, index):
        img = self.tensor_batch[index]
        target = self.targets[index]
        semi_target = int(self.semi_targets[index])

        if self.train:
            img = np.array(img)
            out = np.copy(img)
            num_salt = int(np.ceil(_SP_AMOUNT_TRAIN * img.size * _SP_RATIO))
            coords = tuple(np.random.randint(0, dim - 1, num_salt) for dim in img.shape)
            out[coords] = 1
            num_pepper = int(np.ceil(_SP_AMOUNT_TRAIN * img.size * (1.0 - _SP_RATIO)))
            coords = tuple(np.random.randint(0, dim - 1, num_pepper) for dim in img.shape)
            out[coords] = 0
            img = out

        return img, target, semi_target, index

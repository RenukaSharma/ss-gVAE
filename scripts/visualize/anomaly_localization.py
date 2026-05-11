"""Image-level anomaly localization with a trained ss-gVAE / Deep SAD model.

This script reproduces the qualitative image-level anomaly maps used in the
thesis revisions of the WACV 2022 paper (Chapter 3 of Renuka Sharma's PhD
thesis, post-review additions). It slides a fixed-size patch window across
each test image, scores each patch with the trained autoencoder, and writes
the resulting per-pixel heatmap to disk.

Supported scoring modes (``--score-mode``):

* ``sample_log_norm`` (default): ``log(||sample||^2)`` of the reparameterized
  GG sample. Matches the published "Option 2" formulation.
* ``sample_norm``:   ``||sample||^2``.
* ``mu_norm``:       ``||x_encoded_mu||^2`` -- distance of the latent mean
  from the hypersphere centre.
* ``residual_mse``:  per-pixel MSE between input patch and decoder mean.

Usage examples
--------------

Malaria (sliding 33x33 patches over 1200x1600 RGB slides with paired
abnormality masks)::

    python scripts/visualize/anomaly_localization.py \\
        --dataset malaria \\
        --model-path ${RESULTS_DIR}/malaria/.../model.tar \\
        --image-dir ${MALARIA_DATA}/test \\
        --output-dir ${RESULTS_DIR}/malaria/localization

MVTec (sliding 33x33 patches over 1024x1024 single-channel images)::

    python scripts/visualize/anomaly_localization.py \\
        --dataset mvtec --category leather \\
        --model-path ${RESULTS_DIR}/mvtec/leather/.../model.tar \\
        --image-dir ${MVTEC_DATA}/leather/test/cut \\
        --output-dir ${RESULTS_DIR}/mvtec/leather/localization

Notes
-----
The patch-extraction logic, the 16-pixel zero-pad border, and the optional
post-hoc Gaussian smoothing are kept faithful to the thesis script
``main_reviews_visualize_*_image_level_run.py``; only the path handling and
output destructuring have been modernized.
"""

import argparse
import logging
import os
import sys
import time
from pathlib import Path

import numpy as np
import torch
import torchvision.transforms as transforms
from PIL import Image
from scipy.ndimage import gaussian_filter
from tqdm import tqdm

THIS_FILE = Path(__file__).resolve()
SRC_DIR = THIS_FILE.parent.parent.parent / "src"
sys.path.insert(0, str(SRC_DIR))

from networks.main import build_autoencoder  # noqa: E402


def _make_transform(patch_resize=32):
    return transforms.Compose(
        [
            transforms.ToPILImage(),
            transforms.Resize((patch_resize, patch_resize)),
            transforms.ToTensor(),
        ]
    )


def _load_autoencoder(model_path, net_name, device):
    state = torch.load(model_path, map_location=device)
    ae_net = build_autoencoder(net_name)
    ae_net.load_state_dict(state["ae_net_dict"])
    ae_net = ae_net.to(device=device).eval()
    return ae_net


def _score_patch_batch(ae_net, batch, score_mode, ablation_type, eps):
    """Run the AE forward on a batch of patches and return per-patch scores."""
    out = ae_net(batch, ablation_type=ablation_type, eps=eps)
    # Networks in this repo return:
    #   (x_encoded_mu, x_encoded_alpha, x_encoded_beta,
    #    x_recons_mu,   x_recons_alpha,   x_recons_beta, sample)
    x_encoded_mu = out[0]
    x_recons_mu = out[3]
    sample = out[-1]

    if score_mode == "sample_log_norm":
        return torch.log(torch.norm(sample, dim=1) ** 2)
    if score_mode == "sample_norm":
        return torch.norm(sample, dim=1) ** 2
    if score_mode == "mu_norm":
        return torch.norm(x_encoded_mu, dim=1) ** 2
    if score_mode == "residual_mse":
        return torch.mean((batch - x_recons_mu) ** 2, dim=(1, 2, 3))
    raise ValueError(f"Unknown score-mode: {score_mode!r}")


def _slide_patches(image_padded, h, w, pad, stride):
    """Yield (row_idx, col_idx, patch) triples for a single image."""
    patch_half = pad  # implied 2*pad+1 patch size, default 33x33
    patch_side = 2 * patch_half + 1
    for j in range(pad, h + pad, stride):
        for i in range(pad, w + pad, stride):
            yield j, i, image_padded[
                j - patch_half : j + patch_half + 1,
                i - patch_half : i + patch_half + 1,
                :,
            ].copy()


def _save_heatmap(scores_2d, dest_path, gaussian_sigma):
    mat = scores_2d.astype(np.float32)
    if not np.isfinite(mat).all():
        mat = np.nan_to_num(mat, nan=mat[np.isfinite(mat)].min())
    mat = (255.0 * (mat - mat.min()) / max(mat.max() - mat.min(), 1e-9)).astype(np.uint8)
    if gaussian_sigma > 0:
        mat = gaussian_filter(mat, gaussian_sigma)
    Image.fromarray(mat).convert("L").save(dest_path)


def _process_malaria(args, ae_net, device):
    logger = logging.getLogger(__name__)
    transform = _make_transform(args.patch_resize)
    pad = args.patch_resize // 2  # 16 for 32x32 patches

    image_files = sorted(
        fn for fn in os.listdir(args.image_dir)
        if fn.endswith("_img.png")
    )
    if args.max_images:
        image_files = image_files[: args.max_images]

    for file_name in tqdm(image_files, desc="malaria"):
        image_path = os.path.join(args.image_dir, file_name)
        mask_path = os.path.join(args.image_dir, file_name[:-8] + "_seg_abnormal.png")
        if not os.path.exists(mask_path):
            logger.warning("Skipping %s: no paired mask at %s", file_name, mask_path)
            continue

        image = np.asarray(Image.open(image_path))
        mask = np.asarray(Image.open(mask_path))
        h, w, c = image.shape

        image_padded = np.zeros((h + 2 * pad, w + 2 * pad, c), dtype="uint8")
        mask_padded = np.zeros((h + 2 * pad, w + 2 * pad), dtype="uint8")
        image_padded[pad : h + pad, pad : w + pad, :] = image[:h, :w, :]
        mask_padded[pad : h + pad, pad : w + pad] = mask[:h, :w]

        scores_rows = []
        patch_side = 2 * pad + 1
        for j in range(pad, h + pad, args.patch_stride):
            tensor_row, labels_row = [], []
            for i in range(pad, w + pad, args.patch_stride):
                patch = image_padded[j - pad : j + pad + 1, i - pad : i + pad + 1, :]
                patch_mask = mask_padded[j - pad : j + pad + 1, i - pad : i + pad + 1]
                tensor_row.append(transform(patch))
                labels_row.append(float(patch_mask.sum()) / (patch_side ** 2))

            batch = torch.stack(tensor_row, 0).to(device=device)
            with torch.no_grad():
                scores = _score_patch_batch(
                    ae_net, batch, args.score_mode, args.ablation_type, args.eps
                )
            scores = scores.cpu().numpy() * np.asarray(labels_row)
            scores_rows.append(scores)

        scores_2d = np.asarray(scores_rows)
        stem = file_name[:-4]
        np.save(os.path.join(args.output_dir, f"{stem}_scores.npy"), scores_2d)
        _save_heatmap(
            scores_2d,
            os.path.join(args.output_dir, f"{stem}_heatmap.png"),
            args.gaussian_sigma,
        )


def _process_mvtec(args, ae_net, device):
    logger = logging.getLogger(__name__)
    transform = _make_transform(args.patch_resize)
    pad = args.patch_resize // 2

    image_files = sorted(
        fn for fn in os.listdir(args.image_dir)
        if fn.lower().endswith((".png", ".jpg", ".jpeg"))
    )
    if args.max_images:
        image_files = image_files[: args.max_images]

    for file_name in tqdm(image_files, desc=f"mvtec/{args.category or ''}"):
        image = np.asarray(Image.open(os.path.join(args.image_dir, file_name)).convert("RGB"))
        h, w, c = image.shape
        image_padded = np.zeros((h + 2 * pad, w + 2 * pad, c), dtype="uint8")
        image_padded[pad : h + pad, pad : w + pad, :] = image[:h, :w, :]

        scores_rows = []
        for j in range(pad, h + pad, args.patch_stride):
            tensor_row = []
            for i in range(pad, w + pad, args.patch_stride):
                patch = image_padded[j - pad : j + pad + 1, i - pad : i + pad + 1, :]
                tensor_row.append(transform(patch))

            batch = torch.stack(tensor_row, 0).to(device=device)
            with torch.no_grad():
                scores = _score_patch_batch(
                    ae_net, batch, args.score_mode, args.ablation_type, args.eps
                )
            scores_rows.append(scores.cpu().numpy())

        scores_2d = np.asarray(scores_rows)
        stem = os.path.splitext(file_name)[0]
        prefix = f"{args.category}_{stem}" if args.category else stem
        np.save(os.path.join(args.output_dir, f"{prefix}_scores.npy"), scores_2d)
        _save_heatmap(
            scores_2d,
            os.path.join(args.output_dir, f"{prefix}_heatmap.png"),
            args.gaussian_sigma,
        )


def main():
    parser = argparse.ArgumentParser(
        description=__doc__.splitlines()[0],
        formatter_class=argparse.RawDescriptionHelpFormatter,
    )
    parser.add_argument("--dataset", choices=("malaria", "mvtec"), required=True)
    parser.add_argument("--category", default=None,
                        help="MVTec category (carpet, leather, tile, wood, ...). "
                             "Used only for output filename prefixing.")
    parser.add_argument("--model-path", required=True,
                        help="Path to a trained model.tar (saved via DeepSAD.save_model).")
    parser.add_argument("--image-dir", required=True,
                        help="Directory containing test images.")
    parser.add_argument("--output-dir", required=True,
                        help="Directory where heatmaps (.png) and score arrays (.npy) are written.")
    parser.add_argument("--net-name", default="cifar10_LeNet",
                        help="Network architecture name (must match the trained model; default: cifar10_LeNet).")
    parser.add_argument("--ablation-type", default="A",
                        help="Ablation type used during training (A is the full ss-gVAE).")
    parser.add_argument("--score-mode", default="sample_log_norm",
                        choices=("sample_log_norm", "sample_norm", "mu_norm", "residual_mse"))
    parser.add_argument("--patch-resize", type=int, default=32,
                        help="Patch size after resize; must match the AE input size.")
    parser.add_argument("--patch-stride", type=int, default=1,
                        help="Sliding-window stride in pixels.")
    parser.add_argument("--gaussian-sigma", type=float, default=0.0,
                        help="If >0, smooth the heatmap with this Gaussian sigma before saving.")
    parser.add_argument("--eps", type=float, default=1e-5,
                        help="Numerical eps passed to the AE forward.")
    parser.add_argument("--max-images", type=int, default=0,
                        help="If >0, stop after this many images (useful for debugging).")
    parser.add_argument("--device", default="cuda:0" if torch.cuda.is_available() else "cpu")
    args = parser.parse_args()

    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(message)s")
    os.makedirs(args.output_dir, exist_ok=True)

    ae_net = _load_autoencoder(args.model_path, args.net_name, args.device)

    t0 = time.time()
    if args.dataset == "malaria":
        _process_malaria(args, ae_net, args.device)
    else:
        _process_mvtec(args, ae_net, args.device)
    logging.info("Done in %.1fs", time.time() - t0)


if __name__ == "__main__":
    main()

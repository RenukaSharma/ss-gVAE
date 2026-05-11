from .mnist import MNIST_Dataset
from .fmnist import FashionMNIST_Dataset
from .cifar10 import CIFAR10_Dataset
from .mvtec import MVTec_Dataset
from .malaria import Malaria_Dataset
from .synthetic import Synthetic_Dataset


def load_dataset(dataset_name, data_path, normal_class, known_outlier_class, n_known_outlier_classes: int = 0,
                 ratio_known_normal: float = 0.0, ratio_known_outlier: float = 0.0, ratio_pollution: float = 0.0,
                 random_state=None, length=5000, category: str = 'carpet'):
    """Loads the dataset."""

    implemented_datasets = ('mnist', 'fmnist', 'cifar10', 'mvtec', 'malaria_dataset', 'synthetic')
    assert dataset_name in implemented_datasets, \
        f"Unknown dataset '{dataset_name}'. Choose from {implemented_datasets}."

    dataset = None

    if dataset_name == 'mnist':
        dataset = MNIST_Dataset(root=data_path,
                                normal_class=normal_class,
                                known_outlier_class=known_outlier_class,
                                n_known_outlier_classes=n_known_outlier_classes,
                                ratio_known_normal=ratio_known_normal,
                                ratio_known_outlier=ratio_known_outlier,
                                ratio_pollution=ratio_pollution)

    if dataset_name == 'fmnist':
        dataset = FashionMNIST_Dataset(root=data_path,
                                       normal_class=normal_class,
                                       known_outlier_class=known_outlier_class,
                                       n_known_outlier_classes=n_known_outlier_classes,
                                       ratio_known_normal=ratio_known_normal,
                                       ratio_known_outlier=ratio_known_outlier,
                                       ratio_pollution=ratio_pollution)

    if dataset_name == 'cifar10':
        dataset = CIFAR10_Dataset(root=data_path,
                                  normal_class=normal_class,
                                  known_outlier_class=known_outlier_class,
                                  n_known_outlier_classes=n_known_outlier_classes,
                                  ratio_known_normal=ratio_known_normal,
                                  ratio_known_outlier=ratio_known_outlier,
                                  ratio_pollution=ratio_pollution,
                                  length=length)

    if dataset_name == 'mvtec':
        dataset = MVTec_Dataset(root=data_path,
                                normal_class=normal_class,
                                known_outlier_class=known_outlier_class,
                                n_known_outlier_classes=n_known_outlier_classes,
                                ratio_known_normal=ratio_known_normal,
                                ratio_known_outlier=ratio_known_outlier,
                                ratio_pollution=ratio_pollution,
                                category=category)

    if dataset_name == 'malaria_dataset':
        dataset = Malaria_Dataset(root=data_path,
                                  normal_class=normal_class,
                                  known_outlier_class=known_outlier_class,
                                  n_known_outlier_classes=n_known_outlier_classes,
                                  ratio_known_normal=ratio_known_normal,
                                  ratio_known_outlier=ratio_known_outlier,
                                  ratio_pollution=ratio_pollution)

    if dataset_name == 'synthetic':
        dataset = Synthetic_Dataset(root=data_path,
                                    normal_class=normal_class,
                                    known_outlier_class=known_outlier_class,
                                    n_known_outlier_classes=n_known_outlier_classes,
                                    ratio_known_normal=ratio_known_normal,
                                    ratio_known_outlier=ratio_known_outlier,
                                    ratio_pollution=ratio_pollution)

    return dataset

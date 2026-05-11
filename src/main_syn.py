"""Generate the WACV 2022 synthetic dataset.

Samples 32x32 RGB patches from a generalized Gaussian distribution with two
distinct parameter regimes (normal vs. abnormal). Writes four tensor files to
``--root``::

    <root>/train_syn_data.pt
    <root>/train_syn_label.pt
    <root>/test_syn_data.pt
    <root>/test_syn_label.pt

These are the inputs the ``synthetic`` dataset loader expects.

Example::

    python src/main_syn.py --root data/synthetic --train_size 5000 --test_size 1250
"""

import argparse
import os

import numpy as np
import torch
from torch.distributions.gamma import Gamma
from torch.distributions.uniform import Uniform
from torchvision import transforms
from tqdm import tqdm


def sample_ggd(mu, alpha, beta):
    """Sample from a generalized-Gaussian distribution via Gamma + Bernoulli sign."""
    gamma = Gamma(1.0 / beta, 1)
    y = gamma.rsample()
    sign = torch.bernoulli(torch.ones(mu.shape) * 0.5) - 0.5
    return mu + 2 * alpha * sign * (y ** (1.0 / beta))


def _generate_split(n_samples, mu_uniform, alpha_uniform, beta_uniform, label):
    transform = transforms.Compose([transforms.ToPILImage(), transforms.ToTensor()])
    data, labels = [], []
    for _ in tqdm(range(n_samples), desc=f"label={label}"):
        mu = mu_uniform.sample(sample_shape=(32, 32, 3))
        alpha = alpha_uniform.sample(sample_shape=(32, 32, 3))
        beta = beta_uniform.sample(sample_shape=(32, 32, 3))
        gg = sample_ggd(mu, alpha, beta).numpy()
        img = (gg - gg.min()) / (gg.max() - gg.min())
        img = (img * 255).astype(np.uint8)
        data.append(transform(img))
        labels.append(label)
    return data, labels


def main():
    parser = argparse.ArgumentParser(description=__doc__,
                                     formatter_class=argparse.RawDescriptionHelpFormatter)
    parser.add_argument('--root', required=True,
                        help='Output directory for the four .pt tensors.')
    parser.add_argument('--train_size', type=int, default=5000,
                        help='Number of training samples per class (default: 5000).')
    parser.add_argument('--test_size', type=int, default=1250,
                        help='Number of test samples per class (default: 1250).')
    parser.add_argument('--seed', type=int, default=0)
    args = parser.parse_args()

    torch.manual_seed(args.seed)
    np.random.seed(args.seed)

    os.makedirs(args.root, exist_ok=True)

    normal_mu = Uniform(0., 1.)
    normal_alpha = Uniform(0.5, 1.5)
    normal_beta = Uniform(0.5, 2.0)
    abnormal_mu = Uniform(1., 2.)
    abnormal_alpha = Uniform(1.5, 2.5)
    abnormal_beta = Uniform(2.0, 3.5)

    print("Generating train set ...")
    train_n_data, train_n_lab = _generate_split(args.train_size, normal_mu,
                                                normal_alpha, normal_beta, label=0)
    train_a_data, train_a_lab = _generate_split(args.train_size, abnormal_mu,
                                                abnormal_alpha, abnormal_beta, label=1)
    torch.save(train_n_data + train_a_data, os.path.join(args.root, 'train_syn_data.pt'))
    torch.save(train_n_lab + train_a_lab, os.path.join(args.root, 'train_syn_label.pt'))

    print("Generating test set ...")
    test_n_data, test_n_lab = _generate_split(args.test_size, normal_mu,
                                              normal_alpha, normal_beta, label=0)
    test_a_data, test_a_lab = _generate_split(args.test_size, abnormal_mu,
                                              abnormal_alpha, abnormal_beta, label=1)
    torch.save(test_n_data + test_a_data, os.path.join(args.root, 'test_syn_data.pt'))
    torch.save(test_n_lab + test_a_lab, os.path.join(args.root, 'test_syn_label.pt'))

    print(f"Wrote synthetic dataset to {args.root}")


if __name__ == '__main__':
    main()

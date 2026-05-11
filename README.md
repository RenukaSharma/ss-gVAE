# ss-gVAE

Reference implementation for the WACV 2022 paper
**"A Semi-Supervised Generalized VAE Framework for Abnormality Detection
Using One-Class Classification"**.

[`Paper (CVF open-access)`](https://openaccess.thecvf.com/content/WACV2022/papers/Sharma_A_Semi-Supervised_Generalized_VAE_Framework_for_Abnormality_Detection_Using_One-Class_WACV_2022_paper.pdf)
| [`Deep SAD (upstream framework)`](https://openreview.net/forum?id=HkgH0TEYwH)

<p align="center">
  <img src="docs/figures/architecture.png" alt="ss-gVAE architecture" width="92%">
</p>

> **Figure 1.** *Semi-Supervised Generalized VAE (ss-gVAE) learning framework
> for one-class classification.* The DNN encoder maps each input image to a
> factored generalized-Gaussian (GG) distribution in latent space,
> parameterized by per-dimension mean, log-scale, and log-shape vectors. A
> reparameterized GG sample is decoded back to image space under another
> factored GG; the GG family subsumes robust and uncertainty-aware modelling
> as special cases. The framework is extended to the semi-supervised regime by
> separating the latent distributions of unlabeled inliers and a small set of
> labeled outliers. At test time, a sample is scored by the norm of its
> latent mean.

## Overview

We address the **one-class classification / anomaly detection** problem in the
semi-supervised setting: lots of unlabeled data, a small pool of labeled
normal samples, and an even smaller pool of labeled anomalies. The method
combines a **variational autoencoder with a generalized-Gaussian (GG)
distribution** in latent space and a **Deep SAD-style hypersphere objective**.

Experiments cover:

- A controlled **synthetic** dataset (GG-distributed RGB patches with two
  parameter regimes)
- **MNIST**, **Fashion-MNIST**, **CIFAR-10** (one-class versus rest)
- **MVTec AD** (texture and object categories)
- **Malaria** patch-based dataset (a manually-annotated medical dataset
  released alongside this code, see "Data" below)

## Results

All plots reproduce figures from the paper. Each panel shows AUC as a
function of the supervision level &gamma; (the fraction of labeled outliers
in the training set), with error bars from 20 independent
train/val/test splits.

### MNIST, Fashion-MNIST, CIFAR-10

<table>
  <tr>
    <td align="center"><b>MNIST &mdash; baselines</b></td>
    <td align="center"><b>Fashion-MNIST &mdash; baselines</b></td>
    <td align="center"><b>CIFAR-10 &mdash; baselines</b></td>
  </tr>
  <tr>
    <td><img src="docs/figures/mnist_baselines.png" alt="MNIST baselines"></td>
    <td><img src="docs/figures/fmnist_baselines.png" alt="Fashion-MNIST baselines"></td>
    <td><img src="docs/figures/cifar10_baselines.png" alt="CIFAR-10 baselines"></td>
  </tr>
  <tr>
    <td align="center"><b>MNIST &mdash; ablations</b></td>
    <td align="center"><b>Fashion-MNIST &mdash; ablations</b></td>
    <td align="center"><b>CIFAR-10 &mdash; ablations</b></td>
  </tr>
  <tr>
    <td><img src="docs/figures/mnist_ablation.png" alt="MNIST ablation"></td>
    <td><img src="docs/figures/fmnist_ablation.png" alt="Fashion-MNIST ablation"></td>
    <td><img src="docs/figures/cifar10_ablation.png" alt="CIFAR-10 ablation"></td>
  </tr>
</table>

### MVTec AD (carpet category)

<p align="center">
  <img src="docs/figures/mvtec_carpet_baselines.png" alt="MVTec Carpet baselines" width="46%">
  &nbsp;
  <img src="docs/figures/mvtec_carpet_ablation.png" alt="MVTec Carpet ablation" width="46%">
</p>

### Malaria dataset

<p align="center">
  <img src="docs/figures/malaria_baselines.png" alt="Malaria baselines" width="46%">
  &nbsp;
  <img src="docs/figures/malaria_ablation.png" alt="Malaria ablation" width="46%">
</p>

t-SNE projections of the test-set latent encodings on the malaria dataset
(normal RBCs in olive, abnormal in salmon). The top row is ss-gVAE; the
bottom row is Deep SAD; supervision level increases left to right:

<table>
  <tr>
    <td></td>
    <td align="center"><b>&gamma; = 0</b></td>
    <td align="center"><b>&gamma; = 0.2</b></td>
    <td align="center"><b>fully supervised</b></td>
  </tr>
  <tr>
    <td align="right"><b>ss-gVAE</b></td>
    <td><img src="docs/figures/tsne/malaria_ssgvae_0sup.png" alt="ss-gVAE 0sup"></td>
    <td><img src="docs/figures/tsne/malaria_ssgvae_0p2sup.png" alt="ss-gVAE 0.2sup"></td>
    <td><img src="docs/figures/tsne/malaria_ssgvae_fullsup.png" alt="ss-gVAE fullsup"></td>
  </tr>
  <tr>
    <td align="right"><b>Deep SAD</b></td>
    <td><img src="docs/figures/tsne/malaria_deepsad_0sup.png" alt="DeepSAD 0sup"></td>
    <td><img src="docs/figures/tsne/malaria_deepsad_0p2sup.png" alt="DeepSAD 0.2sup"></td>
    <td><img src="docs/figures/tsne/malaria_deepsad_fullsup.png" alt="DeepSAD fullsup"></td>
  </tr>
</table>

<p align="center">
  <img src="docs/figures/tsne/legend.png" alt="t-SNE legend" width="40%">
</p>

### Synthetic dataset

<p align="center">
  <img src="docs/figures/synthetic_baselines.png" alt="Synthetic baselines" width="60%">
</p>

t-SNE projections of the test-set latent encodings on the synthetic
dataset (same row/column convention as above):

<table>
  <tr>
    <td></td>
    <td align="center"><b>&gamma; = 0</b></td>
    <td align="center"><b>&gamma; = 0.2</b></td>
    <td align="center"><b>fully supervised</b></td>
  </tr>
  <tr>
    <td align="right"><b>ss-gVAE</b></td>
    <td><img src="docs/figures/tsne/synthetic_ssgvae_0sup.png" alt="ss-gVAE 0sup syn"></td>
    <td><img src="docs/figures/tsne/synthetic_ssgvae_0p2sup.png" alt="ss-gVAE 0.2sup syn"></td>
    <td><img src="docs/figures/tsne/synthetic_ssgvae_fullsup.png" alt="ss-gVAE fullsup syn"></td>
  </tr>
  <tr>
    <td align="right"><b>Deep SAD</b></td>
    <td><img src="docs/figures/tsne/synthetic_deepsad_0sup.png" alt="DeepSAD 0sup syn"></td>
    <td><img src="docs/figures/tsne/synthetic_deepsad_0p2sup.png" alt="DeepSAD 0.2sup syn"></td>
    <td><img src="docs/figures/tsne/synthetic_deepsad_fullsup.png" alt="DeepSAD fullsup syn"></td>
  </tr>
</table>

For per-figure reproduction commands see
[`docs/reproducing_paper.md`](docs/reproducing_paper.md).

## Repository layout

```text
ss-gVAE/
├── src/                        # main codebase (ss-gVAE + baselines)
│   ├── base/                   # base Dataset / Net / Trainer abstractions
│   ├── networks/               # LeNet, VAE, GG, MVTec, Malaria nets
│   ├── optim/                  # trainers: DeepSAD, AE, VAE, SemiDGM, drocclf
│   ├── datasets/               # mnist / fmnist / cifar10 / mvtec / malaria / synthetic
│   ├── baselines/              # shallow baselines (OCSVM, KDE, IsoForest, SSAD, SemiDGM)
│   ├── utils/                  # config, misc, plotting helpers
│   ├── main.py                 # DeepSAD-style entry point
│   ├── main_syn.py             # generate the synthetic dataset
│   ├── main_BinClassification.py  # binary-classification entry point
│   ├── DeepSAD.py              # ss-gVAE / Deep SAD model class
│   └── baseline_*.py           # shallow baseline entry points
├── binary_classifier/          # binary-classifier baseline (separate package)
├── scripts/                    # parametrized shell scripts (one per dataset)
│   ├── plots/                  # t-SNE plotters (analysis utilities)
│   ├── synthetic_analysis/     # ablation / silhouette / OPTICS scripts
│   └── visualize/              # image-level anomaly-map visualizer (malaria / MVTec)
├── data_prep/mvtec/            # MVTec patch curation utilities
├── docs/
│   ├── reproducing_paper.md    # detailed reproduction instructions
│   └── figures/                # figures from the paper used by this README
├── environment.yml             # conda env matching original research setup
├── requirements.txt            # legacy pip requirements (Python 3.7)
└── examples/                   # tiny per-dataset samples for smoke tests
```

## Quick start

```bash
# 1. Create the conda environment (PyTorch 1.1.0 / Python 3.7)
conda env create -f environment.yml
conda activate ss-gvae

# 2. Set paths (drop into ~/.ss-gvae.env to source later)
export DATA_DIR=$HOME/data
export RESULTS_DIR=$HOME/results/ss-gvae
export SYNTHETIC_DATA=$DATA_DIR/synthetic
export MALARIA_DATA=$DATA_DIR/malaria
export MVTEC_DATA=$DATA_DIR/mvtec

# 3. Generate the synthetic dataset
python src/main_syn.py --root $SYNTHETIC_DATA

# 4. Train the ss-gVAE on the synthetic dataset
cd src
python main.py synthetic cifar10_LeNet \
    $RESULTS_DIR/synthetic/run_1 \
    $SYNTHETIC_DATA \
    --ratio_known_outlier 0.2 \
    --n_epochs 75 --batch_size 128 \
    --recon_param 1 --latent_param 0.5 --eta 1 \
    --eps 0.1 --tau 0.1 --delta 0.1 \
    --ablation_type A --seed 1
```

The output directory (`$RESULTS_DIR/synthetic/run_1`) will contain
`log.txt`, `config.json`, `results.json`, `model.tar`, and figures showing
the highest- and lowest-scoring test patches.

For the full per-dataset run sweeps used in the paper, see the scripts in
`scripts/` and the detailed walk-through in
[`docs/reproducing_paper.md`](docs/reproducing_paper.md).

## Datasets supported

| `dataset_name`     | `net_name`        | Notes                                       |
| ------------------ | ----------------- | ------------------------------------------- |
| `synthetic`        | `cifar10_LeNet`   | Generate first via `src/main_syn.py`        |
| `mnist`            | `mnist_LeNet`     | Auto-downloaded by torchvision              |
| `fmnist`           | `fmnist_LeNet`    | Auto-downloaded                             |
| `cifar10`          | `cifar10_LeNet`   | Auto-downloaded                             |
| `mvtec`            | `mvtec_net`       | Download MVTec AD separately                |
| `malaria_dataset`  | `malaria_net`     | Released on Zenodo (DOI: TBD)               |

## Data

The malaria patch-based dataset annotated for this paper is released
separately under **CC BY 4.0** with a permanent DOI; see <https://zenodo.org/>
(DOI to be filled in once published) and the mirror on Hugging Face Datasets.

## Image-level anomaly maps

To produce per-pixel anomaly heatmaps on full malaria slides or MVTec
test images (as in the thesis revisions of the paper):

```bash
python scripts/visualize/anomaly_localization.py \
    --dataset malaria \
    --model-path $RESULTS_DIR/malaria/.../model.tar \
    --image-dir  $MALARIA_DATA/test \
    --output-dir $RESULTS_DIR/malaria/localization
```

See [`scripts/visualize/README.md`](scripts/visualize/README.md) for the
MVTec variant and the full CLI.

## Method ablations

Pass `--ablation_type {A,B,C,C_a,D,E,VAE,test,DeepSAD}` to `src/main.py` to
select among the loss-configuration ablations reported in the paper.
`A` is the full proposed model (ss-gVAE); `DeepSAD` reduces to the upstream
Deep SAD baseline.

## Place in the PhD thesis

This work is **Chapter 3** of the PhD thesis *"Anomaly Detection in Images Using
One-class and Multi-class Learning Approaches"* (Renuka Sharma, IITB-Monash
Research Academy, 2022).

- Monash Bridges: <https://bridges.monash.edu/articles/thesis/Anomaly_Detection_in_Images_Using_One-class_and_Multi-class_Learning_Approaches/23584503>
- DOI: [`10.26180/23584503`](https://doi.org/10.26180/23584503)

Companion repositories from the same thesis:

| Chapter | Topic                                       | Repository                    |
| ------- | ------------------------------------------- | ----------------------------- |
| Ch. 3   | ss-gVAE &mdash; this repository             | [`ss-gVAE`](https://github.com/RenukaSharma/ss-gVAE) (here)   |
| Ch. 4   | RU-VAE (ISBI 2022)                          | Paper: [IEEE Xplore](https://ieeexplore.ieee.org/abstract/document/9761472) · code: *coming soon* |
| Ch. 5   | ss-ms-gVAE (Neurocomputing)                 | Paper: [ScienceDirect](https://www.sciencedirect.com/science/article/pii/S092523122401943X) · code: *coming soon* |
| Ch. 6   | Anomaly localization (ss-vq-vae)            | [`ss-vq-vae`](https://github.com/RenukaSharma/ss-vq-vae) (in preparation) |

The RU-VAE (Ch. 4) camera-ready PDF is also available on [Google Drive](https://drive.google.com/file/d/1fapKVmd193qVkeJokayVqOOKCsm52Kqg/view).

## Citation

```bibtex
@inproceedings{Sharma2022WACV,
  title     = {A Semi-Supervised Generalized {VAE} Framework for Abnormality
               Detection Using One-Class Classification},
  author    = {Sharma, Renuka and Mashkaria, Satvik and Awate, Suyash P.},
  booktitle = {IEEE/CVF Winter Conference on Applications of Computer Vision (WACV)},
  year      = {2022}
}

@phdthesis{Sharma2022Thesis,
  title  = {Anomaly Detection in Images Using One-class and Multi-class Learning Approaches},
  author = {Sharma, Renuka},
  school = {Monash University \& IIT Bombay},
  year   = {2022},
  doi    = {10.26180/23584503}
}
```

## Acknowledgements

- Built upon **Deep SAD** by Ruff *et al.* (ICLR 2020):
  <https://github.com/lukasruff/Deep-SAD-PyTorch>.
- The shallow-SSAD implementation is adapted from the original SSAD code by
  Görnitz *et al.*

Scientific authorship for the WACV 2022 work is exactly as in the **Citation**
section (BibTeX and `CITATION.cff` preferred citation). Assistance with
repository preparation, editing, or tooling does **not** constitute
co-authorship of the paper; you may add any such acknowledgements here.

## License

This code is released under the **MIT License**; see
[`LICENSE`](LICENSE). The accompanying malaria dataset is released under
**CC BY 4.0** (see Zenodo record). The figures under `docs/figures/` are
reproduced from the published paper and are covered by the same MIT
License attached to this repository.

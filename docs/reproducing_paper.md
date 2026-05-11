# Reproducing the WACV 2022 paper

This document gives step-by-step instructions for reproducing the experiments
in *"A Semi-Supervised Generalized VAE Framework for Abnormality Detection
Using One-Class Classification"*.

## 1. Set up the environment

```bash
conda env create -f environment.yml
conda activate ss-generalized-vae
```

The pinned versions (PyTorch 1.1.0, Python 3.7) match the original research
environment used at the time of submission. If you only have access to newer
CUDA, see [docs/modern_environment.md](modern_environment.md) (TODO) for
a Pytorch 1.13+ port. Most things still work; a couple of `torch.distributions`
calls may need light adjustment.

## 2. Set environment variables

All shell scripts in `scripts/` expect these variables to be set:

```bash
export RESULTS_DIR=$HOME/results/ss-gvae       # where to write run outputs
export DATA_DIR=$HOME/data                     # parent for all datasets
export MALARIA_DATA=$DATA_DIR/malaria          # malaria images + masks
export SYNTHETIC_DATA=$DATA_DIR/synthetic      # synthetic .pt files
export MVTEC_DATA=$DATA_DIR/mvtec              # MVTec AD dataset
```

You can drop these in a `~/.ss-gvae.env` file and `source` it.

## 3. Prepare the data

### Synthetic dataset (recommended starting point)

```bash
python src/main_syn.py --root $SYNTHETIC_DATA --train_size 5000 --test_size 1250
```

Produces `train_syn_data.pt`, `train_syn_label.pt`, `test_syn_data.pt`,
`test_syn_label.pt` under `$SYNTHETIC_DATA`.

### MNIST / Fashion-MNIST / CIFAR-10

These are downloaded automatically by torchvision on first run; just make sure
`$DATA_DIR` is writable.

### MVTec AD

Download from <https://www.mvtec.com/company/research/datasets/mvtec-ad/>
and unpack under `$MVTEC_DATA`. Curation utilities for the patch-based
variants used in the paper live under `data_prep/mvtec/`.

### Malaria

The annotated patches used in the paper are released separately (Zenodo DOI:
TBD). Download and unpack so that the layout is::

    $MALARIA_DATA/
      curated_malaria_dataset_manual_annotations/   # raw + abnormality masks
      segmentations/                                 # per-class masks

The loader will extract patches and cache them as `.pt` files under
`$MALARIA_DATA/cached/` on the first run.

## 4. Run experiments

The headline experiment from the paper is the synthetic-data ablation. From
the repo root::

    cd src
    bash ../scripts/run_synthetic_dataset_allBaselines.sh

This trains the ss-gVAE model (and the A/B/C/D/E ablations) over several
seeds, supervision ratios, and hyperparameter values. Expect several
GPU-hours per full sweep.

Equivalent scripts exist for every dataset; see `scripts/` for the full list.

## 5. Analyze results

After training, the analysis utilities under `scripts/synthetic_analysis/`
and `scripts/plots/` consume the `RESULTS_DIR` tree and produce CSVs and
figures used in the paper. These are interactive scripts; you will likely
edit the specific `load_model` paths near the top of each one to match your
run.

## 6. Citations

If this code is useful, please cite:

```bibtex
@inproceedings{Sharma2022WACV,
  title     = {A Semi-Supervised Generalized {VAE} Framework for Abnormality
               Detection Using One-Class Classification},
  author    = {Sharma, Renuka and Mashkaria, Satvik and Awate, Suyash P.},
  booktitle = {IEEE/CVF Winter Conference on Applications of Computer Vision (WACV)},
  year      = {2022}
}
```

And the upstream Deep SAD framework this code is built upon:

```bibtex
@inproceedings{Ruff2020DeepSAD,
  title     = {Deep Semi-Supervised Anomaly Detection},
  author    = {Ruff, Lukas and Vandermeulen, Robert A. and G{\"o}rnitz, Nico and
               Binder, Alexander and M{\"u}ller, Emmanuel and M{\"u}ller, Klaus-Robert
               and Kloft, Marius},
  booktitle = {International Conference on Learning Representations (ICLR)},
  year      = {2020}
}
```

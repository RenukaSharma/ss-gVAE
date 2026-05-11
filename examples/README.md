# Examples / smoke-test data

This folder is intentionally near-empty. We do **not** ship dataset samples
inside the repository to keep checkout size tiny and because most datasets
have separate licensing terms.

For a five-minute end-to-end smoke test, generate a miniature synthetic
dataset and train for a single epoch:

```bash
# 1. Generate ~30 KB of synthetic patches
python src/main_syn.py --root examples/synthetic --train_size 20 --test_size 10

# 2. Run a single-epoch training pass on a CPU
mkdir -p examples/smoketest_run
cd src
python main.py synthetic cifar10_LeNet \
    ../examples/smoketest_run \
    ../examples/synthetic \
    --ratio_known_outlier 0.2 \
    --n_epochs 1 --batch_size 8 --pretrain False \
    --recon_param 1 --latent_param 0.5 --eta 1 \
    --eps 0.1 --tau 0.1 --delta 0.1 \
    --ablation_type A --device cpu --seed 0
```

If this completes without error and writes `results.json`, `config.json`,
and `model.tar` under `examples/smoketest_run/`, your installation is working.

For full-scale reproduction of the paper experiments, see
[`docs/reproducing_paper.md`](../docs/reproducing_paper.md).

# Qualitative anomaly-map visualizations

`anomaly_localization.py` produces image-level anomaly heatmaps from a
trained ss-gVAE / Deep SAD model. It reproduces the qualitative figures
added in the thesis revisions of the WACV 2022 paper (Chapter 3 of Renuka
Sharma's PhD thesis, post-review additions); the original Feb 2023
research scripts have been consolidated and parametrized here.

Both Malaria and MVTec image families are supported by the same entry
point; pass `--dataset {malaria,mvtec}` and a category for MVTec.

```bash
# Malaria (paired *_img.png / *_seg_abnormal.png slides)
python scripts/visualize/anomaly_localization.py \
    --dataset malaria \
    --model-path ${RESULTS_DIR}/malaria/.../model.tar \
    --image-dir ${MALARIA_DATA}/test \
    --output-dir ${RESULTS_DIR}/malaria/localization \
    --score-mode sample_log_norm \
    --patch-stride 1 \
    --gaussian-sigma 2

# MVTec Leather (or carpet / tile / wood)
python scripts/visualize/anomaly_localization.py \
    --dataset mvtec --category leather \
    --model-path ${RESULTS_DIR}/mvtec/leather/.../model.tar \
    --image-dir ${MVTEC_DATA}/leather/test/cut \
    --output-dir ${RESULTS_DIR}/mvtec/leather/localization
```

Pass `--help` for the full argument list (score modes, patch stride,
ablation type, etc.).

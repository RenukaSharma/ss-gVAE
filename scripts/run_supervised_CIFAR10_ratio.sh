#!/bin/bash
# Environment variables this script expects:
#   RESULTS_DIR    - root directory for run outputs (e.g. ~/results/ss-gvae)
#   DATA_DIR       - root directory containing all datasets
#   MALARIA_DATA   - directory containing the curated malaria images + masks
#                    (typically $DATA_DIR/malaria)
#   SYNTHETIC_DATA - directory containing the synthetic *_syn_*.pt files
#                    (typically $DATA_DIR/synthetic; generate with src/main_syn.py)
#   MVTEC_DATA     - directory containing the MVTec AD dataset
#                    (typically $DATA_DIR/mvtec)
set -e
: "${RESULTS_DIR:?Set RESULTS_DIR before running this script.}"

mkdir -p "${RESULTS_DIR}/results_supervised/"
res_dir="${RESULTS_DIR}/results_supervised/cifar10"
mkdir -p ${res_dir}
for n_known_outlier_classes in 9
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}    
    for ratio_l in 0 0.01 0.05 0.1 0.2
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
        for gamma in 0.5 1 
            do
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}
            for p in 0.5 1 2
                do
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/p_${p}
                for eta in 1 2
                    do
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/p_${p}/eta_${eta}
                    for i in {1..2}
                        do
                            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/p_${p}/eta_${eta}/run_${i}
                            python main.py cifar10 cifar10_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/p_${p}/eta_${eta}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 0.0001 --n_epochs 150 --lr_milestone 50 --batch_size 128 --weight_decay 0.5e-6 --pretrain True --ae_lr 0.0001 --ae_n_epochs 350 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 0 --recon_param ${gamma} --p ${p} --eta ${eta};
                        done
                    done
                done
            done
        done
    done
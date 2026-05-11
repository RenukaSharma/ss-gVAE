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

res_dir="${RESULTS_DIR}/results_bayesian_Malaria-patchwise/BS-128/no-noise_with0.1pollution_inv-loss-noveltest_May22/baseline-ssad-hybrid-withVarLearning"
mkdir -p ${res_dir}
for i in {0..4}
do
    for n_known_outlier_classes in 1
    do
        for ratio_l in 0.2 # 0.1 0.05 0.01 0
        do
            mkdir -p ${res_dir}/ratio_l_${ratio_l}
            for kappa in 1
            do
                mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}
                                                    
                mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                python baseline_ssad.py malaria_dataset ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ${MALARIA_DATA} --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.1 --hybrid True --load_ae ${RESULTS_DIR}/results_bayesian_Malaria-patchwise/BS-128/with-SPnoise-no-pollution-inv-loss/n_known_outlier_classes_1/ratio_l_${ratio_l}/recon_param_1/latent_param_0.5/eta_1/val_1e-1/baseline_A/run_1/model.tar;
            done
        done
    done      
done

res_dir="${RESULTS_DIR}/results_bayesian_Malaria-patchwise/BS-128/no-noise_with0.1pollution_inv-loss-noveltest_May22/baseline-ssad-hybrid-withVarLearning"
mkdir -p ${res_dir}
for i in {0..4}
do
    for n_known_outlier_classes in 1
    do
        for ratio_l in 0.1 0.05 0.01 0 # 0.2
        do
            mkdir -p ${res_dir}/ratio_l_${ratio_l}
            for kappa in 1
            do
                mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}
                                                    
                mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                python baseline_ssad.py malaria_dataset ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ${MALARIA_DATA} --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.1 --hybrid True --load_ae ${RESULTS_DIR}/results_bayesian_Malaria-patchwise/BS-128/with-SPnoise-no-pollution-inv-loss/n_known_outlier_classes_1/ratio_l_${ratio_l}/recon_param_1/latent_param_0.5/eta_1/val_1e-1/baseline_A/run_1/model.tar;
            done
        done
    done      
done

# ------ with load_ae=False ------

res_dir="${RESULTS_DIR}/results_bayesian_Malaria-patchwise/BS-128/GG-noise_with0.2pollution_inv-loss-noveltest_May22_20kand5k/baseline-ssad"
mkdir -p ${res_dir}
for i in {0..4}
do
    for n_known_outlier_classes in 1
    do
        for ratio_l in 0.2 # 0.1 0.05 0.01 0
        do
            mkdir -p ${res_dir}/ratio_l_${ratio_l}
            for kappa in 1
            do
                mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}
                                                    
                mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                python baseline_ssad.py malaria_dataset ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ${MALARIA_DATA} --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.2 ;
            done
        done
    done      
done

res_dir="${RESULTS_DIR}/results_bayesian_Malaria-patchwise/BS-128/GG-noise_with0.2pollution_inv-loss-noveltest_May22_20kand5k/baseline-ssad"
mkdir -p ${res_dir}
for i in {0..4}
do
    for n_known_outlier_classes in 1
    do
        for ratio_l in 0.1 0.05 0.01 0 # 0.2
        do
            mkdir -p ${res_dir}/ratio_l_${ratio_l}
            for kappa in 1
            do
                mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}
                                                    
                mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                python baseline_ssad.py malaria_dataset ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ${MALARIA_DATA} --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.2 ;
            done
        done
    done      
done

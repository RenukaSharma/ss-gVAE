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

for category in "carpet" # 0
    do
    res_dir="${RESULTS_DIR}/results_bayesian_MVTec/MVTec-${category}-Jan8-final-res/BS-128/baseline-ssad-hybrid-withVarLearning"
    mkdir -p ${res_dir}
    for i in 6 # {0..4}
        do
        for n_known_outlier_classes in 1
            do
            for ratio_l in 0.2 0.1 0.05 0.01 0
                do
                mkdir -p ${res_dir}/ratio_l_${ratio_l}
                for kappa in 1
                    do
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}
                                                        
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                    python baseline_ssad.py mvtec ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ${RESULTS_DIR}/mvtec_AD_dataset/carpet-with-novel-ano-in-test --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.2 --hybrid True --load_ae ${RESULTS_DIR}/results_bayesian_MVTec/object-categories/MVTec-carpet_inv-savingmodel/BS-1/n_known_outlier_classes_1/ratio_l_${ratio_l}/recon_param_1/gamma_1/eta_1/val_1e-1/baseline_A/run_0/model.tar;
                    done
                done
            done      
        done
    done

for i in 0
    do
    for category in "bottle" "cable" "capsule" "metal_nut" "pill" "screw" "toothbrush" "zipper" "hazelnut" "transistor"
        do
        mkdir -p ${RESULTS_DIR}/results_bayesian_MVTec/object-categories/MVTec-${category}_inv
        mkdir -p ${RESULTS_DIR}/results_bayesian_MVTec/object-categories/MVTec-${category}_inv/BS-1
        res_dir="${RESULTS_DIR}/results_bayesian_MVTec/object-categories/MVTec-${category}_inv/BS-1/ssad-hybrid-loadae"
        mkdir -p ${res_dir}
    
        for n_known_outlier_classes in 1
            do
            for ratio_l in 0.2 0
                do
                mkdir -p ${res_dir}/ratio_l_${ratio_l}
                for kappa in 1
                    do
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}
                                                        
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                    python baseline_ssad.py mvtec ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ${RESULTS_DIR}/mvtec_AD_dataset/objects-with-novel-ano-in-test/${category} --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.2 --hybrid True --load_ae ${RESULTS_DIR}/results_bayesian_MVTec/object-categories/MVTec-${category}_inv-savingmodel/BS-1/n_known_outlier_classes_1/ratio_l_${ratio_l}/recon_param_1/gamma_1/eta_1/val_1e-1/baseline_A/run_0/model.tar;
                    done
                done
            done      
        done
    done


for i in 0
    do
    for category in "wood" #   "grid" "leather" "tile"
        do
        mkdir -p ${RESULTS_DIR}/results_bayesian_MVTec/texture-categories/MVTec-${category}_inv/
        mkdir -p ${RESULTS_DIR}/results_bayesian_MVTec/texture-categories/MVTec-${category}_inv/BS-1
        res_dir="${RESULTS_DIR}/results_bayesian_MVTec/texture-categories/MVTec-${category}_inv/BS-1/ssad-hybrid-loadae"
        mkdir -p ${res_dir}
    
        for n_known_outlier_classes in 1
            do
            for ratio_l in 0.2 0
                do
                mkdir -p ${res_dir}/ratio_l_${ratio_l}
                for kappa in 1
                    do
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}
                                                        
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                    python baseline_ssad.py mvtec ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ${RESULTS_DIR}/mvtec_AD_dataset/${category}-with-novel-ano-in-test --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.2 --hybrid True --load_ae ${RESULTS_DIR}/results_bayesian_MVTec/object-categories/MVTec-carpet_inv-savingmodel/BS-1/n_known_outlier_classes_1/ratio_l_${ratio_l}/recon_param_1/gamma_1/eta_1/val_1e-1/baseline_A/run_0/model.tar;
                    done
                done
            done      
        done
    done

for i in {0..4}
    do
    for category in "bottle" "cable" "capsule" "metal_nut" "pill" "screw" "toothbrush" "zipper" "hazelnut" "transistor"
        do
        mkdir -p ${RESULTS_DIR}/results_bayesian_MVTec/object-categories/MVTec-${category}_inv
        mkdir -p ${RESULTS_DIR}/results_bayesian_MVTec/object-categories/MVTec-${category}_inv/BS-1
        res_dir="${RESULTS_DIR}/results_bayesian_MVTec/object-categories/MVTec-${category}_inv/BS-1/ssad"
        mkdir -p ${res_dir}
    
        for n_known_outlier_classes in 1
            do
            for ratio_l in 0.2 0
                do
                mkdir -p ${res_dir}/ratio_l_${ratio_l}
                for kappa in 1
                    do
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}
                                                        
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                    python baseline_ssad.py mvtec ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ${RESULTS_DIR}/mvtec_AD_dataset/objects-with-novel-ano-in-test/${category} --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.2;
                    done
                done
            done      
        done
    done


for i in {0..4}
    do
    for category in "grid" "leather" "tile" "wood"
        do
        mkdir -p ${RESULTS_DIR}/results_bayesian_MVTec/texture-categories/MVTec-${category}_inv/
        mkdir -p ${RESULTS_DIR}/results_bayesian_MVTec/texture-categories/MVTec-${category}_inv/BS-1
        res_dir="${RESULTS_DIR}/results_bayesian_MVTec/texture-categories/MVTec-${category}_inv/BS-1/ssad"
        mkdir -p ${res_dir}
    
        for n_known_outlier_classes in 1
            do
            for ratio_l in 0.2 0
                do
                mkdir -p ${res_dir}/ratio_l_${ratio_l}
                for kappa in 1
                    do
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}
                                                        
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                    python baseline_ssad.py mvtec ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ${RESULTS_DIR}/mvtec_AD_dataset/${category}-with-novel-ano-in-test --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.2;
                    done
                done
            done      
        done
    done

for i in {0..4}
    do
    for category in "carpet"
        do
        mkdir -p ${RESULTS_DIR}/results_bayesian_MVTec/texture-categories/MVTec-${category}_inv/
        mkdir -p ${RESULTS_DIR}/results_bayesian_MVTec/texture-categories/MVTec-${category}_inv/BS-1
        res_dir="${RESULTS_DIR}/results_bayesian_MVTec/texture-categories/MVTec-${category}_inv/BS-1/ssad"
        mkdir -p ${res_dir}
    
        for n_known_outlier_classes in 1
            do
            for ratio_l in 0.2 0 0.01 0.05 0.1
                do
                mkdir -p ${res_dir}/ratio_l_${ratio_l}
                for kappa in 1
                    do
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}
                                                        
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                    python baseline_ssad.py mvtec ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ${RESULTS_DIR}/mvtec_AD_dataset/${category}-with-novel-ano-in-test --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.2;
                    done
                done
            done      
        done
    done
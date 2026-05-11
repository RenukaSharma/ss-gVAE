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

for i in 0 1 2
    do
        res_dir="${RESULTS_DIR}/results_baselines_ocsvm_ssad/ssad/mnist_pollution_0-2-ssad-hybrid-withVarLearning-loadae"
        mkdir -p ${res_dir}
    
        for n_known_outlier_classes in 1
            do
            for ratio_l in 0.1 0.05 0.01 0 0.2 0
                do
                mkdir -p ${res_dir}/ratio_l_${ratio_l}
                for kappa in 1
                    do
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}
                                                        
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                    python baseline_ssad.py mnist ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ../data --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.2 --normal_class 3 --hybrid True --load_ae ${RESULTS_DIR}/results_bayesian_VAE_Sep26/mnist_rp-0.2__normal_class-3-savemodel/n_known_outlier_classes_1/ratio_l_${ratio_l}/gamma_1/eta_1/val_0.1/baseline_A/run_6/model.tar;
                    done
                done
            done 
    done

for i in 0 1 2
    do
        res_dir="${RESULTS_DIR}/results_baselines_ocsvm_ssad/ssad/fmnist_pollution_0-2-ssad-hybrid-withVarLearning-loadae"
        mkdir -p ${res_dir}
    
        for n_known_outlier_classes in 1
            do
            for ratio_l in 0.1 0.05 0.01 0 0.2 0
                do
                mkdir -p ${res_dir}/ratio_l_${ratio_l}
                for kappa in 1
                    do
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}
                                                        
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                    python baseline_ssad.py fmnist ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ../data --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.2 --normal_class 3 --hybrid True --load_ae ${RESULTS_DIR}/results_bayesian_VAE_Sep26/cifar10_normal_class-0-savingmodel/n_known_outlier_classes_1/ratio_l_0.2/recon_param_1/gamma_1/eta_1/val_1e-1/baseline_A/run_1/model.tar;
                    done
                done
            done 
    done
############################################

res_dir="${RESULTS_DIR}/results_baselines_ocsvm_ssad/ssad/mnist_pollution_0-2-ssad-hybrid-withVarLearning"
mkdir -p ${res_dir}
for i in {0..4}
    do
    for n_known_outlier_classes in 1 5
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}    
        for ratio_l in 0.01 0.05 0.1 0.2 0
            do
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
            for kappa in 1
                do
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}
                                            
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}
                python baseline_ssad.py mnist ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ../data --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.2 --hybrid True;
                    
                done
            done      
        done
    done



for category in "carpet" # 0
    do
    res_dir="${RESULTS_DIR}/results_bayesian_MVTec/MVTec-${category}-Jan8-final-res/BS-128/baseline-ssad-hybrid-withVarLearning"
    mkdir -p ${res_dir}
    for i in {0..4}
        do
        for n_known_outlier_classes in 1
            do
            for ratio_l in 0.1 0.05 0.01 0 0.2 0
                do
                mkdir -p ${res_dir}/ratio_l_${ratio_l}
                for kappa in 1
                    do
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}
                                                        
                    mkdir -p ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                    python baseline_ssad.py mvtec ${res_dir}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ${RESULTS_DIR}/mvtec_AD_dataset/carpet-with-novel-ano-in-test --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.2 --hybrid True;
                    done
                done
            done      
        done
    done

###############################################

res_dir="${RESULTS_DIR}/results_baselines_ocsvm_ssad/ssad/fmnist_pollution_0-2-ssad-hybrid-withVarLearning"
mkdir -p ${res_dir}
for i in {0..4}
    do
    for n_known_outlier_classes in 1 5
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}    
        for ratio_l in 0.01 0.05 0.1 0.2 0
            do
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
            for kappa in 1
                do
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}
                        
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}
                python baseline_ssad.py fmnist ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ../data --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.2 --hybrid True;
                    
                done
            done      
        done
    done

###############################################
res_dir="${RESULTS_DIR}/results_baselines_ocsvm_ssad/ssad/cifar10-ssad-hybrid-withVarLearning"
mkdir -p ${res_dir}
for i in {0..4}
    do
    for n_known_outlier_classes in 1 5
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}    
        for ratio_l in 0 0.01 0.05 0.1 0.2
            do
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
            for kappa in 1
                do
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}

                python baseline_ssad.py cifar10 ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ../data --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0 --hybrid True;
                    
                done
            done      
        done
    done
###############################################

res_dir="${RESULTS_DIR}/results_baselines_ocsvm_ssad/ssad/cifar10_pollution_0-1-ssad-hybrid-withVarLearning"
mkdir -p ${res_dir}
for i in {0..4}
    do
    for n_known_outlier_classes in 1 5
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}    
        for ratio_l in 0 0.01 0.05 0.1 0.2
            do
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
            for kappa in 1
                do
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}        
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}
                python baseline_ssad.py cifar10 ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ../data --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.1 --hybrid True;
                    
                done
            done      
        done
    done

################################
res_dir="${RESULTS_DIR}/results_baselines_ocsvm_ssad/ssad/mnist_pollution_0-1-ssad-hybrid-withVarLearning"
mkdir -p ${res_dir}
for i in {0..4}
    do
    for n_known_outlier_classes in 1 
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}    
        for ratio_l in 0.2 0.01 0.05 0.1 0.2
            do
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
            for kappa in 1
                do
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}   
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i}
                python baseline_ssad.py mnist ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/kappa_${kappa}/run_${i} ../data --ratio_known_outlier ${ratio_l} --kernel rbf --kappa ${kappa} --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --ratio_pollution 0.1 --hybrid True;
                    
                done
            done      
        done
    done
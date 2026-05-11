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

# python baseline_binary_classifier.py mvtec cifar10_LeNet ${RESULTS_DIR}/results_bayesian_MVTec/MVTec-carpet-Jan8-final-res/BS-128/baseline-supervised/run_1 ${RESULTS_DIR}/mvtec_AD_dataset/carpet-with-novel-ano-in-test --ratio_known_normal 0.8 --ratio_known_outlier 0.2 --ratio_pollution 0 --seed 128 --lr 1e-4 --n_epochs 150 --batch_size 128 --pretrain False --normal_class 0 --lr_milestone 100;


res_dir="${RESULTS_DIR}/results_bayesian_Malaria-patchwise/BS-128/with-SPnoise-no-pollution-inv-loss/baseline_BinCls"
mkdir -p ${res_dir}

for i in {0..4}
do      
    for ratio_l in 0.2
    do 
        
        mkdir -p ${res_dir}/ratio_l_${ratio_l}
        mkdir -p ${res_dir}/ratio_l_${ratio_l}/run_${i}

        python baseline_binary_classifier.py malaria_dataset cifar10_LeNet ${res_dir}/ratio_l_${ratio_l}/run_${i} ${MALARIA_DATA} --ratio_known_normal 0.80 --ratio_known_outlier ${ratio_l} --lr 1e-04 --n_epochs 150 --batch_size 128 --pretrain False --seed ${i} --ratio_pollution 0 --lr_milestone 100;   
        
    done    
done

res_dir="${RESULTS_DIR}/results_bayesian_Malaria-patchwise/BS-128/with-SPnoise-no-pollution-inv-loss/baseline_BinCls"
mkdir -p ${res_dir}

for i in {0..4}
do  
    for ratio_l in 0.1
    do 
        
        mkdir -p ${res_dir}/ratio_l_${ratio_l}
        mkdir -p ${res_dir}/ratio_l_${ratio_l}/run_${i}

        python baseline_binary_classifier.py malaria_dataset cifar10_LeNet ${res_dir}/ratio_l_${ratio_l}/run_${i} ${MALARIA_DATA} --ratio_known_normal 0.90 --ratio_known_outlier ${ratio_l} --lr 1e-04 --n_epochs 150 --batch_size 128 --pretrain False --seed ${i} --ratio_pollution 0 --lr_milestone 100;   
        
    done 

    for ratio_l in 0.05
    do 
        
        mkdir -p ${res_dir}/ratio_l_${ratio_l}
        mkdir -p ${res_dir}/ratio_l_${ratio_l}/run_${i}

        python baseline_binary_classifier.py malaria_dataset cifar10_LeNet ${res_dir}/ratio_l_${ratio_l}/run_${i} ${MALARIA_DATA} --ratio_known_normal 0.1 --ratio_known_outlier ${ratio_l} --lr 1e-04 --n_epochs 150 --batch_size 128 --pretrain False --seed ${i} --ratio_pollution 0 --lr_milestone 100;   
        
    done 

    for ratio_l in 0.01
    do 
        
        mkdir -p ${res_dir}/ratio_l_${ratio_l}
        mkdir -p ${res_dir}/ratio_l_${ratio_l}/run_${i}

        python baseline_binary_classifier.py malaria_dataset cifar10_LeNet ${res_dir}/ratio_l_${ratio_l}/run_${i} ${MALARIA_DATA} --ratio_known_normal 0.1 --ratio_known_outlier ${ratio_l} --lr 1e-03 --n_epochs 150 --batch_size 128 --pretrain False --seed ${i} --ratio_pollution 0 --lr_milestone 100;   
        
    done 
    
done    

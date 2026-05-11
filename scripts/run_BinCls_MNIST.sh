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

mkdir -p ${RESULTS_DIR}/results_bayesian_VAE_Sep8
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep22_GGnoise-new/MNIST_rp-0.2_BinClassification"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {1..15}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
    for ratio_l in 0.2 # 0.1 0.05 0.01
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                             
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i}     
                
                python main_BinClassification.py mnist mnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i} ../data --ratio_known_outlier ${ratio_l} --ratio_known_normal 0.8 --lr 1e-02 --n_epochs 30 --batch_size 128 --weight_decay 0.5e-6 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --n_jobs_dataloader 0 --ratio_pollution 0.2 --known_outlier_class 2 --pretrain False # --device cpu;         
            done    
        done        
    done

res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep22_GGnoise-new/MNIST_rp-0.2_BinClassification"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {6..10}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
    for ratio_l in 0.1 # 0.05 0.01
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                             
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i}     
                
                python main_BinClassification.py mnist mnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i} ../data --ratio_known_outlier ${ratio_l} --ratio_known_normal 0.9 --lr 1e-02 --n_epochs 30 --batch_size 128 --weight_decay 0.5e-6 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --n_jobs_dataloader 0 --ratio_pollution 0.2 --known_outlier_class 2 --pretrain False # --device cpu;         
            done    
        done        
    done
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep22_GGnoise-new/MNIST_rp-0.2_BinClassification"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {6..10}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
    for ratio_l in 0.05 # 0.01
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                             
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i}     
                
                python main_BinClassification.py mnist mnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i} ../data --ratio_known_outlier ${ratio_l} --ratio_known_normal 0.95 --lr 1e-02 --n_epochs 30 --batch_size 128 --weight_decay 0.5e-6 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --n_jobs_dataloader 0 --ratio_pollution 0.2 --known_outlier_class 2 --pretrain False # --device cpu;         
            done    
        done        
    done

res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep22_GGnoise-new/MNIST_rp-0.2_BinClassification"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {1..10}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
    for ratio_l in 0.01
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                             
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i}     
                
                python main_BinClassification.py mnist mnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i} ../data --ratio_known_outlier ${ratio_l} --ratio_known_normal 0.99 --lr 1e-02 --n_epochs 30 --batch_size 128 --weight_decay 0.5e-6 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --n_jobs_dataloader 0 --ratio_pollution 0.2 --known_outlier_class 2 --pretrain False # --device cpu;         
            done    
        done        
    done
###################################################

res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep22_GGnoise-new/FMNIST_rp-0.2_BinClassification"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {6..10}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
    for ratio_l in 0.2
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                             
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i}     

                python main_BinClassification.py fmnist fmnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i} ../data --ratio_known_outlier ${ratio_l} --ratio_known_normal 0.8 --lr 1e-02 --n_epochs 75 --batch_size 128 --weight_decay 0.5e-6 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --n_jobs_dataloader 0 --ratio_pollution 0.2 --known_outlier_class 1 --pretrain False # --device cpu;  

                
            done    
        done        
    done
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep22_GGnoise-new/FMNIST_rp-0.2_BinClassification"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {6..10}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
    for ratio_l in 0.1
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                             
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i}     

                python main_BinClassification.py fmnist fmnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i} ../data --ratio_known_outlier ${ratio_l} --ratio_known_normal 0.9 --lr 1e-02 --n_epochs 30 --batch_size 128 --weight_decay 0.5e-6 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --n_jobs_dataloader 0 --ratio_pollution 0.2 --known_outlier_class 1 --pretrain False # --device cpu;  

                     
            done    
        done        
    done
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep22_GGnoise-new/FMNIST_rp-0.2_BinClassification"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {6..10}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
    for ratio_l in 0.05
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                             
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i}     

                python main_BinClassification.py fmnist fmnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i} ../data --ratio_known_outlier ${ratio_l} --ratio_known_normal 0.95 --lr 1e-02 --n_epochs 30 --batch_size 128 --weight_decay 0.5e-6 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --n_jobs_dataloader 0 --ratio_pollution 0.2 --known_outlier_class 1 --pretrain False # --device cpu;  

                     
            done    
        done        
    done
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep22_GGnoise-new/FMNIST_rp-0.2_BinClassification"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {6..10}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
    for ratio_l in 0.01
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                             
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i}     

                python main_BinClassification.py fmnist fmnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i} ../data --ratio_known_outlier ${ratio_l} --ratio_known_normal 0.99 --lr 1e-02 --n_epochs 30 --batch_size 128 --weight_decay 0.5e-6 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --n_jobs_dataloader 0 --ratio_pollution 0.2 --known_outlier_class 1 --pretrain False # --device cpu;  

                     
            done    
        done        
    done
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep22_GGnoise-new/CIFAR10_BinClassification"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {6..10}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
    for ratio_l in 0.2
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                             
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i}     

                python main_BinClassification.py cifar10 cifar10_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i} ../data --ratio_known_outlier ${ratio_l} --ratio_known_normal 0.8 --lr 1e-02 --n_epochs 30 --batch_size 128 --weight_decay 0.5e-6 --normal_class 0 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --n_jobs_dataloader 0 --ratio_pollution 0.2 --known_outlier_class 2 --pretrain False # --device cpu; 

                        
            done    
        done        
    done
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep22_GGnoise-new/CIFAR10_BinClassification"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {6..10}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
    for ratio_l in 0.1
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                             
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i}     

                python main_BinClassification.py cifar10 cifar10_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i} ../data --ratio_known_outlier ${ratio_l} --ratio_known_normal 0.9 --lr 1e-02 --n_epochs 30 --batch_size 128 --weight_decay 0.5e-6 --normal_class 0 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --n_jobs_dataloader 0 --ratio_pollution 0.2 --known_outlier_class 2 --pretrain False # --device cpu; 

                        
            done    
        done        
    done
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep22_GGnoise-new/CIFAR10_BinClassification"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {6..10}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
    for ratio_l in 0.05
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                             
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i}     

                python main_BinClassification.py cifar10 cifar10_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i} ../data --ratio_known_outlier ${ratio_l} --ratio_known_normal 0.95 --lr 1e-02 --n_epochs 30 --batch_size 128 --weight_decay 0.5e-6 --normal_class 0 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --n_jobs_dataloader 0 --ratio_pollution 0.2 --known_outlier_class 2 --pretrain False # --device cpu; 

                        
            done    
        done        
    done
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep22_GGnoise-new/CIFAR10_BinClassification"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {6..10}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
    for ratio_l in 0.01
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                             
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i}     

                python main_BinClassification.py cifar10 cifar10_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i} ../data --ratio_known_outlier ${ratio_l} --ratio_known_normal 0.99 --lr 1e-02 --n_epochs 30 --batch_size 128 --weight_decay 0.5e-6 --normal_class 0 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --n_jobs_dataloader 0 --ratio_pollution 0.2 --known_outlier_class 2 --pretrain False # --device cpu; 

                        
            done    
        done        
    done




########################
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep8/MNIST_rp-0/Baseline_Bin-Cls"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 5
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
    for ratio_l in 0.2 0.1 0.05 0.01 0
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
        for i in 1 # {1..15}
            do                     
            mkdir -p python main.py mnist mnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i}     

                python main_BinClassification.py mnist mnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-02 --n_epochs 100 --lr_milestone 0 --batch_size 128 --weight_decay 0.5e-6 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0 --known_outlier_class 2 --device cuda --pretrain False;          
            done    
        done        
    done


    python main_BinClassification.py mnist mnist_LeNet ../log/MNIST ../data --seed 0 --n_epochs 50


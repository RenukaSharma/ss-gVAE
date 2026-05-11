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

mkdir -p ${RESULTS_DIR}/results_bayesian_VAE_Sep18_GGnoise-new
for normal_class in 3 # 0
do
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep23/fmnist_rp-0.2__normal_class-${normal_class}"
# res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep18_GGnoise-new/fmnist_rp-0.2__normal_class-${normal_class}"
# res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep17/fmnist_rp-0__normal_class-${normal_class}"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {1..3}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes} 
    for val in 0.1 1e-5  # 0.001 0.01 
    do 
    for gamma in 1 2 4 6 8 10
    do  
    for eta in 1 2 4 6 8 10
    do
    for ratio_l in 0.2 0.1 0.05 0.01 0
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
        
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma} 
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}
                
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}                       
                          
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/run_${i}
                        python main.py fmnist fmnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-05 --n_epochs 100 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.00001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class ${normal_class} --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 1 --ablation_type A;  
                    done                           
                    done
                done
            done
        done
    done
done


for normal_class in 3 # 0
do
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep23/fmnist_rp-0.2__normal_class-${normal_class}/ablation-B"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {1..3} # to be added 
    do       
    for gamma in 1 2 4 6 8 10 # 0.5 0.25 0
    do  
    for eta in 1 2 4 6 8 10
    do
    for ratio_l in 0.2 0.1 0.05 0.01 0
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}        
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma} 
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}                          
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i}    

                        python main.py fmnist fmnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-02 --n_epochs 50 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class ${normal_class} --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 1 --ablation_type B;  #  --lr_milestone 10
                done                           
                done
            done
        done
    done
done



for normal_class in 3 # 0
do
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep19_GGnoise-new/fmnist_rp-0.2__normal_class-${normal_class}/ablation-C"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {3..15}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}  
    for val in 0.1 # 1e-5  # 0.001 0.01 
    do
    for gamma in 0 # 0.5 0.25 0
    do  
    for eta in 1 
    do
    for ratio_l in 0.2 0.1 0.05 0.01 0
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
        
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma} 
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}
                
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}                       
                    
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/run_${i}
                        python main.py fmnist fmnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-05 --n_epochs 100 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class ${normal_class} --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 1 --ablation_type C; 
                    done                            
                    done
                done
            done
        done
    done
done

for normal_class in 3 # 0
do
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep20_GGnoise-new/fmnist_rp-0.2__normal_class-${normal_class}/ablation-D"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    for i in {1..15}
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}  
    for gamma in 0 # 0.5 0.25 0
    do  
    for eta in 1
    do
    for ratio_l in 0.2 0.1 0.05 0.01 0
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
        
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma} 
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}
                
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i}
                            
                        python main.py fmnist fmnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-03 --n_epochs 50  --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class ${normal_class} --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 1 --ablation_type D; 
                done                            
                    done
                done
            done
        done
    done


### to be put to run

for normal_class in 3 # 0
do
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep23/fmnist_rp-0.2__normal_class-${normal_class}/ablation-E"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes} 
    for i in {1..3}
    do 
    for gamma in 100 1000 50 # 0.5 0.25 0
    do  
    for eta in 1 2 4 6 8 10
    do
    for ratio_l in 0.2 0.1 0.05 0.01 0
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
        
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma} 
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}
                         
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i}
                            
                        python main.py fmnist fmnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-03 --n_epochs 75 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class ${normal_class} --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 1 --ablation_type E;   
                done                          
                    done
                done
            done
        done
    done


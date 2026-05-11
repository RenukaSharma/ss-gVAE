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

mkdir -p ${RESULTS_DIR}/results_bayesian_VAE_Aug7_21
res_dir="${RESULTS_DIR}/results_bayesian_VAE_Aug7_21/MNIST_rp-0.2"
# res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep23-ConvDeconv/MNIST_rp-0.2"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
do
    for i in {1..3}
    do 
        for val in 1e-1 1e-5 # 1e-5 # 1e-1 1e-5 1e-2 1e-3 1e-4  
        do
            for recon_param in 1 # 1 2 4 # 6 8 10 1
            do  
                for latent_param in 1 # 1 0.1  # 0.1 1
                do
                    for eta in 1 # 5 10 # 4 8 10
                    do
                        for ratio_l in 0.2 0.1 0.05 0.01 0 # 0.05 0.01 0 # 0.2 0.1 0.05 0.01 0
                        do 
                            for baseline in A B C D E # VAE
                            do 

                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta} 
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline} 
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i} 


                                python main.py mnist mnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-4 --n_epochs 75 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 1e-5 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${recon_param} --latent_param ${latent_param} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 2 --ablation_type ${baseline};      # --lr_milestone 25 
                            done
                        done
                    done
                done 
            done
        done
    done
done



python main_BinClassification.py mnist mnist_LeNet ../log/MNIST ../data --seed 0

res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep23/MNIST_rp-0.2/ablation-B"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
do
    for i in {1..3}
    do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
        for gamma in 1 2 4 6 8 10
        do  
            for eta in 1 2 4 6 8 10
            do
                for ratio_l in 0.2 0.1 0.05 0.01 0
                do
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}        
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma} 
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i}

                    python main.py mnist mnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-04 --n_epochs 75 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 2 --ablation_type B;  
                                                        
                done
            done
        done
    done
done

res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep23/MNIST_rp-0.2/ablation-C" ##sort it out
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
do
    for i in {1..3}
    do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
        for val in 0.1 1e-5 # 0.001 0.01 
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

                        python main.py mnist mnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-04 --n_epochs 50 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 2 --ablation_type C;   
                    done                          
                done
            done
        done
    done
done

### Following: to run

res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep20_GGnoise-new/MNIST_rp-0.2/ablation-D"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
do
    for i in {1..15}
    do 
        for gamma in 0 # 0.5 0.25 0
        do  
            for eta in 1
            do
                for ratio_l in 0.2 0.1 0.05 0.01 0
                do
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma} 
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i}       
                                        
                    python main.py mnist mnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-02 --n_epochs 50 --batch_size 128  --lr_milestone 15 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 2 --ablation_type D;     
                                            
                done
            done
        done
    done
done

res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep23/MNIST_rp-0.2/ablation-E" ##sort it out
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 # 5
do
    for i in {1..3}
    do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
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
                    python main.py mnist mnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-03 --n_epochs 50 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 2 --ablation_type E;  
                done     
            done
        done
    done
done

res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep8/MNIST_rp-0.2/ablation-VAE" 
mkdir -p ${res_dir}
for n_known_outlier_classes in 1
do
    for i in {1..15}
    do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
        for gamma in 1 # 0.5 0.25 0
        do  
            for eta in 1
            do
                for ratio_l in 0.2 0.1 0.05 0.01 0
                do
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}            
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma} 
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}
                    
                    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i}  

                    python main.py mnist mnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-02 --n_epochs 100 --lr_milestone 0 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --n_jobs_dataloader 0 --ratio_known_normal 0.1 --ratio_pollution 0.2 --known_outlier_class 2 --ablation_type VAE;                             
                done
            done
        done
    done
done

res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep8/MNIST_rp-0.2/DeepSAD" 
mkdir -p ${res_dir}
for n_known_outlier_classes in 1
    do
    mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}
     
    for gamma in 1 # 0.5 0.25 0
    do  
    for eta in 1
    do
    for ratio_l in 0.05 0.2 0.1 0.01 0
        do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
        
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma} 
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}
                for i in {1..15}
                do   
                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i}  
                        python main.py mnist mnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-02 --n_epochs 100 --lr_milestone 0 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class 3 --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --n_jobs_dataloader 0 --ratio_known_normal 0.1 --ratio_pollution 0.2 --known_outlier_class 2 --ablation_type DeepSAD;                             
                done
                done
            done
        done
    done
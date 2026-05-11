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

mkdir -p ${RESULTS_DIR}/syn-dataset/
res_dir="${RESULTS_DIR}/syn-dataset/BS-128/sp_0.05_bestmodel"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 
do
    for i in {1..5}
    do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}  
        for val in 0.1 1e-5 # 1e-1 1e-5 1e-2 1e-3 1e-4  
        do
            for recon_param in 1 2 4 # 6 8 10 1
            do  
                for latent_param in 1 0.5 0.1  # 0.1 1
                do
                    for eta in 1 4 # 4 8 10
                    do
                        for ratio_l in 0.2 0.1 0.05 0.01 0 0.49 # 0.05 0.01 0 # 0.2 0.1 0.05 0.01 0
                        do 
                            for baseline in A B C D E # VAE
                            do                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param} 
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i}

                                python main.py synthetic cifar10_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i} ${SYNTHETIC_DATA} --ratio_known_outlier ${ratio_l} --lr 1e-04 --n_epochs 75 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --recon_param ${recon_param} --latent_param ${latent_param} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 4 --ratio_known_normal 0 --ratio_pollution 0 --known_outlier_class 1 --ablation_type ${baseline} --lr_milestone 10;   # --lr_milestone 40 --lr_milestone 20  --lr_milestone 15
                            done
                        done
                    done
                done 
            done
        done
    done
done

# res_dir="${RESULTS_DIR}/syn-dataset/BS-128/sp_0.05"
res_dir="${RESULTS_DIR}/syn-dataset/BS-128/sp_0.05"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 
do
    for i in {6..7}
    do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}  
        for val in 0.1 1e-5  # 1e-1 1e-5 1e-2 1e-3 1e-4  
        do
            for recon_param in 1 2 4 # 6 8 10 1
            do  
                for latent_param in 1 0.5 0.1  # 0.1 1
                do
                    for eta in 1 4 # 4 8 10
                    do
                        for ratio_l in 0.2 0.1 0.05 0.01 0 # 0.05 0.01 0 # 0.2 0.1 0.05 0.01 0
                        do 
                            for baseline in D # B C D E # VAE
                            do                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param} 
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i}

                                python main.py synthetic cifar10_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i} ${SYNTHETIC_DATA} --ratio_known_outlier ${ratio_l} --lr 1e-04 --n_epochs 75 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --recon_param ${recon_param} --latent_param ${latent_param} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 4 --ratio_known_normal 0 --ratio_pollution 0 --known_outlier_class 1 --ablation_type ${baseline} --lr_milestone 10;   # --lr_milestone 40 --lr_milestone 20  --lr_milestone 15
                            done
                        done
                    done
                done 
            done
        done
    done
done

res_dir="${RESULTS_DIR}/results_bayesian_Malaria-patchwise/BS-128/with-SPnoise-no-pollution-inv-loss-noveltest_take-2"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 
do
    for i in {1..5}
    do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}  
        for val in 0.1 # 1e-1 1e-5 1e-2 1e-3 1e-4  
        do
            for recon_param in 1 # 1 2 4 # 6 8 10 1
            do  
                for latent_param in 1 # 0.5 1 0.1 0.1 1
                do
                    for eta in 1 # 5 10 # 4 8 10
                    do
                        for ratio_l in 0.2 0.1 0.05 0.01 0 # 0.05 0.01 0 # 0.2 0.1 0.05 0.01 0
                        do 
                            for baseline in E # B C D E A # VAE
                            do                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param} 
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i}

                                python main.py synthetic cifar10_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i} ${SYNTHETIC_DATA} --ratio_known_outlier ${ratio_l} --lr 1e-04 --n_epochs 75 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --recon_param ${recon_param} --latent_param ${latent_param} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 4 --ratio_known_normal 0 --ratio_pollution 0 --known_outlier_class 1 --ablation_type ${baseline} --lr_milestone 10;   # --lr_milestone 40 --lr_milestone 20  --lr_milestone 15
                            done
                        done
                    done
                done 
            done
        done
    done
done

res_dir="${RESULTS_DIR}/results_bayesian_Malaria-patchwise/BS-128/with-noise-no-pollution-inv-loss"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 
do
    for i in 1
    do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}  
        for val in 1e-1 # 1e-1 1e-5 1e-2 1e-3 1e-4  
        do
            for recon_param in 1 10 100 1e2 # 1 2 4 # 6 8 10 1
            do  
                for latent_param in 1 1e-1 1e-2 0.5
                do
                    for eta in 1 # 4 8 10
                    do
                        for ratio_l in 0.2 0.1 0.05 0.01 0 # 0.05 0.01 0 # 0.2 0.1 0.05 0.01 0
                        do 
                            for baseline in A # A B C D E VAE
                            do                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param} 
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i}

                                python main.py synthetic cifar10_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i} ${SYNTHETIC_DATA} --ratio_known_outlier ${ratio_l} --lr 1e-05 --n_epochs 500 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --n_known_outlier_classes ${n_known_outlier_classes} --seed 0 --recon_param ${recon_param} --latent_param ${latent_param} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 4 --ratio_known_normal 0 --ratio_pollution 0 --known_outlier_class 1 --ablation_type ${baseline} --lr_milestone 10;   # --lr_milestone 40 --lr_milestone 20  --lr_milestone 15
                            done
                        done
                    done
                done 
            done
        done
    done
done


for normal_class in 3 # 0
do
    res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep26/fmnist_rp-0.2__normal_class-${normal_class}"
    mkdir -p ${res_dir}
    for n_known_outlier_classes in 1 
    do
        for i in 7
        do
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}  
            for val in 0.01 # 1e-5 # 0.001 0.01 
            do
                for gamma in 2 # 2 4 # 6 8 10 1
                do  
                    for eta in 2 # 6 8 10
                    do
                        for ratio_l in 0 0.2 0.01 0.05 0.1 
                        do 
                            for baseline in A C B D E
                            do                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma} 
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/baseline_${baseline}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i}

                                python main.py fmnist fmnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-04 --lr_milestone 20 --n_epochs 75 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.00001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class ${normal_class} --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 1 --ablation_type ${baseline};   # --lr_milestone 20  --lr_milestone 10
                                
                            done
                        done                     
                    done
                done
            done
        done
    done
done

for normal_class in 3 # 0
do
    res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep26/fmnist_rp-0.2__normal_class-${normal_class}"
    mkdir -p ${res_dir}
    for n_known_outlier_classes in 1 
    do
        for i in 8
        do
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}  
            for val in 0.1 # 1e-5 # 0.001 0.01 
            do
                for gamma in 2 # 2 4 # 6 8 10 1
                do  
                    for eta in 4 # 6 8 10
                    do
                        for ratio_l in 0 0.2 0.01 0.05 0.1 
                        do 
                            for baseline in A C B D E
                            do                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma} 
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/baseline_${baseline}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i}

                                python main.py fmnist fmnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-04 --lr_milestone 20 --n_epochs 75 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.00001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class ${normal_class} --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 1 --ablation_type ${baseline};   # --lr_milestone 20  --lr_milestone 10
                                
                            done
                        done                     
                    done
                done
            done
        done
    done
done

for normal_class in 3 # 0
do
    res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep26/fmnist_rp-0.2__normal_class-${normal_class}"
    mkdir -p ${res_dir}
    for n_known_outlier_classes in 1 
    do
        for i in 9
        do
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}  
            for val in 0.01 # 1e-5 # 0.001 0.01 
            do
                for gamma in 2 # 2 4 # 6 8 10 1
                do  
                    for eta in 4 # 6 8 10
                    do
                        for ratio_l in 0 0.2 0.01 0.05 0.1 
                        do 
                            for baseline in A C B D E
                            do                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma} 
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/baseline_${baseline}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i}

                                python main.py fmnist fmnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-04 --lr_milestone 20 --n_epochs 75 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.00001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class ${normal_class} --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 1 --ablation_type ${baseline};   # --lr_milestone 20  --lr_milestone 10
                                
                            done
                        done                     
                    done
                done
            done
        done
    done
done

for normal_class in 3 # 0
do
    res_dir="${RESULTS_DIR}/results_bayesian_VAE_Sep26/fmnist_rp-0.2__normal_class-${normal_class}"
    mkdir -p ${res_dir}
    for n_known_outlier_classes in 1 
    do
        for i in 20
        do
            mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}  
            for val in 1e-5 # 0.001 0.01 
            do
                for gamma in 1 # 2 4 # 6 8 10 1
                do  
                    for eta in 1 # 6 8 10
                    do
                        for ratio_l in 0 0.2 0.01 0.05 0.1 
                        do 
                            for baseline in E
                            do                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma} 
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/baseline_${baseline}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i}

                                python main.py fmnist fmnist_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/gamma_${gamma}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i} ../data --ratio_known_outlier ${ratio_l} --lr 1e-04 --lr_milestone 20 --n_epochs 75 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --ae_lr 0.00001 --ae_n_epochs 20 --ae_lr_milestone 12 --ae_batch_size 128 --ae_weight_decay 0.5e-3 --normal_class ${normal_class} --n_known_outlier_classes ${n_known_outlier_classes} --seed 42 --recon_param ${gamma} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 0 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 1 --ablation_type ${baseline};   # --lr_milestone 20  --lr_milestone 10
                                
                            done
                        done                     
                    done
                done
            done
        done
    done
done

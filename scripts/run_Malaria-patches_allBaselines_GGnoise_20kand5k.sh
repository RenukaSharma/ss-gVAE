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

res_dir="${RESULTS_DIR}/results_bayesian_Malaria-patchwise/BS-128/no-noise_with0.2pollution_inv-loss-noveltest_May22_20kand5k"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 
do
    for i in {2..5}
    do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}  
        for val in 1e-1 1e-5 # 1e-5 # 1e-1 1e-5 1e-2 1e-3 1e-4  
        do
            for recon_param in 1 # 1 2 4 # 6 8 10 1
            do  
                for latent_param in 1 0.5 # 1 0.1  # 0.1 1
                do
                    for eta in 1 4 # 5 10 # 4 8 10
                    do
                        for ratio_l in 0.2 0.1 0.05 0.01 0 # 0.05 0.01 0 # 0.2 0.1 0.05 0.01 0
                        do 
                            for baseline in A # B C D E A # VAE
                            do                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param} 
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i}

                                python main.py malaria_dataset cifar10_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i} ${MALARIA_DATA} --ratio_known_outlier ${ratio_l} --lr 1e-05 --n_epochs 75 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --recon_param ${recon_param} --latent_param ${latent_param} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 4 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 1 --ablation_type ${baseline} --lr_milestone 10;   # --lr_milestone 40 --lr_milestone 20  --lr_milestone 15
                            done
                        done
                    done
                done 
            done
        done
    done
done


res_dir="${RESULTS_DIR}/results_bayesian_Malaria-patchwise/BS-128/no-noise_with0.2pollution_inv-loss-noveltest_May22_20kand5k"
mkdir -p ${res_dir}
for n_known_outlier_classes in 1 
do
    for i in {2..5}
    do
        mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}  
        for val in 1e-1 1e-5 # 1e-1 1e-5 1e-2 1e-3 1e-4  
        do
            for recon_param in 1 # 1 2 4 # 6 8 10 1
            do  
                for latent_param in 1 # 1 0.1  # 0.1 1
                do
                    for eta in 1 # 5 10 # 4 8 10
                    do
                        for ratio_l in 0.2 0.1 0.05 0.01 0 # 0.05 0.01 0 # 0.2 0.1 0.05 0.01 0
                        do 
                            for baseline in B C D E # A # VAE
                            do                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param} 
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}                       
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}
                                mkdir -p ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i}

                                python main.py malaria_dataset cifar10_LeNet ${res_dir}/n_known_outlier_classes_${n_known_outlier_classes}/ratio_l_${ratio_l}/recon_param_${recon_param}/latent_param_${latent_param}/eta_${eta}/val_${val}/baseline_${baseline}/run_${i} ${MALARIA_DATA} --ratio_known_outlier ${ratio_l} --lr 1e-05 --n_epochs 75 --batch_size 128 --weight_decay 0.5e-6 --pretrain False --n_known_outlier_classes ${n_known_outlier_classes} --seed ${i} --recon_param ${recon_param} --latent_param ${latent_param} --eta ${eta} --eps ${val} --tau ${val} --delta ${val} --n_jobs_dataloader 4 --ratio_known_normal 0 --ratio_pollution 0.2 --known_outlier_class 1 --ablation_type ${baseline} --lr_milestone 10;   # --lr_milestone 40 --lr_milestone 20  --lr_milestone 15
                            done
                        done
                    done
                done 
            done
        done
    done
done
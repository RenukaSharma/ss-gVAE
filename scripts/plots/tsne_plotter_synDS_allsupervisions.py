# ---------------------------------------------------------------------------
# Analysis / plotting script. Paths below were hardcoded in the original
# research codebase; they have been parameterized via environment variables:
#   RESULTS_DIR  - directory containing training run outputs
#   DATA_DIR     - root data directory
#   MALARIA_DATA - directory containing curated malaria images
# You will likely still need to edit specific `load_model` paths / file names
# to match your local results. Search for `os.environ.get` below.
# ---------------------------------------------------------------------------
import os
import tkinter
from sklearn.manifold import TSNE
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D # <--- This is important for 3d plotting
from matplotlib import cm
import numpy as np
import click
import torch
import logging
import random
import numpy as np
import PIL
from PIL import Image

from utils.config import Config
from utils.visualization.plot_images_grid import plot_images_grid, plot_matrix_grid
from DeepSAD import DeepSAD
from datasets.main import load_dataset
import torchvision.transforms as transforms

from datetime import datetime

timestamp_ = datetime.now().strftime("%Y_%m_%d-%I:%M:%S_%p")

matplotlib.rcParams['legend.fontsize'] = 30
matplotlib.rcParams['legend.handletextpad']=0.01

dataset_name = 'malaria_dataset'
data_path = "../../nanofibre/"
# net_name = "nanofibre_vae"
net_name = "cifar10_LeNet"
xp_path = (os.environ.get("RESULTS_DIR", "./results") + "/mvtec_dataset")
normal_class = 0
n_known_outlier_classes = 1
known_outlier_class = 1
ratio_known_normal = 0
ratio_known_outlier = 0.2
ratio_pollution = 0
seed = 0


# load_model = (os.environ.get("RESULTS_DIR", "./results") + "/syn-dataset/BS-128/sp_0.05/n_known_outlier_classes_1/ratio_l_0.2/recon_param_1/latent_param_0.5/eta_1/val_0.1/baseline_A/run_1/model.tar") # sup 0.2
# load_model = (os.environ.get("RESULTS_DIR", "./results") + "/syn-dataset/BS-128/sp_0.05/n_known_outlier_classes_1/ratio_l_0.2/recon_param_2/latent_param_0.1/eta_4/val_0.1/baseline_A/run_3/model.tar") # sup 0.2

# load_model = (os.environ.get("RESULTS_DIR", "./results") + "/syn-dataset/BS-128/sp_0.05/n_known_outlier_classes_1/ratio_l_0.2/recon_param_1/latent_param_1/eta_1/val_0.1/baseline_E/run_1/model.tar") # sup 0.2
# load_model = (os.environ.get("RESULTS_DIR", "./results") + "/syn-dataset/BS-128/sp_0.05/n_known_outlier_classes_1/ratio_l_0/recon_param_1/latent_param_1/eta_1/val_0.1/baseline_A/run_1/model.tar") # sup 0
# load_model = (os.environ.get("RESULTS_DIR", "./results") + "/syn-dataset/BS-128/sp_0.05/n_known_outlier_classes_1/ratio_l_0/recon_param_1/latent_param_1/eta_1/val_0.1/baseline_E/run_1/model.tar") # sup 0
# load_model = (os.environ.get("RESULTS_DIR", "./results") + "/syn-dataset/BS-128/sp_0.05/n_known_outlier_classes_1/ratio_l_0.49/recon_param_1/latent_param_1/eta_1/val_0.1/baseline_A/run_1/model.tar") # sup full
load_model = (os.environ.get("RESULTS_DIR", "./results") + "/syn-dataset/BS-128/sp_0.05/n_known_outlier_classes_1/ratio_l_0.49/recon_param_1/latent_param_1/eta_1/val_0.1/baseline_E/run_1/model.tar") # sup full
eta = 1.0
recon_param = 1.0
# device = "cuda:7"
device = "cpu"

deepSAD = DeepSAD(eta, recon_param, xp_path=xp_path)
deepSAD.set_network(net_name)

deepSAD.load_model(model_path=load_model, load_ae=True, map_location=device)

deepSAD.ae_net = deepSAD.ae_net.to(device)
deepSAD.ae_net.eval()

dataset = load_dataset(dataset_name, data_path, normal_class, known_outlier_class, n_known_outlier_classes,
                        ratio_known_normal, ratio_known_outlier, ratio_pollution,
                        random_state=np.random.RandomState(seed), length=5000)

train_labels = dataset.test_set.targets
print(type(train_labels))

final_train_data = torch.stack([I for I in dataset.test_set.tensor_batch])
final_train_data = final_train_data
train_labels = train_labels
print(final_train_data.shape)
final_train_data = final_train_data.to(device)
"""
final_train_data = torch.stack([I for I in dataset.train_set.tensor_batch])
final_train_data = final_train_data
train_labels = train_labels
print(final_train_data.shape)
final_train_data = final_train_data.to(device)
"""

outputs_encoded_mu, outputs_encoded_alpha, outputs_encoded_beta, outputs_recons_mu, outputs_recons_alpha, outputs_recons_beta, sample = deepSAD.ae_net(final_train_data)

print(outputs_encoded_mu.shape)

# np.save(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../features/tsne_test_feats_E.npy"), outputs_encoded_mu.cpu().detach().numpy())
# np.save(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../features/test_labels_E.npy"), np.array(train_labels))

# outputs_encoded_mu = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../features/tsne_test_feats_A.npy"))
# train_labels = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../features/test_labels_A.npy"))

"""
np.save(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../features/tsne_train_feats_A.npy"), outputs_encoded_mu.cpu().detach().numpy())
np.save(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../features/train_labels_A.npy"), np.array(train_labels))

outputs_encoded_mu = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../features/tsne_train_feats_A.npy"))
train_labels = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../features/train_labels_A.npy"))
"""
train_labels = np.array(train_labels)

sample_size = 2500
################### sampling ####################
# s = np.arange(train_labels.shape[0])
# np.random.shuffle(s) # shuffling step
# sample_size = 1000
# train_labels = train_labels[s[0:sample_size]]
# sample = sample[s[0:sample_size]]
# outputs_encoded_mu = outputs_encoded_mu[s[0:sample_size]]
#################################################

tsne = TSNE(2, verbose=1)
# tsne = TSNE(3, verbose=1)
# tsne_proj = tsne.fit_transform(outputs_encoded_mu) #### enable it
# tsne_proj = tsne.fit_transform(outputs_encoded_mu.cpu().detach().numpy())
# print(tsne_proj)
# Plot those points as a scatter plot and label them based on the pred labels
# cmap = cm.get_cmap('tab20')
############## Generating the scores ##############
scores = torch.norm(sample, dim=1) ** 2
scores = scores.detach().numpy()

predicted_labels = np.zeros_like(train_labels)
for i in range(scores.shape[0]):
    if(np.log(scores[i]) > np.log(scores).mean()):
        predicted_labels[i]=1
    else:
        predicted_labels[i]=0
# for i in range(scores.shape[0]):
#     if(scores[i] > 178.0):
#         predicted_labels[i]=1
#     else:
#         predicted_labels[i]=0

####################################################

######################
fig, ax = plt.subplots(figsize=(8,8))
# tsne_proj = tsne.fit_transform(outputs_encoded_mu.cpu().detach().numpy()) 
# np.save(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization/tsne_proj_E_sup0.49_")+timestamp_+".npy", tsne_proj)
# tsne_proj = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization/tsne_proj_A_2021_08_12-01:51:47_AM.npy")) # sup 0.2 A
# tsne_proj = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization/tsne_proj.npy")) # sup 0.2 A
# tsne_proj = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization/tsne_proj_E_2021_08_12-02:25:36_AM.npy")) # sup 0.2 E
# tsne_proj = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization/tsne_proj_A_sup02021_08_12-11:17:38_PM.npy")) # sup 0 A
# tsne_proj = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization/tsne_proj_E_sup0_2021_08_13-12:19:19_AM.npy")) # sup 0 E
# tsne_proj = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization/tsne_proj_A_sup0.49_2021_08_13-12:25:05_AM.npy")) # sup 0.49 A
tsne_proj = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization/tsne_proj_E_sup0.49_2021_08_13-12:28:01_AM.npy")) # sup 0.49 E
num_categories = 2

list_1 = []
list_2 = []
list_3 = []
list_4 = [] # for legend

for i in range(predicted_labels.shape[0]):
    list_1.append(tsne_proj[i,0]) # x's
    list_2.append(tsne_proj[i,1]) # y's
    
    if (predicted_labels[i]==train_labels[i]): 
        legend_="True" 
        marker_dict_1 ={0:"<", 1:">"}  
        list_3.append(marker_dict_1[train_labels[i]])
    else:
        legend_="False"
        marker_dict_2 ={0:"P", 1:"X"}
        list_3.append(marker_dict_2[train_labels[i]])
     
    if predicted_labels[i]==0:
        label_ = "Inliers"
    else:
        label_ = "Outliers"
    # print("Appending",legend_,label_)
    list_4.append(legend_+" "+label_)

flag_tp=0
count_tp = 0
flag_tn=0
count_tn = 0
flag_fp=0
count_fp=0
flag_fn=0
count_fn=0
# colors=["#0000FF", "#00FF00", "#FF0066"]
color_scheme = {"tp":"olive", "tn":"salmon", "fp":"indigo", "fn":"deepskyblue"}

marker_size = 150 # 100 was good
# for x, y, m, l in zip(list_1, list_2, list_3, list_4):
#     if l=="True Inliers":
#         ax.scatter([x], [y] , marker = m, label = l if flag_tp==0 else "", c = color_scheme["tp"], s= marker_size)
#         flag_tp=1
#     if l=="True Outliers":
#         ax.scatter([x], [y] , marker = m, label = l if flag_tn==0 else "", c = color_scheme["tn"], s= marker_size)
#         flag_tn=1
#     if l=="False Inliers":        
#         if(count_fp<=100):
#             ax.scatter([x], [y] , marker = m, label = l if flag_fp==0 else "", c = color_scheme["fp"], s= marker_size)
#             count_fp+=1
#         flag_fp=1
#     if l=="False Outliers":        
#         if(count_fn<=100):
#             ax.scatter([x], [y] , marker = m, label = l if flag_fn==0 else "", c = color_scheme["fn"], s= marker_size)        
#             count_fn+=1
#         flag_fn=1

for x, y, m, l in zip(list_1, list_2, list_3, list_4):
    if l=="True Inliers":
        if count_tp < 1:
            ax.scatter([x], [y] , marker = m, label = l if flag_tp==0 else "", c = color_scheme["tp"], s= marker_size)
            count_tp+=1
        flag_tp=1
    if l=="True Outliers":
        if count_tn < 1:
            ax.scatter([x], [y] , marker = m, label = l if flag_tn==0 else "", c = color_scheme["tn"], s= marker_size)
            count_tn+=1
        flag_tn=1
    

for x, y, m, l in zip(list_1, list_2, list_3, list_4):    
    if l=="False Inliers":        
        if(count_fp< 1):
            ax.scatter([x], [y] , marker = m, label = l if flag_fp==0 else "", c = color_scheme["fp"], s= marker_size)
            count_fp+=1
        flag_fp=1
    if l=="False Outliers":        
        if(count_fn< 1):
            ax.scatter([x], [y] , marker = m, label = l if flag_fn==0 else "", c = color_scheme["fn"], s= marker_size)        
            count_fn+=1
        flag_fn=1


# ax.scatter(tsne_proj[indices,0], tsne_proj[indices,1], label = label_, alpha=0.5, marker = marker_dict_1[lab])
handles, labels = plt.gca().get_legend_handles_labels()
by_label = dict(zip(labels, handles))
# plt.legend(by_label.values(), by_label.keys())  
# predicted X, actual Y; Inliers- Predicted Inliers, Outliers- Predicted Outliers, True- 

##### To keep legends on ##################
# lgnd = ax.legend([by_label['True Inliers'],by_label['False Outliers'],by_label['True Outliers'],by_label['False Inliers']],['Predicted Inlier, Actual Inlier','Predicted Outlier, Actual Inlier','Predicted Outlier, Actual Outlier','Predicted Inlier, Actual Outlier'], markerscale=2, loc='lower right') # legend, remove if you don't want the legend
lgnd = ax.legend([by_label['True Inliers'],by_label['False Outliers'],by_label['True Outliers'],by_label['False Inliers']],['Predicted Inlier, Actual Inlier','Predicted Outlier, Actual Inlier','Predicted Outlier, Actual Outlier','Predicted Inlier, Actual Outlier'], markerscale=2) # legend, remove if you don't want the legend
lgnd.legendHandles[0]._sizes = [500]
lgnd.legendHandles[1]._sizes = [500]
lgnd.legendHandles[2]._sizes = [500]
lgnd.legendHandles[3]._sizes = [500]
###########################################

# Hide axes ticks
ax.set_xticks([])
ax.set_yticks([])
# ax.legend(fontsize='large', markerscale=2)
# plt.show()
######################

########################
# fig = plt.figure()
# ax = fig.add_subplot(111, projection='3d')
# num_categories = 2
# for lab in range(num_categories):
#     indices = train_labels==lab
#     ax.scatter(tsne_proj[indices,0], tsne_proj[indices,1],tsne_proj[indices,2], label = lab ,alpha=0.5)
# ax.legend(fontsize='large', markerscale=2)

# # import pickle
# # pickle.dump(fig, open('FigureObject.fig.pickle', 'wb'))

# plt.show()
# # Hide axes ticks
# ax.set_xticks([])
# ax.set_yticks([])
# ax.set_zticks([])
########################

plt.grid(False)
plt.axis('off')
plt.tight_layout()
# Hide grid lines
ax.grid(False)

plt.savefig(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization/just_legends.png"))
# plt.savefig(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization/tsne_test_withmarkers_E_sup0.49_")+timestamp_+".png")
# plt.savefig((os.environ.get("RESULTS_DIR", "./results") + "/malaria_dataset/plotsGenerated_May25_onwards/tsne_test_3d_1.fig"))
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


sup_per = "full"
baseline = "_E"
outputs_encoded_mu = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../npy files/tsne_test_feats_")+sup_per+"sup"+baseline+".npy")
print(outputs_encoded_mu.shape)

train_labels = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../npy files/test_labels.npy"))

train_labels = np.array(train_labels)
sample_size = 2500
################### sampling ####################
# s = np.arange(train_labels.shape[0])
# np.random.shuffle(s) # shuffling step
# sample_size = 1500
# train_labels = train_labels[s[0:sample_size]]
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
scores = np.linalg.norm(outputs_encoded_mu, axis=1) ** 2

predicted_labels = np.zeros_like(train_labels)
for i in range(scores.shape[0]):
    if(np.log(scores[i]) > np.log(scores).mean()):
        predicted_labels[i]=1
    else:
        predicted_labels[i]=0

####################################################

######################
fig, ax = plt.subplots(figsize=(8,8))
root_fol = os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization_malaria/")
# tsne_proj = tsne.fit_transform(outputs_encoded_mu) 
# np.save(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization_malaria/tsne_proj")+baseline+"_sup"+sup_per+"_"+timestamp_+".npy", tsne_proj)
# tsne_proj = np.load(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization_malaria/tsne_proj_E_sup0_2021_08_13-02:02:55_AM.npy")) # sup 0 E

# tsne_proj = np.load(root_fol+"tsne_proj_E_sup0_2021_08_13-02:02:55_AM"+".npy") # sup 0 E
# tsne_proj = np.load(root_fol+"tsne_proj_E_sup0.2_2021_08_13-01:59:53_AM"+".npy") # sup 0.2 E
tsne_proj = np.load(root_fol+"tsne_proj_E_sup0.49_2021_08_13-01:54:04_AM"+".npy") # sup 0.49 E
# tsne_proj = np.load(root_fol+"tsne_proj_sup0_2021_08_13-02:01:44_AM"+".npy") # sup 0 A 
# tsne_proj = np.load(root_fol+"tsne_proj_sup0.2_2021_08_13-01:58:52_AM"+".npy") # sup 0.2 A
# tsne_proj = np.load(root_fol+"tsne_proj_A_sup0.49_2021_08_13-01:49:44_AM"+".npy") # sup 0.49 A

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
flag_tn=0
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
        ax.scatter([x], [y] , marker = m, label = l if flag_tp==0 else "", c = color_scheme["tp"], s= marker_size)
        flag_tp=1
    if l=="True Outliers":
        ax.scatter([x], [y] , marker = m, label = l if flag_tn==0 else "", c = color_scheme["tn"], s= marker_size)
        flag_tn=1
    

for x, y, m, l in zip(list_1, list_2, list_3, list_4):    
    if l=="False Inliers":        
        if(count_fp<=50):
            ax.scatter([x], [y] , marker = m, label = l if flag_fp==0 else "", c = color_scheme["fp"], s= marker_size)
            count_fp+=1
        flag_fp=1
    if l=="False Outliers":        
        if(count_fn<=45):
            ax.scatter([x], [y] , marker = m, label = l if flag_fn==0 else "", c = color_scheme["fn"], s= marker_size)        
            count_fn+=1
        flag_fn=1

# ax.scatter(tsne_proj[indices,0], tsne_proj[indices,1], label = label_, alpha=0.5, marker = marker_dict_1[lab])
handles, labels = plt.gca().get_legend_handles_labels()
by_label = dict(zip(labels, handles))
# plt.legend(by_label.values(), by_label.keys())  
# predicted X, actual Y; Inliers- Predicted Inliers, Outliers- Predicted Outliers, True- 

# to keep the legends
######################################
# lgnd = ax.legend([by_label['True Inliers'],by_label['False Outliers'],by_label['True Outliers'],by_label['False Inliers']],['Predicted Inlier, Actual Inlier','Predicted Outlier, Actual Inlier','Predicted Outlier, Actual Outlier','Predicted Inlier, Actual Outlier'], markerscale=2, loc='lower right') # legend, remove if you don't want the legend
# lgnd.legendHandles[0]._sizes = [500]
# lgnd.legendHandles[1]._sizes = [500]
# lgnd.legendHandles[2]._sizes = [500]
# lgnd.legendHandles[3]._sizes = [500]
######################################
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

plt.savefig(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../plotting_visualization_malaria/tsne_test_withmarkers")+baseline+"_sup_"+sup_per+"_"+timestamp_+"_"+str(sample_size)+"_samples.png")
# plt.savefig((os.environ.get("RESULTS_DIR", "./results") + "/malaria_dataset/plotsGenerated_May25_onwards/tsne_test_3d_1.fig"))
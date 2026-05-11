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
import json
import pandas as pd
import matplotlib.pyplot as plt
import seaborn as sns
import gc
import math
from matplotlib.transforms import Affine2D
from matplotlib import rc
from datetime import datetime

# plt.rcParams.update({'font.size': 12})

plt.rcParams.update({'font.size': 15, 'font.family': 'sans-serif'})

fig, ax= plt.subplots()
delta_x=0.002
delta_y=0.004
trans1 = Affine2D().translate(-2*delta_x, 0) + ax.transData
trans2 = Affine2D().translate(delta_x, 0) + ax.transData
trans3 = Affine2D().translate(-2*delta_x, 0) + ax.transData
trans4 = Affine2D().translate(3*delta_x, 0) + ax.transData
trans5 = Affine2D().translate(4*delta_x, 0) + ax.transData

save_csv=False
# save_csv=True

# print ("The entered number of outlier classes:", n_known_outlier_classes)


# print("Ours' (Ablation A) mean and std:\n", mean_list,"\n", std_list)
mean_list = [0.757798, 0.759274, 0.966426, 0.976019, 0.988839] # done
std_list = [0.007105163636362, 0.001608409610318, 0.00585019032401, 0.006061737342841, 0.014781116591389] # to do
plt.errorbar([0, 0.01, 0.05, 0.1, 0.2], mean_list, std_list, marker="h", label="ss-gVAE (Ours)")
# plt.errorbar([0, 0.01, 0.05, 0.1, 0.2], mean_list , std_list, marker="h", label="ours")

# print("Ablation E's mean and std are:\n",mean_list,"\n", std_list)
mean_list = [0.63, 0.635618274111675, 0.640603553299492, 0.922364805414551, 0.946704568527919] 
std_list = [0.001075659011678, 9.02E-06, 0.001215228426396, 0.030073773265652, 0.012293526858716]
plt.errorbar([0, 0.01, 0.05, 0.1, 0.2], mean_list , std_list, marker="h", label="DeepSAD", transform=trans2)

plt.errorbar([0], [0.63] , [0.001075659011678], marker="P", label="DeepSVDD", transform=trans1)

plt.errorbar([0], [0.654588832487309] , [0.001491265468817], marker="P", label="OC-SVM-Hybrid", transform=trans3)

mean_list = [0.654588832487309 , 0.681475465313029 , 0.740448595600677, 0.920596954314721 , 0.937148448956571]
std_list = [0.001491265468817, 0.008443556873443, 0.019745492662774, 0.001463507639166, 0.002757940274906]
plt.errorbar([0, 0.01, 0.05, 0.1, 0.2], mean_list , std_list, marker="h", label="SSAD-Hybrid", transform=trans4)

# print("Ablation D's mean and std are:\n",mean_list,"\n", std_list)
mean_list = [ 0.525077, 0.526063, 0.574457, 0.620205, 0.678379] 
std_list = [0.0043, 0.005631413876701, 0.01594661937004, 0.055842135608702, 0.034472192096611]
plt.errorbar([0, 0.01, 0.05, 0.1, 0.2], mean_list , std_list, marker="h", label="ss-DCAE", transform=trans3)

# print("BinCls's mean and std are:\n",mean_list,"\n", std_list)
mean_list = [0.824885290075427, 0.848509176793966, 0.85547482874674, 0.869828246236757] 
std_list = [0.028316319454264, 0.048434278103333, 0.04079047491694, 0.025137065321251]
plt.errorbar([0.01, 0.05, 0.1, 0.2], mean_list , std_list, marker="h", label="BinClass", transform=trans5)


plt.xlabel(r"Increasing levels of supervision $\gamma$")
plt.ylabel("AUC")

plt.grid()
plt.legend(prop={"size":11, "family":"sans-serif" })

plt.tight_layout()

fig.savefig((os.environ.get("RESULTS_DIR", "./results") + "/syn-dataset/synDS_Ours+Baseline.png"), dpi=300, bbox_inches='tight')

plt.close()
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

plt.rcParams.update({'font.size': 17, 'font.family': 'sans-serif'})

fig, ax= plt.subplots()
delta_x=0.001
delta_y=0.004
trans1 = Affine2D().translate(delta_x, 0) + ax.transData
trans2 = Affine2D().translate(2*delta_x, 0) + ax.transData
trans3 = Affine2D().translate(3*delta_x, 0) + ax.transData
trans4 = Affine2D().translate(4*delta_x, 0) + ax.transData
trans5 = Affine2D().translate(-delta_x, 0) + ax.transData
trans6 = Affine2D().translate(-4*delta_x, 0) + ax.transData


# print("Ours' (Ablation A) mean and std:\n", mean_list,"\n", std_list)
mean_list = [0.757798, 0.759274, 0.966426, 0.976019, 0.988839] # done
std_list = [0.007105163636362, 0.001608409610318, 0.00585019032401, 0.006061737342841, 0.014781116591389] # to do
plt.errorbar([0, 0.01, 0.05, 0.1, 0.2], mean_list, std_list, marker="h", label="ss-gVAE (Ours)")
# plt.errorbar([0, 0.01, 0.05, 0.1, 0.2], mean_list , std_list, marker="h", label="ours")

# print("Ablation B's mean and std are:\n",mean_list,"\n", std_list)
mean_list = [0.707756, 0.746274, 0.828945, 0.949250, 0.969363] #done
std_list = [0.001246409586498, 0.002167290410591, 0.001095880850044, 0.006574748448736, 0.002017411896347] #done

plt.errorbar([0, 0.01, 0.05, 0.1, 0.2], mean_list , std_list, marker="h", label="A1", transform=trans5)

# print("Ablation C's mean and std are:\n",mean_list,"\n", std_list)
mean_list = [0.630992, 0.650533, 0.735588, 0.753072, 0.885447] 
std_list = [0.00240600632429, 0.002937686734328, 0.00052478923318, 0.007129232034661, 0.003103918574854]
plt.errorbar([0, 0.01, 0.05, 0.1, 0.2], mean_list , std_list, marker="h", label="A2", transform=trans6)

# print("Ablation D's mean and std are:\n",mean_list,"\n", std_list)
mean_list = [ 0.525077, 0.526063, 0.574457, 0.620205, 0.678379] # done
std_list = [0.0043, 0.005631413876701, 0.01594661937004, 0.055842135608702, 0.034472192096611] # done
plt.errorbar([0, 0.01, 0.05, 0.1, 0.2], mean_list , std_list, marker="h", label="A3", transform=trans3)

# print("Ablation E's mean and std are:\n",mean_list,"\n", std_list)
mean_list = [0.63, 0.635618274111675, 0.640603553299492, 0.922364805414551, 0.946704568527919] # done
std_list = [0.001075659011678, 9.02E-06, 0.001215228426396, 0.030073773265652, 0.012293526858716] # done
plt.errorbar([0, 0.01, 0.05, 0.1, 0.2], mean_list , std_list, marker="h", label="A4", transform=trans4)

plt.xlabel(r"Increasing levels of supervision $\gamma$")

# plt.xlabel("Ratio of labeled anomalies in training set")
plt.ylabel("AUC")

plt.grid()
plt.legend(prop={"size":11, "family":"sans-serif" }, loc=4)

plt.tight_layout()

fig.savefig((os.environ.get("RESULTS_DIR", "./results") + "/syn-dataset/synDS_ablation.png"), dpi=300, bbox_inches='tight')

plt.close()

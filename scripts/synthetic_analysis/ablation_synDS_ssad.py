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

import sys

# plt.rcParams.update({'font.size': 12})
plt.rcParams.update({'font.size': 12, 'font.family': 'serif'})

fig, ax= plt.subplots()
delta_x=0.001
delta_y=0.004
trans1 = Affine2D().translate(delta_x, 0) + ax.transData
trans2 = Affine2D().translate(2*delta_x, 0) + ax.transData
trans3 = Affine2D().translate(3*delta_x, 0) + ax.transData
trans4 = Affine2D().translate(4*delta_x, 0) + ax.transData

save_csv=False
# save_csv=True

root_dir = (os.environ.get("RESULTS_DIR", "./results") + "/syn-dataset/baseline-ssad-hybrid")

collated_data =[]

for ratio_l in os.listdir(root_dir):
    # print (ratio_l)
    for kappa in os.listdir(os.path.join(root_dir, ratio_l)):
        # print(kappa)
        # print("Accept")
        for run in os.listdir(os.path.join(root_dir, ratio_l, kappa)):
            # print ("The run number is",run)
            if run!="run_6_with-recon-param":
                run_val = float(run[4:])
                kappa_val = float(kappa[6:])                
                ratio_l_val = float(ratio_l[8:])

                file_path = os.path.join(root_dir, ratio_l, kappa, run,"results.json")
                if os.path.exists(file_path):
                    with open(file_path) as read_file:
                        # print("The results file exists")
                        data = json.load(read_file)
                        auc = data['test_auc']
                        row = [ratio_l_val, kappa_val, run_val, auc]
                        # print("The row is", row)

                        collated_data.append(row)

# print(collated_data)
df = pd.DataFrame(collated_data, columns=["ratio_l", "kappa", "run","auc"])
df.to_csv((os.environ.get("RESULTS_DIR", "./results") + "/syn-dataset/ssad_results.csv"))
# df.to_csv((os.environ.get("RESULTS_DIR", "./results") + "/syn-dataset/syn-dataset_sp0.05.csv"))
# df_eta_1.to_csv((os.environ.get("RESULTS_DIR", "./results") + "/syn-dataset/syn-dataset_sp0.05_eta1.csv"))
# print("Saved the csv file")
# print(df)

print(df.groupby(["ratio_l", "kappa"]).mean())
print(df.groupby(["ratio_l", "kappa"]).std())
# plt.xlabel("Ratio of labeled anomaliess in training set")
# plt.ylabel("AUC")

# plt.grid()
# plt.legend(prop={"size":11, "family":"serif" })

# plt.tight_layout()

# fig.savefig("plotsGenerated_Jan9_onwards/MVTec_ablation_all_"+str(datetime.now())+".png")

# plt.close()


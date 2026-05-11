# ---------------------------------------------------------------------------
# MVTec dataset curation utility. Paths below were hardcoded in the original
# codebase; they have been parameterized via environment variables:
#   MVTEC_DATA - directory containing the MVTec AD dataset (raw)
#   DATA_DIR   - root data directory (for output)
# Run after downloading MVTec AD from https://www.mvtec.com/company/research/datasets/mvtec-ad/
# ---------------------------------------------------------------------------
import torch 
import torchvision.transforms as transforms
from PIL import Image
import os
from PIL import ImageFile
import numpy as np 

ImageFile.LOAD_TRUNCATED_IMAGES=True

random_crop_32 = transforms.RandomCrop((64,64))
root_dir = (os.environ.get("RESULTS_DIR", "./results") + "/mvtec_AD_dataset/carpet/good")

# defect_type="thread" # to change
dest_dir = (os.environ.get("RESULTS_DIR", "./results") + "/mvtec_AD_dataset/carpet-with-novel-ano-in-test/train/good")
for file_name in os.listdir(root_dir):
    # print(file_name)
    file_wo_ext = file_name[:-4]
    print(file_wo_ext)
    img = Image.open(os.path.join(root_dir, file_name))
    for i in range(8):
	    
	    img_cropped = random_crop_32(img)
	    img_cropped.save(os.path.join(dest_dir, str(file_wo_ext)+"_"+str(i)+".png"))
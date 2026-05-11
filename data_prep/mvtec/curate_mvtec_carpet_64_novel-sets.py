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
root_dir = (os.environ.get("RESULTS_DIR", "./results") + "/mvtec_anomaly_detection_textureANDobject/textures/carpet/test")
mask_dir = (os.environ.get("RESULTS_DIR", "./results") + "/mvtec_anomaly_detection_textureANDobject/textures/carpet/ground_truth")
# defect_type="color" 
# defect_type="hole"
defect_type="thread"
# defect_type="cut"
# defect_type="metal_contamination" #get more
# dest_dir = (os.environ.get("RESULTS_DIR", "./results") + "/mvtec_AD_dataset/carpet-with-novel-ano-in-test/train/not_good")
dest_dir = (os.environ.get("RESULTS_DIR", "./results") + "/mvtec_AD_dataset/carpet-with-novel-ano-in-test/test/not_good")
for file_name in os.listdir(os.path.join(root_dir,defect_type)):
    # print(file_name)
    file_wo_ext = file_name[:-4]
    print(file_wo_ext)
    img = Image.open(os.path.join(root_dir,defect_type, file_name))
    mask = Image.open(os.path.join(mask_dir,defect_type, file_wo_ext+"_mask.png"))
    # for i in range(32): # for 32
    # 	for j in range(32):
    # for i in range(1,25): # for 40
    # 	for j in range(1,25):
    # for i in range(1,20): # for 50
    # 	for j in range(1,20):
    # for i in range(1,18): # for 56
    # 	for j in range(1,18):
    # for i in range(1,51): # for 20
    # 	for j in range(1,51):
    # for i in range(1,17): # for 59
    # 	for j in range(1,17):
    # for i in range(1,14): # for 70
    # 	for j in range(1,14):
    # for i in range(1,22): # for 70
    # 	for j in range(1,22):
    # for i in range(1,26): # for 38
    # 	for j in range(1,26):
    # for i in range(1,19): # for 53
    # 	for j in range(1,19):
    # for i in range(1,40): # for 25
    # 	for j in range(1,40):
    for i in range(1,11): # for 93
    	for j in range(1,11):

    		len_ = 93

    		x1= len_*i 
    		y1= len_*j 

    		# x1= 16*i 
    		# y1= 16*j

    		x2= x1+64
    		y2= y1+64

    		if( x2 <= img.size[0] and y2 <= img.size[1]):

    			img_cropped = img.crop((x1,y1,x2,y2))
    			mask_cropped = mask.crop((x1,y1,x2,y2))
    			# img_cropped = random_crop_32(img)
    			# print(mask_cropped)

    			if(np.sum(np.array(mask_cropped)/255) >= 2048):			    	

    				print("np.sum(np.array(mask_cropped)/255)=", np.sum(np.array(mask_cropped)/255))
			    	img_cropped.save(os.path.join(dest_dir,str(defect_type)+"_"+str(len_)+"_"+str(file_wo_ext)+str(i)+"_"+str(j)+".png" ))
			    	# mask_cropped.save(os.path.join(dest_dir,"mask",str(file_wo_ext)+str(i)+"_"+str(j)+".png" ))

"""
dest_dir = (os.environ.get("RESULTS_DIR", "./results") + "/mvtec_AD_dataset/carpet_curated/no_good/color")
import matplotlib.pyplot as plt 


# plot image (2 subplots)

fig, ax= plt.subplots()
ax.tick_params(axis='both', which='both', bottom=False, top=False)
# plt.xticks([])
for i in range(1,11):
	img1 = Image.open((os.environ.get("RESULTS_DIR", "./results") + "/mvtec_AD_dataset/carpet_curated/no_good/color/")+str(i)+".png")
	img2 = Image.open((os.environ.get("RESULTS_DIR", "./results") + "/mvtec_AD_dataset/carpet_curated/no_good/color/mask/")+str(i)+".png")
	plt.subplot(4,10,i)
	plt.imshow(img1)
	# plt.tick_params(axis='both', which='both', bottom=False, top=False)
	plt.xticks([])

	plt.subplot(4,10,i+10)
	plt.imshow(img2, cmap='gray', vmin=0, vmax=255)
	plt.xticks([])
	# plt.tick_params(axis='both', which='both', bottom=False, top=False)
for i in range(11,21):
	img1 = Image.open((os.environ.get("RESULTS_DIR", "./results") + "/mvtec_AD_dataset/carpet_curated/no_good/color/")+str(i)+".png")
	img2 = Image.open((os.environ.get("RESULTS_DIR", "./results") + "/mvtec_AD_dataset/carpet_curated/no_good/color/mask/")+str(i)+".png")
	plt.subplot(4,10,i+10)
	plt.imshow(img1)
	plt.xticks([])
	# plt.tick_params(axis='both', which='both', bottom=False, top=False)

	plt.subplot(4,10,i+20)
	plt.imshow(img2, cmap='gray', vmin=0, vmax=255)
	plt.xticks([])
	# plt.tick_params(axis='both', which='both', bottom=False, top=False)
plt.show()
# plt.axis("off")
plt.savefig((os.environ.get("RESULTS_DIR", "./results") + "/mvtec_AD_dataset/carpet_curated/no_good/fig_1.png"))
"""
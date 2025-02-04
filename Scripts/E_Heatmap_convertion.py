import numpy as np
import matplotlib.pyplot as plt
from matplotlib.colors import Normalize
# import cv2
import delta
import os

res_path = '../Data/Delta_Results/'
data_path = os.path.join(res_path, 'Position000033.pkl')
data = delta.pipeline.Position(None, None, None)
data.load(data_path)

label_stack = data.rois[0].label_stack

# create an empty heatmap with the same shape as the image
image_shape = (2304, 2304)  # adjust this to match the image size
heatmap = np.zeros(image_shape)

# extract the GFP intensity values for each cell at frame x
time_point = 24
cell_ids = np.unique(label_stack[time_point]) 
cell_ids = cell_ids[cell_ids != 0]  # filter out background
cell_ids = cell_ids - 1  # cell id starts from 1

for cell in data.rois[0].lineage.cells:
    if cell['id'] in cell_ids:
        for i, frame in enumerate(cell['frames']):
            if frame == time_point:
                intensity = cell['fluo2'][i]
                heatmap[label_stack[time_point] == cell['id'] + 1] = intensity
    
# if no valid intensity values are found, print a warning
if np.max(heatmap) == 0:
    print("Warning: No valid intensity values found in the heatmap.")


# extract the non-background values
non_background_values = heatmap[heatmap > 0]

# if there are non-background values, normalize the heatmap
if len(non_background_values) > 0:
    min_val = np.min(non_background_values)
    max_val = np.max(non_background_values)
    # normalize the heatmap to the range [0, 1]
    normalized_heatmap = (heatmap - min_val) / (max_val - min_val)
    normalized_heatmap[heatmap == 0] = 0  # set background to 0
else:
    print("No valid cell intensities found. Heatmap will remain all zeros.")
    normalized_heatmap = heatmap  # heatmap remains all zeros if no valid intensities are found

# apply a colormap to the normalized heatmap
colored_heatmap = plt.cm.plasma(normalized_heatmap)

#  set the background to black
colored_heatmap[normalized_heatmap == 0] = [0, 0, 0, 1]  # RGBA 格式

# visualize the heatmap
plt.figure(figsize=(8, 8))
plt.imshow(colored_heatmap)
plt.colorbar(label='GFP Intensity')
plt.axis('off')
output_file = "./gfp_intensity_heatmap.svg"
plt.savefig(output_file, format='svg', bbox_inches='tight', transparent=True)
plt.show()
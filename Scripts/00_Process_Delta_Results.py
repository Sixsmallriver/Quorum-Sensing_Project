import delta
import pandas as pd
import os
from PIL import Image


res_path = '../Data/Delta_results/'

# Load all data
all_df = pd.DataFrame()

for i in range(0, 40):

    new_spot = f"{i:02d}"  # Format spot number with leading zeros if necessary
    data_path = os.path.join(res_path,f'Position0000{new_spot}.pkl')
    data = delta.pipeline.Position(None, None, None)
    data.load(data_path)

    # Get data of first position 
    roi = data.rois[0]
    
    # Set center of each cell based on pole positions
    for cell in roi.lineage.cells:
        cell['x'] = []
        cell['y'] = []
        for j, frame in enumerate(cell['frames']):
            p1 = cell['new_pole'][j]
            p2 = cell['old_pole'][j]

            c = (p1 + p2) / 2.0
            cell['x'].append(c[0])
            cell['y'].append(c[1])

    # Calculate the integrated Density (can also be combined with the previous step)
    # Fluo1, flluo2 are already integrated densities, for intensity per pixel, use 'fluo1/area', 'fluo2/area'
    for cell in roi.lineage.cells:
        cell['IntDen'] = []
        for j, frame in enumerate(cell['frames']):
            a = cell['area'][j]
            f = cell['fluo1'][j]

            intDen = a * f
            cell['IntDen'].append(intDen)

    # Make pandas data frame
    cells_df = pd.concat([pd.DataFrame(cell) for cell in roi.lineage.cells], sort=False)
    cells_df['series'] = i
    if i < 20:
        cells_df['Autoinducer'] = "With"
        if i in range(0, 5):
            cells_df['gene'] = "lasR"
        elif i in range(5, 10):
            cells_df['gene'] = "rpsL"
        elif i in range(10, 15):
            cells_df['gene'] = "lasI"
        elif i in range(15, 20):
            cells_df['gene'] = "lasB"
    else:
        cells_df['Autoinducer'] = "Without"
        if i in range(20, 25):
            cells_df['gene'] = "lasR"
        elif i in range(25, 30):
            cells_df['gene'] = "rpsL"
        elif i in range(30, 35):
            cells_df['gene'] = "lasI"
        elif i in range(35, 40):
            cells_df['gene'] = "lasB"
    all_df = pd.concat([all_df, cells_df], ignore_index=True, sort=False)

# Print or use all_df
# print(all_df)

all_df.to_csv(os.path.join(res_path,'las_all_delta_results.csv'))


# # Save segmentation as tiff images
# if not os.path.isdir('segmentation'):
# 	os.makedirs('segmentation')
# for i,label in enumerate(roi.label_stack):
# 	img = Image.fromarray(label)
# 	img.save(os.path.join('segmentation', f'frame_{i+1:02}.tif'))

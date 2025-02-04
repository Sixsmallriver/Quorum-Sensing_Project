# Scripts

## Description
This folder contains all the scripts used for data analysis.

### Processing Scripts
Files that begin with a number are meant for processing the data. They should be executed in the following order:
0. 00_Process_Delta_Results.py
1. 01_Clustering.ipynb 01_Extra_second_time_cleanning_for_clustering.ipynb
2. 02_Distance_Measurement.R
3. 03_0_Lineage_BatchSubmission.R 03_1_lineage.Rmd

### Analysis Scripts
Once the dataset has been processed, you can perform downstream analyses. Files that start with a letter are designed for further analysis. Although they are ideally executed sequentially, you may run any individual script independently based on your area of interest:
0. A0_Colony_expression_overtime.ipynb
1. A1_Bimodality_Analysis.ipynb
2. B1_Distance_Analysis.ipynb
3. B2_Spatial_Autocorrelation_MoransI.ipynb
4. B3_Hot-spot_Analysis.ipynb
5. C0_Lineage_Analysis.ipynb
6. C1_MachineLearning_Analysis_lasI.ipynb
7. D_Pulse_analysis.ipynb
8. E_Heatmap_convertion.py
9. F_tree_plot.R


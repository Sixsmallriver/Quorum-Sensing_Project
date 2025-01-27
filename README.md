# Quorum-Sensing_Project

## Description
This project aims to disentangle the spatial patterns of Quorum Sensing System in *Pseudomonas aeruginosa* by using high resolution fluorescent microscopy with microcolonies grow on agarose patches.

## Analysis
The single-cell segmentation and tracking was done by Delta2 (link) based on the phase contrast channel of the microscopic images. The Quorum Sensing gene expressions are investigated through the mCherry and GFP channel fluorescent intensity.

After segmentation and tracking, listed downstream analysis was conducted:
  1. Clustering into microcolonies
  2. Single cell level and colony level gene expression over time
  3. Spatial gradients of QS genes within microcolonies
  4. Lineage Effect Analysis by comparing gene expressions between sister cells, neighbor cells and random cells within the same microcolonies
  5. Machine learning model to predict fluorescent peak in cells' lifespan

#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Nov 13 10:03:42 2021

@author: ning
"""
import numpy as np
import pandas as pd
import seaborn as sns
from nilearn.datasets import fetch_atlas_harvard_oxford,load_mni152_template,load_mni152_brain_mask
from nilearn.input_data import NiftiMasker
from nilearn import plotting
from matplotlib import pyplot as plt
sns.set_context('poster')
data = fetch_atlas_harvard_oxford('cort-prob-2mm','../../../../Downloads/Nilearn')
maps = data['maps']
names = data['labels'][1:]
brain = load_mni152_template()
mask = load_mni152_brain_mask()
masker = NiftiMasker(mask,)
masker.fit(brain)
map_data = masker.transform(maps)

con_dict = {'Within unconscious':[
                'Temporal Fusiform Cortex, anterior division',# fusiform
                'Temporal Fusiform Cortex, posterior division',# fusiform
                'Middle Frontal Gyrus',# middle frontal
                ],
            'Conscious to unconscious generalization':[
                 'Lingual Gyrus',# lingual
                 'Superior Frontal Gyrus', #inferior temporal lobe?
                 'Temporal Fusiform Cortex, anterior division',# inferior parietal
                 'Superior Parietal Lobule',# superior parietal
                 ]
            }

for condition,picked_rois in con_dict.items():
    fig,ax = plt.subplots(figsize = (16,10),
                            )
    picked_rois = con_dict[condition]
    combined_rois = []
    for roi_name in picked_rois:
        idx_roi, = np.where(np.array(names) == roi_name)
        combined_rois.append(map_data[idx_roi])
    combined_rois = np.sum(combined_rois,axis = 0)
    combined_rois[combined_rois > 0] = 1
    combined_rois = masker.inverse_transform(combined_rois)
    plotting.plot_roi(combined_rois,
                      figure = fig,
                      axes = ax,
                      title = condition,
                      draw_cross = False,
                      cmap = None,
                      # cut_coords = (35,21,39),
                      display_mode = 'mosaic',
                      )



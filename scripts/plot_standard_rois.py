# -*- coding: utf-8 -*-
"""
Created on Sat Oct 31 00:00:33 2020

@author: ning
"""

from nilearn.datasets import fetch_atlas_harvard_oxford,load_mni152_template,load_mni152_brain_mask
from nilearn.input_data import NiftiMasker
from nilearn import plotting
from matplotlib import pyplot as plt

data = fetch_atlas_harvard_oxford('cort-prob-2mm','../../../../Downloads/Nilearn')
maps = data['maps']
names = data['labels']
brain = load_mni152_template()
mask = load_mni152_brain_mask()
masker = NiftiMasker(mask,)
masker.fit(brain)
map_data = masker.transform(maps)

pickes = """Occipital Fusiform Gyrus
Inferior Temporal Gyrus, temporooccipital part
Occipital Fusiform Gyrus
Lingual Gyrus
Middle Frontal Gyrus
Precuneous Cortex
Superior Frontal Gyrus
Superior Parietal Lobule
Inferior Frontal Gyrus, pars triangularis+Inferior Frontal Gyrus, pars opercularis
"""

plt.close('all')
fig,axes = plt.subplots(figsize = (35,25),
                        nrows = 7,
                        ncols = 7,
                        )
for ROI,name,ax in zip(map_data,names[1:],axes.flatten()):
    plotting.plot_roi(masker.inverse_transform(ROI),axes = ax,
                      title = name,figure = fig,draw_cross = False)
fig.savefig('../figures/candidates.jpg',
            bbox_inches = 'tight')
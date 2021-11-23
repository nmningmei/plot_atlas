#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Nov 23 18:10:45 2021

@author: ning
"""
import numpy as np
from nilearn import datasets,plotting,surface,input_data
from matplotlib import pyplot as plt
from matplotlib.patches import Patch

data = datasets.fetch_atlas_harvard_oxford("cort-maxprob-thr0-1mm")
fsaverage = datasets.fetch_surf_fsaverage()
mask = datasets.load_mni152_brain_mask()
masker = input_data.NiftiMasker(mask_img = mask).fit()
maps = data['maps']
names = np.array(data['labels'])
roi_names = """fusiform
inferiorparietal
inferiortemporal
lateraloccipital
lingual
middlefrontal
parahippocampal
pericalcarine
precuneus
superiorfrontal
superiorparietal
ventrolateralPFC""".split('\n')
name_map = {
        'fusiform':'Fusiform gyrus',
        'inferiorparietal':'Inferior parietal lobe',
        'inferiortemporal':'Inferior temporal lobe',
        'lateraloccipital':'Lateral occipital cortex',
        'lingual':'Lingual',
        'middlefrontal':'Middle frontal gyrus',
        'parahippocampal':'Parahippocampal gyrus',
        'pericalcarine':'Pericalcarine cortex',
        'precuneus':'Precuneus',
        'superiorfrontal':'Superior frontal gyrus',
        'superiorparietal':'Superior parietal gyrus',
        'ventrolateralPFC':'Inferior frontal gyrus',
        }
name_name_map = {
        'fusiform':['Temporal Fusiform Cortex, posterior division',
                    'Temporal Fusiform Cortex, anterior division',],
        'inferiorparietal':['Parietal Operculum Cortex',],
        'inferiortemporal':['Inferior Temporal Gyrus, posterior division',
                            'Inferior Temporal Gyrus, anterior division',],
        'lateraloccipital':['Lateral Occipital Cortex, superior division',
                            'Lateral Occipital Cortex, inferior division',],
        'lingual':['Lingual Gyrus'],
        'middlefrontal':['Middle Frontal Gyrus'],
        'parahippocampal':['Parahippocampal Gyrus, anterior division',
                           'Parahippocampal Gyrus, posterior division'],
        'pericalcarine':['Paracingulate Gyrus'],
        'precuneus':['Precuneous Cortex'],
        'superiorfrontal':['Superior Frontal Gyrus'],
        'superiorparietal':['Superior Parietal Lobule'],
        'ventrolateralPFC':['Inferior Frontal Gyrus, pars triangularis',
                            'Inferior Frontal Gyrus, pars opercularis'],
        }
radius = 1

# create a list of colors for the rois
# I prefer to control it this way so that I will know the correspondence
from matplotlib.colors import ListedColormap
# get the colors into a numpy array
color_list = plt.cm.Paired(np.arange(len(roi_names)))
# convert the numpy array of colors to a colormap object for plotting
cmap = ListedColormap(color_list)

map_data = masker.transform(maps)
new_map = np.zeros(map_data.shape)
reference = dict()
handles, labels = [],[]
for ii,((roi_native,roi_harvard),color,mask_name) in enumerate(zip(
                        name_name_map.items(),
                        color_list,
                        roi_names)):
    print(roi_native,mask_name)
    # for color checking
    reference[ii+1] = mask_name
    # create the legend handles and labels for plotting
    handles.append(Patch(facecolor = color))
    labels.append(name_map[mask_name])
    for item in roi_harvard:
        idx, = np.where(names == item)
        idx_brain = np.where(map_data[0] == idx[0])
        new_map[0,idx_brain] = ii + 1
temp = masker.inverse_transform(new_map)

fig,axes = plt.subplots(figsize = (2 * 2,2 * 2),
                        nrows = 2,
                        ncols = 2,
                        subplot_kw = {'projection':'3d'},
                        )
roi = surface.vol_to_surf(temp,fsaverage.pial_left,radius=radius)
ax = axes[0][0]
plotting.plot_surf_roi(fsaverage.infl_left,
                       roi,
                       bg_map = fsaverage.sulc_left,
                       view = 'lateral',
                       axes = ax,
                       figure = fig,
                       title = '',
                       cmap = cmap,
                       colorbar = False,)
ax = axes[0][1]
roi = surface.vol_to_surf(temp,fsaverage.pial_right,radius=radius)
plotting.plot_surf_roi(fsaverage.infl_right,
                       roi,
                       bg_map = fsaverage.sulc_right,
                       view = 'medial',
                       axes = ax,
                       figure = fig,
                       title = '',
                       cmap = cmap,
                       colorbar = False,)
ax = axes[1][0]
roi = surface.vol_to_surf(temp,fsaverage.pial_right,radius=radius)
plotting.plot_surf_roi(fsaverage.infl_right,
                       roi,
                       bg_map = fsaverage.sulc_right,
                       view = 'lateral',
                       axes = ax,
                       figure = fig,
                       title = '',
                       cmap = cmap,
                       colorbar = False,)
roi = surface.vol_to_surf(temp,fsaverage.pial_left,radius=radius)
ax = axes[1][1]
plotting.plot_surf_roi(fsaverage.infl_left,
                       roi,
                       bg_map = fsaverage.sulc_left,
                       view = 'medial',
                       axes = ax,
                       figure = fig,
                       title = '',
                       cmap = cmap,
                       colorbar = False,)
fig.legend(handles,labels,
           loc = 'center right',
           bbox_to_anchor = (1.5,0.5),)
















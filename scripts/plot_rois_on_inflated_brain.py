# -*- coding: utf-8 -*-
"""
Created on Sun Apr 26 12:42:26 2020

@author: ning
"""

import os
import numpy as np
from glob import glob
from nilearn import image,plotting
from matplotlib import pyplot as plt
from matplotlib.patches import Patch
from nibabel import load as load_mri
import seaborn as sns
sns.set_context('paper',font_scale=2)

# create a directory for the atlas
if not os.path.exists('../data'):
    os.mkdir('../data')
data_dir = os.path.join('../data','fmri_rois')
fig_dir = '../figures'
if not os.path.exists(fig_dir):
    os.mkdir(fig_dir)
surf_dir = '../data/freesurfer/surf'
the_brain = f'{data_dir}/MNI152_T1_2mm_brain.nii.gz'
the_mask = f'{data_dir}/MNI152_T1_2mm_brain_mask_dil.nii.gz'

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

#parsorbitalis
#parstriangularis
#parsopercularis

# get the standard ROIs
masks = glob(os.path.join(data_dir,'*standard*'))
# masks = [item for item in glob(os.path.join(data_dir,'ctx*nii.gz')) if\
#          ('standard' not in item) and ('fsl' not in item) and\
#              ('BOLD' not in item) and ('-pars' not in item)]
# combining left and right rois for plotting
# this is for validating if I have got the rois correctly

name_map = {
        'fusiform':'Fusiform gyrus',
        'inferiorparietal':'Inferior parietal lobe',
        'inferiortemporal':'Inferior temporal lobe',
        'lateraloccipital':'Lateral occipital cortex',
        'lingual':'Lingual',
        'middlefrontal':'Middle frontal gyrus',
        'parahippocampal':'Parahippocampal gyrus',
        'parahippocampal':'Parahippocampal gyrus',
        'pericalcarine':'Pericalcarine cortex',
        'precuneus':'Precuneus',
        'superiorfrontal':'Superior frontal gyrus',
        'superiorparietal':'Superior parietal gyrus',
        'ventrolateralPFC':'Inferior frontal gyrus',
        }

#plt.close('all')
handles, labels = [],[]
# create a list of colors for the rois
# I prefer to control it this way so that I will know the correspondence
from matplotlib.colors import ListedColormap
# get the colors into a numpy array
color_list = plt.cm.Paired(np.arange(len(roi_names)))
# convert the numpy array of colors to a colormap object for plotting
cmap = ListedColormap(color_list)

# for color checking
reference = dict()
lh_combined_roi = np.zeros((91,109,91))
rh_combined_roi = np.zeros((91,109,91))
for ii,(color,mask_name) in enumerate(zip(color_list,roi_names)):
    # pick the left and right hemisphere ROIs
    mask = np.sort([item for item in masks if (mask_name in item)])
    # rename the ROIs for plotting
    mask_name = name_map[mask_name]
    
    lh_roi = np.asanyarray(load_mri(mask[0]).dataobj)
    rh_roi = np.asanyarray(load_mri(mask[1]).dataobj)
    
    # add to the combined roi
    lh_combined_roi[lh_roi != 0] = ii + 1
    rh_combined_roi[rh_roi != 0] = ii + 1
    # for color checking
    reference[ii+1] = mask_name
    # create the legend handles and labels for plotting
    handles.append(Patch(facecolor = color))
    
    labels.append(mask_name)

# bound the mask
mask_boundary = np.asanyarray(load_mri(the_mask).dataobj)
lh_combined_roi[mask_boundary == 0] = 0
rh_combined_roi[mask_boundary == 0] = 0
#create a niftilImage from a numpy array
lh_combined_roi = image.new_img_like(mask[0],lh_combined_roi,)
rh_combined_roi = image.new_img_like(mask[0],rh_combined_roi,)

from nilearn import datasets,surface
radius = 6
fsaverage = datasets.fetch_surf_fsaverage()
fig,axes = plt.subplots(figsize = (2 * 3,2 * 3),
                        nrows = 2,
                        ncols = 2,
                        subplot_kw = {'projection':'3d'},
                        )
ax = axes.flatten()[0]
brain_map_in_surf = surface.vol_to_surf(lh_combined_roi,
                                        os.path.join(surf_dir,'lh.inflated'),
                                        radius = radius,
                                        mask_img = the_mask,)
plotting.plot_surf_stat_map(os.path.join(surf_dir,'lh.inflated'),
                            brain_map_in_surf,
                            bg_map = os.path.join(surf_dir,'lh.sulc'),
                            threshold = 1e-16,
                            hemi = 'left',
                            view = 'lateral',
                            axes = ax,
                            figure = fig,
                            title = '',
                            cmap = cmap,
                            colorbar = False,)








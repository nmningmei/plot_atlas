# -*- coding: utf-8 -*-
"""
Created on Sun Apr 26 12:42:26 2020

@author: ning
"""

import os
import numpy as np
from glob import glob
from nilearn import image,plotting
from nilearn.surface import vol_to_surf
from nilearn.datasets import fetch_surf_fsaverage
from matplotlib import pyplot as plt
from matplotlib.patches import Patch
from nibabel import load as load_mri
import seaborn as sns
sns.set_context('poster')

# create a directory for the atlas
if not os.path.exists('../data'):
    os.mkdir('../data')
data_dir = os.path.join('../data','fmri_rois')
fig_dir = '../figures'
if not os.path.exists(fig_dir):
    os.mkdir(fig_dir)
#dataset = datasets.fetch_atlas_craddock_2012('../data')
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

fsaverage = fetch_surf_fsaverage()

the_brain = f'{data_dir}/MNI152_T1_2mm_brain.nii.gz'
the_mask = f'{data_dir}/MNI152_T1_2mm_brain_mask_dil.nii.gz'
# get the standard ROIs
masks = np.sort(glob(os.path.join(data_dir,'*standard*')))
#masks = [item for item in glob(os.path.join(data_dir,'*.nii.gz')) if ('BOLD' not in item) and ('fsl' not in item) and ('standard' not in item) and ('MNI152' not in item)]

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

import matplotlib.colors as mcolors
colors = list(mcolors.CSS4_COLORS.keys())[:len(roi_names)]

# for color checking
stacked_left = []
stacked_right = []
reference = dict()
for ii,(color,mask_name) in enumerate(zip(color_list,roi_names)):
    # pick the left and right hemisphere ROIs
    mask = [item for item in masks if (mask_name in item)]
    # rename the ROIs for plotting
    mask_name = name_map[mask_name]
    # put them into the same numpy array
    temp = np.array([np.asarray(load_mri(f).dataobj) for f in mask])
    temp = temp.sum(0)
    # just in case of overlapping
    temp[temp > 0] = ii + 1
    # # left brain
    # left = vol_to_surf(image.new_img_like(mask[0],temp),fsaverage.pial_left,radius = 2,kind = 'line')
    # left[left > 0] = ii + 1
    # # right brain
    # right = vol_to_surf(image.new_img_like(mask[0],temp),fsaverage.pial_left,radius = 2,kind = 'line')
    # right[right > 0] = ii + 1
    # # appending to list
    # stacked_left.append(left)
    # stacked_right.append(right)
    if ii == 0: # initialize the combined mask numpy array
        combined_mask = temp
    else: # add the rest of the ROIs to those we already have
        combined_mask += temp
    # in case of overlapping, the overlapped regions belong to the last comer
    combined_mask[combined_mask > ii + 1] = ii + 1
    # for color checking
    reference[ii+1] = mask_name
    # create the legend handles and labels for plotting
    handles.append(Patch(facecolor = color))
    
    labels.append(mask_name)

# bound the mask
mask_boundary = np.asanyarray(load_mri(the_mask).dataobj)
combined_mask[mask_boundary == 0] = 0
# create a niftilImage from a numpy array
combined_mask = image.new_img_like(mask[0],
                                   combined_mask,)

parcellation = dict(labels = [item for item in reference.values()],
                    map_left=vol_to_surf(combined_mask,
                                         fsaverage.pial_left,
                                         radius = 2,
                                         kind = 'line',
                                         mask_img = the_mask).round(),
                    map_right=vol_to_surf(combined_mask,
                                          fsaverage.pial_right,
                                          radius = 2,
                                          kind = 'line',
                                          mask_img = the_mask).round(),
                    )

fig,ax = plt.subplots(figsize = (8*2,5*2),
                      nrows = 2,
                      ncols = 2,
                      subplot_kw={'projection':'3d'})
plotting.plot_surf_roi(fsaverage.infl_left,
                       parcellation['map_left'],
                       hemi = 'left',
                       bg_map = fsaverage.sulc_left,
                       cmap = cmap,
                       axes = ax[0][0],
                       figure = fig,
                       )
plotting.plot_surf_roi(fsaverage.infl_right,
                       parcellation['map_right'],
                       hemi = 'right',
                       bg_map = fsaverage.sulc_right,
                       cmap = cmap,
                       axes = ax[0][1],
                       figure = fig,
                       )
plotting.plot_surf_roi(fsaverage.infl_left,
                       parcellation['map_left'],
                       hemi = 'right',
                       bg_map = fsaverage.sulc_left,
                       cmap = cmap,
                       axes = ax[1][0],
                       figure = fig,
                       )
plotting.plot_surf_roi(fsaverage.infl_right,
                       parcellation['map_right'],
                       hemi = 'left',
                       bg_map = fsaverage.sulc_right,
                       cmap = cmap,
                       axes = ax[1][1],
                       figure = fig,
                       )
fig.legend(handles,
           labels,
           bbox_to_anchor=(0, .6),
           loc = "center right",
           borderaxespad = 1,
           frameon = False,
           )
asdf
fig.savefig(os.path.join(fig_dir,
                          'ROI_surf.jpg'),
            dpi = 300,
            bbox_inches = 'tight')










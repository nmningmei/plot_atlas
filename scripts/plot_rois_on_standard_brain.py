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

the_brain = f'{data_dir}/MNI152_T1_2mm_brain.nii.gz'
the_mask = f'{data_dir}/MNI152_T1_2mm_brain_mask_dil.nii.gz'
# get the standard ROIs
masks = glob(os.path.join(data_dir,'*standard*'))
#masks = [item for item in glob(os.path.join(data_dir,'*.nii.gz')) if ('BOLD' not in item) and ('fsl' not in item) and ('standard' not in item) and ('MNI152' not in item)]

# combining left and right rois for plotting
# this is for validating if I have got the rois correctly

plt.close('all')
for ii,mask_name in enumerate(roi_names):
    mask = [item for item in masks if (mask_name in item)]
    temp = np.array([load_mri(f).get_data() for f in mask])
    temp = temp.sum(0)
    temp[temp > 0] = 1
    combined_mask = image.new_img_like(mask[0],temp,)
    fig,ax = plt.subplots()
    x,y,z = plotting.find_xyz_cut_coords(combined_mask)
    if mask_name == 'superiorfrontal':
        x,y,z = 0,20,42
    plotting.plot_roi(roi_img = combined_mask,
                      bg_img=the_brain,
                      draw_cross=False,
                      axes=ax,
                      cut_coords=(x,y,z),
                      title = mask_name)
    fig.savefig(os.path.join(fig_dir,
                             f"{mask_name}.jpeg"))


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
for ii,(color,mask_name) in enumerate(zip(color_list,roi_names)):
    # pick the left and right hemisphere ROIs
    mask = [item for item in masks if (mask_name in item)]
    # put them into the same numpy array
    temp = np.array([load_mri(f).get_data() for f in mask])
    temp = temp.sum(0)
    # just in case of overlapping
    temp[temp > 0] = ii + 1
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
mask_boundary = load_mri(the_mask).get_data()
combined_mask[mask_boundary == 0] = 0
# create a niftilImage from a numpy array
combined_mask = image.new_img_like(mask[0],
                                   combined_mask,)

fig,ax = plt.subplots(figsize = (15,5))
# find the center of the combined ROI
x,y,z = plotting.find_xyz_cut_coords(combined_mask)
# plot_roi
plotting.plot_roi(roi_img = combined_mask,
                  bg_img = the_brain,
                  draw_cross = False,
#                  colorbar = True,
                  cmap = cmap,
                  black_bg = False,
                  axes = ax,
                  cut_coords = (x,y,z),#(0,-30,30),
                  )
ax.legend(handles,
           labels,
           bbox_to_anchor=(0, 1),
           loc = "center right",
           borderaxespad = 1,
           )
fig.savefig(os.path.join(fig_dir,'ROIs.jpeg'),
            dpi = 400,
            bbox_inches = 'tight',)

#left = [ '../data\\fmri_rois\\ctx-lh-parsopercularis.nii.gz',
# '../data\\fmri_rois\\ctx-lh-parsorbitalis.nii.gz',
# '../data\\fmri_rois\\ctx-lh-parstriangularis.nii.gz',]
#right = [ '../data\\fmri_rois\\ctx-rh-parsopercularis.nii.gz',
# '../data\\fmri_rois\\ctx-rh-parsorbitalis.nii.gz',
# '../data\\fmri_rois\\ctx-rh-parstriangularis.nii.gz',]
#
#for side,side_name in zip([left,right],['l','r']):
#    temp = np.array([load_mri(f).get_data() for f in side]).sum(0)
#    temp_nifti = image.new_img_like(side[0],temp,)
#    temp_nifti.to_filename(os.path.join(data_dir,f'ctx-{side_name}h-ventrolateralPFC.nii.gz'))













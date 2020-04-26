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
from nibabel import load as load_mri

# create a directory for the atlas
if not os.path.exists('../data'):
    os.mkdir('../data')
data_dir = os.path.join('../data','fmri_rois')

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

standard_brain = f'{data_dir}/MNI152_T1_2mm_brain.nii.gz'
masks = glob(os.path.join(data_dir,'*standard*'))

# combining left and right rois for plotting
#plt.close('all')
#for ii,mask_name in enumerate(roi_names):
#    mask = [item for item in masks if (mask_name in item)]
#    temp = np.array([load_mri(f).get_data() for f in mask])
#    temp = temp.sum(0)
#    temp[temp > 0] = 1
#    combined_mask = image.new_img_like(mask[0],temp,)
#    fig,ax = plt.subplots()
#    x,y,z = plotting.find_xyz_cut_coords(combined_mask)
#    if mask_name == 'superiorfrontal':
#        x,y,z = 0,20,42
#    plotting.plot_roi(roi_img = combined_mask,
#                      bg_img=standard_brain,
#                      draw_cross=False,
#                      axes=ax,cut_coords=(x,y,z),
#                      title = mask_name)


plt.close('all')
combined_rois = []
for ii,mask_name in enumerate(roi_names):
    mask = [item for item in masks if (mask_name in item)]
    temp = np.array([load_mri(f).get_data() for f in mask])
    temp = temp.sum(0)
    temp[temp > 0] = ii + 1
    combined_rois.append(temp)
combined_rois = np.sum(combined_rois,axis = 0)
combined_rois = image.new_img_like(mask[0],
                                   combined_rois,)
plotting.plot_roi(roi_img = combined_rois,
                  bg_img = standard_brain,
                  draw_cross = False,
                  colorbar = True,
                  cmap = 'Paired',
                  black_bg = False,
                  )




















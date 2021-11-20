# -*- coding: utf-8 -*-
"""
Created on Sun Apr 26 12:42:26 2020

@author: ning
"""

import os
import numpy as np
import pandas as pd
from glob import glob
from nilearn import image,plotting
from matplotlib import pyplot as plt
from matplotlib.patches import Patch
from nibabel import load as load_mri
from nilearn.surface import vol_to_surf
from nilearn.datasets import fetch_surf_fsaverage
from nilearn.plotting import plot_surf_stat_map
import seaborn as sns
sns.set_context('poster')

# create a directory for the atlas
if not os.path.exists('../data'):
    os.mkdir('../data')
data_dir = os.path.join('../data','fmri_rois')
fig_dir = '../figures'
if not os.path.exists(fig_dir):
    os.mkdir(fig_dir)

fsaverage = fetch_surf_fsaverage()
dimensions = 91,109,91
condition = 'unconscious'
con_dict  = {'unconscious': [0,5],
             'conscious':np.arange(12),
             'conscious to unconscious':[0,3,8]}

#dataset = datasets.fetch_atlas_craddock_2012('../data')
roi_names = np.array("""fusiform
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
ventrolateralPFC""".split('\n'))[con_dict[condition]]

the_brain = f'{data_dir}/MNI152_T1_2mm_brain.nii.gz'
the_mask = f'{data_dir}/MNI152_T1_2mm_brain_mask_dil.nii.gz'
# get the standard ROIs
masks = glob(os.path.join(data_dir,'*standard*'))

name_map = {
        'fusiform':'Fusiform gyrus',
        'inferiorparietal':'Inferior parietal lobe',
        'inferiortemporal':'Inferior temporal lobe',
        'lateraloccipital':'Lateral 1occipital cortex',
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

# create a list of colors for the rois
# I prefer to control it this way so that I will know the correspondence
from matplotlib.colors import ListedColormap
# get the colors into a numpy array
color_list = plt.cm.Paired(np.arange(len(roi_names)))
# convert the numpy array of colors to a colormap object for plotting
cmap = ListedColormap(color_list)

df = dict(surf_mesh                 = [],
          stat_mesh                 = [],
          bg_map                    = [],
          hemisphere                = [],
          title                     = [],
          sided_roi_combined        = [],
          )

# first it is the right hemisphere
combined_roi = np.zeros(dimensions)
for ii,roi_name in enumerate(roi_names):
    file_name = glob(os.path.join(data_dir,f'*rh*{roi_name}*standard*'))
    temp = np.asanyarray(load_mri(file_name[0]).dataobj)
    combined_roi[temp > 0] = 1
combined_roi = image.new_img_like(masks[0], combined_roi)
df['surf_mesh'              ].append(fsaverage.infl_right)
df['stat_mesh'              ].append(fsaverage.pial_right)
df['bg_map'                 ].append(fsaverage.sulc_right)
df['hemisphere'             ].append('right')
df['title'                  ].append('')
df['sided_roi_combined'     ].append(combined_roi)

# and then it is the left hemishpere
combined_roi = np.zeros(dimensions)
for ii,roi_name in enumerate(roi_names):
    file_name = glob(os.path.join(data_dir,f'*lh*{roi_name}*standard*'))
    temp = np.asanyarray(load_mri(file_name[0]).dataobj)
    combined_roi[temp > 0] = 1
combined_roi = image.new_img_like(masks[0], combined_roi)
df['surf_mesh'              ].append(fsaverage.infl_left)
df['stat_mesh'              ].append(fsaverage.pial_left)
df['bg_map'                 ].append(fsaverage.sulc_left)
df['hemisphere'             ].append('left')
df['title'                  ].append('')
df['sided_roi_combined'     ].append(combined_roi)

# back to the right

# and back to the left

df_for_plot = pd.DataFrame(df)

fig,axes = plt.subplots(figsize = (15,6),
                        ncols = 2,
                        subplot_kw  = {'projection':'3d'},
                        )
for (ii, row),ax in zip(df_for_plot.iterrows(),axes.flatten()):
    stat_map = vol_to_surf(row['sided_roi_combined'],
                           row['surf_mesh'],
                           radius = 2,
                           mask_img = the_mask,
                           )
    stat_map[stat_map > 1e-1] = 1
    stat_map[np.isnan(stat_map)] = 0
    plot_surf_stat_map(surf_mesh = row['surf_mesh'],
                       stat_map = stat_map,
                       bg_map = row['bg_map'],
                       hemi = row['hemisphere'],
                       threshold = 1e-1,
                       colorbar = False,
                       cmap = 'Blues',
                       axes = ax,
                       figure = fig,
                       )



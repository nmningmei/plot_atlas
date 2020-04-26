# -*- coding: utf-8 -*-
"""
Created on Sun Apr 26 12:42:26 2020

@author: ning
"""

import os
from glob import glob
from nilearn import datasets,plotting

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
parsorbitalis
parstriangularis
parsopercularis"""

standard_brain = f'{data_dir}/MNI152_T1_2mm_brain.nii.gz'
masks = glob(os.path.join(data_dir,'*standard*'))



























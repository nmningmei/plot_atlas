#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jan 14 11:25:05 2023

@author: nmei
"""

from nilearn.maskers import NiftiMasker
from nilearn.datasets import fetch_surf_fsaverage
from nilearn.surface import vol_to_surf
from nilearn.plotting import plot_surf,plot_surf_contours
from matplotlib import pyplot as plt


def plot_surf_stats_with_contours(image_average,
                                  image_pval,
                                  hemi      = 'left',
                                  view_side = 'left',
                                  title     = '',
                                  vmin      = 0.48,
                                  vmax      = 0.52,
                                  threshold = 0.5,
                                  colorbar  = True,
                                  cbar_vmin = 0.5,
                                  cbar_vmax = None,
                                  fig       = None,
                                  ax        = None,
                                  cmap      = plt.cm.Reds,
                                  ):
    
    if view_side == 'left':
        surf_mesh   = fsaverage.infl_left
        stat_mesh   = fsaverage.pial_left
        bg_map      = fsaverage.sulc_left
    elif view_side == 'right':
        surf_mesh   = fsaverage.infl_right
        stat_mesh   = fsaverage.pial_right
        bg_map      = fsaverage.sulc_right
    if cbar_vmax == None:
        cbar_vmax = vmax
    
    average         = vol_to_surf(image_average,stat_mesh,0.0)
    pval_to_plot    = vol_to_surf(image_pval,stat_mesh,0.0)
    
    if fig == None:
        fig,ax      = plt.subplots(figsize = (12,8),
                              subplot_kw  = {'projection':'3d'})
    plot_surf(         surf_mesh,
                       average.flatten(),
                       bg_map           = bg_map,
                       threshold        = threshold,
                       hemi             = hemi,
                       axes             = ax,
                       figure           = fig,
                       title            = title,
                       cmap             = cmap,
                       alpha            = 1.,
                       bg_on_data       = True,
                       cbar_tick_format = '%.2g',
                       colorbar         = colorbar,
                       vmin             = vmin,
                       vmax             = vmax,
                       cbar_vmin        = cbar_vmin,
                       cbar_vmax        = cbar_vmax,
                       symmetric_cbar   = 'auto',
                       )
    try: # this works well when the cluster is big enough for stretching from standard space to freesurfer space
        plot_surf_contours(surf_mesh,
                           np.array(pval_to_plot.flatten() == 1,dtype = np.int32),
                           hemi         = hemi,
                           axes         = ax,
                           figure       = fig,
                           title        = title,
                           levels       = [1],
                           coloars      = ['red'],
                           cmap         = cmap,
                           )
    except Exception as err:
        print(err)

if __name__ == "__main__":
    # create a standard brain MNI data loader, assuming all the data are in standard space
    standard_mask   = '../data/fmri_rois/MNI152_T1_2mm_brain_mask_dil.nii.gz'
    masker          = NiftiMasker(mask_img = standard_mask,).fit()
    # load the average freesurfer brain atlas
    fsaverage       = fetch_surf_fsaverage('fsaverage5')
    # load the ROC AUC scores average across subjects
    average_masked  = masker.transform_single_imgs('../data/average_scores.nii.gz')[0]
    # load the corrected p values
    pval            = masker.transform_single_imgs('../data/randomise_tfce_corrp_tstat1.nii.gz')[0]
    # load the t values
    tval            = masker.transform_single_imgs('../data/randomise_tstat1.nii.gz')[0]
    # convert p values into log space for better visualization
    pval            = np.abs(-np.log(1 - pval))
    # threshold by alpha = 0.05
    pval_mask       = pval > -np.log(0.05)
    # nilearn works better with int32
    pval_mask       = pval_mask.astype(np.int32)
    # mask by the stats map
    pval_mask = masker.inverse_transform(pval_mask)
    tval_mask = masker.inverse_transform(tval >= 0)
    try: # this works well when there is a cluster
        stats_masker        = NiftiMasker(pval_mask).fit()
        temp                = stats_masker.transform(masker.inverse_transform(images_across_subjects))
    except: # catch when there is no p value clusters
        stats_masker        = NiftiMasker(tval_mask).fit()
        temp                = stats_masker.transform(masker.inverse_transform(images_across_subjects))
    # convert back to nii.gz
    average_masked = stats_masker.inverse_transform(temp)
    # figure title
    title = 'customized title'
    # plot
    fig,axes = plt.subplots(figsize = (15,8),
                            ncols   = 2,
                            nrows   = 2,
                            subplot_kw  = {'projection':'3d'},
                            )
    for ax,hemi,side in zip(axes.flatten(),
                            ['left','right','left','right'],
                            ['left','right','right','left'],
                            ):
        plot_surf_stats_with_contours(average_masked,
                                      pval_mask,
                                      hemi      = hemi,
                                      view_side = side,
                                      title     = title if hemi == 'left' else None,
                                      vmin      = 0.48,
                                      vmax      = 0.52,
                                      threshold = 0.5,
                                      colorbar  = True,
                                      cbar_vmin = 0.5,
                                      cbar_vmax = None,
                                      fig       = fig,
                                      ax        = ax,
                                      cmap      = plt.cm.Reds,
                                      )
    fig.savefig("../figures/scores_stat_map_in_surf.jpg",
                dpi = 300,
                bbox_inches = 'tight',
               )

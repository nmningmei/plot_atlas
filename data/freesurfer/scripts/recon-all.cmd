

#---------------------------------
# New invocation of recon-all Mon Jul 15 12:12:23 CEST 2019 

 mri_convert /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/20190409_174122t1mpragesagp21isoMGHs023a1001.nii.gz /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/mri/orig/001.mgz 

#--------------------------------------------
#@# MotionCor Mon Jul 15 12:12:36 CEST 2019

 cp /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/mri/orig/001.mgz /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/mri/rawavg.mgz 


 mri_convert /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/mri/rawavg.mgz /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/mri/orig.mgz --conform 


 mri_add_xform_to_header -c /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/mri/transforms/talairach.xfm /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/mri/orig.mgz /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/mri/orig.mgz 

#--------------------------------------------
#@# Talairach Mon Jul 15 12:12:47 CEST 2019

 mri_nu_correct.mni --no-rescale --i orig.mgz --o orig_nu.mgz --n 1 --proto-iters 1000 --distance 50 


 talairach_avi --i orig_nu.mgz --xfm transforms/talairach.auto.xfm 

talairach_avi log file is transforms/talairach_avi.log...

 cp transforms/talairach.auto.xfm transforms/talairach.xfm 

#--------------------------------------------
#@# Talairach Failure Detection Mon Jul 15 12:15:23 CEST 2019

 talairach_afd -T 0.005 -xfm transforms/talairach.xfm 


 awk -f /opt/freesurfer-6.0.0/freesurfer/bin/extract_talairach_avi_QA.awk /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/mri/transforms/talairach_avi.log 


 tal_QC_AZS /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/mri/transforms/talairach_avi.log 

#--------------------------------------------
#@# Nu Intensity Correction Mon Jul 15 12:15:24 CEST 2019

 mri_nu_correct.mni --i orig.mgz --o nu.mgz --uchar transforms/talairach.xfm --n 2 


 mri_add_xform_to_header -c /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/mri/transforms/talairach.xfm nu.mgz nu.mgz 

#--------------------------------------------
#@# Intensity Normalization Mon Jul 15 12:17:49 CEST 2019

 mri_normalize -g 1 -mprage nu.mgz T1.mgz 

#--------------------------------------------
#@# Skull Stripping Mon Jul 15 12:19:57 CEST 2019

 mri_em_register -rusage /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/touch/rusage.mri_em_register.skull.dat -skull nu.mgz /opt/freesurfer-6.0.0/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta 


 mri_watershed -rusage /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/touch/rusage.mri_watershed.dat -T1 -brain_atlas /opt/freesurfer-6.0.0/freesurfer/average/RB_all_withskull_2016-05-10.vc700.gca transforms/talairach_with_skull.lta T1.mgz brainmask.auto.mgz 


 cp brainmask.auto.mgz brainmask.mgz 

#-------------------------------------
#@# EM Registration Mon Jul 15 12:35:50 CEST 2019

 mri_em_register -rusage /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/touch/rusage.mri_em_register.dat -uns 3 -mask brainmask.mgz nu.mgz /opt/freesurfer-6.0.0/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta 

#--------------------------------------
#@# CA Normalize Mon Jul 15 12:53:27 CEST 2019

 mri_ca_normalize -c ctrl_pts.mgz -mask brainmask.mgz nu.mgz /opt/freesurfer-6.0.0/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.lta norm.mgz 

#--------------------------------------
#@# CA Reg Mon Jul 15 12:54:52 CEST 2019

 mri_ca_register -rusage /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/touch/rusage.mri_ca_register.dat -nobigventricles -T transforms/talairach.lta -align-after -mask brainmask.mgz norm.mgz /opt/freesurfer-6.0.0/freesurfer/average/RB_all_2016-05-10.vc700.gca transforms/talairach.m3z 

#--------------------------------------
#@# SubCort Seg Mon Jul 15 15:14:09 CEST 2019

 mri_ca_label -relabel_unlikely 9 .3 -prior 0.5 -align norm.mgz transforms/talairach.m3z /opt/freesurfer-6.0.0/freesurfer/average/RB_all_2016-05-10.vc700.gca aseg.auto_noCCseg.mgz 


 mri_cc -aseg aseg.auto_noCCseg.mgz -o aseg.auto.mgz -lta /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/mri/transforms/cc_up.lta sub-01 

#--------------------------------------
#@# Merge ASeg Mon Jul 15 16:07:46 CEST 2019

 cp aseg.auto.mgz aseg.presurf.mgz 

#--------------------------------------------
#@# Intensity Normalization2 Mon Jul 15 16:07:46 CEST 2019

 mri_normalize -mprage -aseg aseg.presurf.mgz -mask brainmask.mgz norm.mgz brain.mgz 

#--------------------------------------------
#@# Mask BFS Mon Jul 15 16:12:12 CEST 2019

 mri_mask -T 5 brain.mgz brainmask.mgz brain.finalsurfs.mgz 

#--------------------------------------------
#@# WM Segmentation Mon Jul 15 16:12:14 CEST 2019

 mri_segment -mprage brain.mgz wm.seg.mgz 


 mri_edit_wm_with_aseg -keep-in wm.seg.mgz brain.mgz aseg.presurf.mgz wm.asegedit.mgz 


 mri_pretess wm.asegedit.mgz wm norm.mgz wm.mgz 

#--------------------------------------------
#@# Fill Mon Jul 15 16:14:56 CEST 2019

 mri_fill -a ../scripts/ponscc.cut.log -xform transforms/talairach.lta -segmentation aseg.auto_noCCseg.mgz wm.mgz filled.mgz 

#--------------------------------------------
#@# Tessellate lh Mon Jul 15 16:15:53 CEST 2019

 mri_pretess ../mri/filled.mgz 255 ../mri/norm.mgz ../mri/filled-pretess255.mgz 


 mri_tessellate ../mri/filled-pretess255.mgz 255 ../surf/lh.orig.nofix 


 rm -f ../mri/filled-pretess255.mgz 


 mris_extract_main_component ../surf/lh.orig.nofix ../surf/lh.orig.nofix 

#--------------------------------------------
#@# Tessellate rh Mon Jul 15 16:16:00 CEST 2019

 mri_pretess ../mri/filled.mgz 127 ../mri/norm.mgz ../mri/filled-pretess127.mgz 


 mri_tessellate ../mri/filled-pretess127.mgz 127 ../surf/rh.orig.nofix 


 rm -f ../mri/filled-pretess127.mgz 


 mris_extract_main_component ../surf/rh.orig.nofix ../surf/rh.orig.nofix 

#--------------------------------------------
#@# Smooth1 lh Mon Jul 15 16:16:06 CEST 2019

 mris_smooth -nw -seed 1234 ../surf/lh.orig.nofix ../surf/lh.smoothwm.nofix 

#--------------------------------------------
#@# Smooth1 rh Mon Jul 15 16:16:12 CEST 2019

 mris_smooth -nw -seed 1234 ../surf/rh.orig.nofix ../surf/rh.smoothwm.nofix 

#--------------------------------------------
#@# Inflation1 lh Mon Jul 15 16:16:17 CEST 2019

 mris_inflate -no-save-sulc ../surf/lh.smoothwm.nofix ../surf/lh.inflated.nofix 

#--------------------------------------------
#@# Inflation1 rh Mon Jul 15 16:16:51 CEST 2019

 mris_inflate -no-save-sulc ../surf/rh.smoothwm.nofix ../surf/rh.inflated.nofix 

#--------------------------------------------
#@# QSphere lh Mon Jul 15 16:17:30 CEST 2019

 mris_sphere -q -seed 1234 ../surf/lh.inflated.nofix ../surf/lh.qsphere.nofix 

#--------------------------------------------
#@# QSphere rh Mon Jul 15 16:22:57 CEST 2019

 mris_sphere -q -seed 1234 ../surf/rh.inflated.nofix ../surf/rh.qsphere.nofix 

#--------------------------------------------
#@# Fix Topology Copy lh Mon Jul 15 16:28:11 CEST 2019

 cp ../surf/lh.orig.nofix ../surf/lh.orig 


 cp ../surf/lh.inflated.nofix ../surf/lh.inflated 

#--------------------------------------------
#@# Fix Topology Copy rh Mon Jul 15 16:28:11 CEST 2019

 cp ../surf/rh.orig.nofix ../surf/rh.orig 


 cp ../surf/rh.inflated.nofix ../surf/rh.inflated 

#@# Fix Topology lh Mon Jul 15 16:28:11 CEST 2019

 mris_fix_topology -rusage /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/touch/rusage.mris_fix_topology.lh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-01 lh 

#@# Fix Topology rh Mon Jul 15 16:42:41 CEST 2019

 mris_fix_topology -rusage /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/touch/rusage.mris_fix_topology.rh.dat -mgz -sphere qsphere.nofix -ga -seed 1234 sub-01 rh 


 mris_euler_number ../surf/lh.orig 


 mris_euler_number ../surf/rh.orig 


 mris_remove_intersection ../surf/lh.orig ../surf/lh.orig 


 rm ../surf/lh.inflated 


 mris_remove_intersection ../surf/rh.orig ../surf/rh.orig 


 rm ../surf/rh.inflated 

#--------------------------------------------
#@# Make White Surf lh Mon Jul 15 16:48:48 CEST 2019

 mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs sub-01 lh 

#--------------------------------------------
#@# Make White Surf rh Mon Jul 15 16:52:59 CEST 2019

 mris_make_surfaces -aseg ../mri/aseg.presurf -white white.preaparc -noaparc -whiteonly -mgz -T1 brain.finalsurfs sub-01 rh 

#--------------------------------------------
#@# Smooth2 lh Mon Jul 15 16:57:13 CEST 2019

 mris_smooth -n 3 -nw -seed 1234 ../surf/lh.white.preaparc ../surf/lh.smoothwm 

#--------------------------------------------
#@# Smooth2 rh Mon Jul 15 16:57:17 CEST 2019

 mris_smooth -n 3 -nw -seed 1234 ../surf/rh.white.preaparc ../surf/rh.smoothwm 

#--------------------------------------------
#@# Inflation2 lh Mon Jul 15 16:57:22 CEST 2019

 mris_inflate -rusage /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/touch/rusage.mris_inflate.lh.dat ../surf/lh.smoothwm ../surf/lh.inflated 

#--------------------------------------------
#@# Inflation2 rh Mon Jul 15 16:57:49 CEST 2019

 mris_inflate -rusage /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/touch/rusage.mris_inflate.rh.dat ../surf/rh.smoothwm ../surf/rh.inflated 

#--------------------------------------------
#@# Curv .H and .K lh Mon Jul 15 16:58:23 CEST 2019

 mris_curvature -w lh.white.preaparc 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 lh.inflated 

#--------------------------------------------
#@# Curv .H and .K rh Mon Jul 15 16:59:26 CEST 2019

 mris_curvature -w rh.white.preaparc 


 mris_curvature -thresh .999 -n -a 5 -w -distances 10 10 rh.inflated 


#-----------------------------------------
#@# Curvature Stats lh Mon Jul 15 17:00:32 CEST 2019

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/lh.curv.stats -F smoothwm sub-01 lh curv sulc 


#-----------------------------------------
#@# Curvature Stats rh Mon Jul 15 17:00:35 CEST 2019

 mris_curvature_stats -m --writeCurvatureFiles -G -o ../stats/rh.curv.stats -F smoothwm sub-01 rh curv sulc 

#--------------------------------------------
#@# Sphere lh Mon Jul 15 17:00:39 CEST 2019

 mris_sphere -rusage /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/touch/rusage.mris_sphere.lh.dat -seed 1234 ../surf/lh.inflated ../surf/lh.sphere 

#--------------------------------------------
#@# Sphere rh Mon Jul 15 17:37:42 CEST 2019

 mris_sphere -rusage /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/touch/rusage.mris_sphere.rh.dat -seed 1234 ../surf/rh.inflated ../surf/rh.sphere 

#--------------------------------------------
#@# Surf Reg lh Mon Jul 15 18:29:28 CEST 2019

 mris_register -curv -rusage /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/touch/rusage.mris_register.lh.dat ../surf/lh.sphere /opt/freesurfer-6.0.0/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/lh.sphere.reg 

#--------------------------------------------
#@# Surf Reg rh Mon Jul 15 19:20:04 CEST 2019

 mris_register -curv -rusage /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/sub-01/touch/rusage.mris_register.rh.dat ../surf/rh.sphere /opt/freesurfer-6.0.0/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif ../surf/rh.sphere.reg 

#--------------------------------------------
#@# Jacobian white lh Mon Jul 15 20:09:57 CEST 2019

 mris_jacobian ../surf/lh.white.preaparc ../surf/lh.sphere.reg ../surf/lh.jacobian_white 

#--------------------------------------------
#@# Jacobian white rh Mon Jul 15 20:09:59 CEST 2019

 mris_jacobian ../surf/rh.white.preaparc ../surf/rh.sphere.reg ../surf/rh.jacobian_white 

#--------------------------------------------
#@# AvgCurv lh Mon Jul 15 20:10:00 CEST 2019

 mrisp_paint -a 5 /opt/freesurfer-6.0.0/freesurfer/average/lh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/lh.sphere.reg ../surf/lh.avg_curv 

#--------------------------------------------
#@# AvgCurv rh Mon Jul 15 20:10:01 CEST 2019

 mrisp_paint -a 5 /opt/freesurfer-6.0.0/freesurfer/average/rh.folding.atlas.acfb40.noaparc.i12.2016-08-02.tif#6 ../surf/rh.sphere.reg ../surf/rh.avg_curv 

#-----------------------------------------
#@# Cortical Parc lh Mon Jul 15 20:10:03 CEST 2019

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 lh ../surf/lh.sphere.reg /opt/freesurfer-6.0.0/freesurfer/average/lh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.annot 

#-----------------------------------------
#@# Cortical Parc rh Mon Jul 15 20:10:14 CEST 2019

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 rh ../surf/rh.sphere.reg /opt/freesurfer-6.0.0/freesurfer/average/rh.DKaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.annot 

#--------------------------------------------
#@# Make Pial Surf lh Mon Jul 15 20:10:26 CEST 2019

 mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-01 lh 

#--------------------------------------------
#@# Make Pial Surf rh Mon Jul 15 20:21:58 CEST 2019

 mris_make_surfaces -orig_white white.preaparc -orig_pial white.preaparc -aseg ../mri/aseg.presurf -mgz -T1 brain.finalsurfs sub-01 rh 

#--------------------------------------------
#@# Surf Volume lh Mon Jul 15 20:33:24 CEST 2019
#--------------------------------------------
#@# Surf Volume rh Mon Jul 15 20:33:27 CEST 2019
#--------------------------------------------
#@# Cortical ribbon mask Mon Jul 15 20:33:30 CEST 2019

 mris_volmask --aseg_name aseg.presurf --label_left_white 2 --label_left_ribbon 3 --label_right_white 41 --label_right_ribbon 42 --save_ribbon sub-01 

#-----------------------------------------
#@# Parcellation Stats lh Mon Jul 15 20:40:08 CEST 2019

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-01 lh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.pial.stats -b -a ../label/lh.aparc.annot -c ../label/aparc.annot.ctab sub-01 lh pial 

#-----------------------------------------
#@# Parcellation Stats rh Mon Jul 15 20:40:59 CEST 2019

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-01 rh white 


 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.pial.stats -b -a ../label/rh.aparc.annot -c ../label/aparc.annot.ctab sub-01 rh pial 

#-----------------------------------------
#@# Cortical Parc 2 lh Mon Jul 15 20:41:54 CEST 2019

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 lh ../surf/lh.sphere.reg /opt/freesurfer-6.0.0/freesurfer/average/lh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.a2009s.annot 

#-----------------------------------------
#@# Cortical Parc 2 rh Mon Jul 15 20:42:09 CEST 2019

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 rh ../surf/rh.sphere.reg /opt/freesurfer-6.0.0/freesurfer/average/rh.CDaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.a2009s.annot 

#-----------------------------------------
#@# Parcellation Stats 2 lh Mon Jul 15 20:42:24 CEST 2019

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.a2009s.stats -b -a ../label/lh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-01 lh white 

#-----------------------------------------
#@# Parcellation Stats 2 rh Mon Jul 15 20:42:54 CEST 2019

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.a2009s.stats -b -a ../label/rh.aparc.a2009s.annot -c ../label/aparc.annot.a2009s.ctab sub-01 rh white 

#-----------------------------------------
#@# Cortical Parc 3 lh Mon Jul 15 20:43:20 CEST 2019

 mris_ca_label -l ../label/lh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 lh ../surf/lh.sphere.reg /opt/freesurfer-6.0.0/freesurfer/average/lh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/lh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Cortical Parc 3 rh Mon Jul 15 20:43:31 CEST 2019

 mris_ca_label -l ../label/rh.cortex.label -aseg ../mri/aseg.presurf.mgz -seed 1234 sub-01 rh ../surf/rh.sphere.reg /opt/freesurfer-6.0.0/freesurfer/average/rh.DKTaparc.atlas.acfb40.noaparc.i12.2016-08-02.gcs ../label/rh.aparc.DKTatlas.annot 

#-----------------------------------------
#@# Parcellation Stats 3 lh Mon Jul 15 20:43:42 CEST 2019

 mris_anatomical_stats -th3 -mgz -cortex ../label/lh.cortex.label -f ../stats/lh.aparc.DKTatlas.stats -b -a ../label/lh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-01 lh white 

#-----------------------------------------
#@# Parcellation Stats 3 rh Mon Jul 15 20:44:15 CEST 2019

 mris_anatomical_stats -th3 -mgz -cortex ../label/rh.cortex.label -f ../stats/rh.aparc.DKTatlas.stats -b -a ../label/rh.aparc.DKTatlas.annot -c ../label/aparc.annot.DKTatlas.ctab sub-01 rh white 

#-----------------------------------------
#@# WM/GM Contrast lh Mon Jul 15 20:44:40 CEST 2019

 pctsurfcon --s sub-01 --lh-only 

#-----------------------------------------
#@# WM/GM Contrast rh Mon Jul 15 20:44:45 CEST 2019

 pctsurfcon --s sub-01 --rh-only 

#-----------------------------------------
#@# Relabel Hypointensities Mon Jul 15 20:44:51 CEST 2019

 mri_relabel_hypointensities aseg.presurf.mgz ../surf aseg.presurf.hypos.mgz 

#-----------------------------------------
#@# AParc-to-ASeg aparc Mon Jul 15 20:45:07 CEST 2019

 mri_aparc2aseg --s sub-01 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer-6.0.0/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt 

#-----------------------------------------
#@# AParc-to-ASeg a2009s Mon Jul 15 20:48:55 CEST 2019

 mri_aparc2aseg --s sub-01 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer-6.0.0/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --a2009s 

#-----------------------------------------
#@# AParc-to-ASeg DKTatlas Mon Jul 15 20:52:38 CEST 2019

 mri_aparc2aseg --s sub-01 --volmask --aseg aseg.presurf.hypos --relabel mri/norm.mgz mri/transforms/talairach.m3z /opt/freesurfer-6.0.0/freesurfer/average/RB_all_2016-05-10.vc700.gca mri/aseg.auto_noCCseg.label_intensities.txt --annot aparc.DKTatlas --o mri/aparc.DKTatlas+aseg.mgz 

#-----------------------------------------
#@# APas-to-ASeg Mon Jul 15 20:56:23 CEST 2019

 apas2aseg --i aparc+aseg.mgz --o aseg.mgz 

#--------------------------------------------
#@# ASeg Stats Mon Jul 15 20:56:28 CEST 2019

 mri_segstats --seg mri/aseg.mgz --sum stats/aseg.stats --pv mri/norm.mgz --empty --brainmask mri/brainmask.mgz --brain-vol-from-seg --excludeid 0 --excl-ctxgmwm --supratent --subcortgray --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --etiv --surf-wm-vol --surf-ctx-vol --totalgray --euler --ctab /opt/freesurfer-6.0.0/freesurfer/ASegStatsLUT.txt --subject sub-01 

#-----------------------------------------
#@# WMParc Mon Jul 15 20:58:14 CEST 2019

 mri_aparc2aseg --s sub-01 --labelwm --hypo-as-wm --rip-unknown --volmask --o mri/wmparc.mgz --ctxseg aparc+aseg.mgz 


 mri_segstats --seg mri/wmparc.mgz --sum stats/wmparc.stats --pv mri/norm.mgz --excludeid 0 --brainmask mri/brainmask.mgz --in mri/norm.mgz --in-intensity-name norm --in-intensity-units MR --subject sub-01 --surf-wm-vol --ctab /opt/freesurfer-6.0.0/freesurfer/WMParcStatsLUT.txt --etiv 

INFO: fsaverage subject does not exist in SUBJECTS_DIR
INFO: Creating symlink to fsaverage subject...

 cd /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat; ln -s /opt/freesurfer-6.0.0/freesurfer/subjects/fsaverage; cd - 

#--------------------------------------------
#@# BA_exvivo Labels lh Mon Jul 15 21:08:00 CEST 2019

 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA1_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA2_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA3a_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA3a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA3b_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA3b_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA4a_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA4a_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA4p_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA4p_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA6_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA6_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA44_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA44_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA45_exvivo.label --trgsubject sub-01 --trglabel ./lh.BA45_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.V1_exvivo.label --trgsubject sub-01 --trglabel ./lh.V1_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.V2_exvivo.label --trgsubject sub-01 --trglabel ./lh.V2_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.MT_exvivo.label --trgsubject sub-01 --trglabel ./lh.MT_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.entorhinal_exvivo.label --trgsubject sub-01 --trglabel ./lh.entorhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.perirhinal_exvivo.label --trgsubject sub-01 --trglabel ./lh.perirhinal_exvivo.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA3a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA3a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA3b_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA3b_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA4a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA4a_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA4p_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA4p_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA6_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA6_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA44_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA44_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.BA45_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.BA45_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.V1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.V1_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.V2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.V2_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.MT_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.MT_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.entorhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.entorhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/lh.perirhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./lh.perirhinal_exvivo.thresh.label --hemi lh --regmethod surface 


 mris_label2annot --s sub-01 --hemi lh --ctab /opt/freesurfer-6.0.0/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.label --l lh.BA2_exvivo.label --l lh.BA3a_exvivo.label --l lh.BA3b_exvivo.label --l lh.BA4a_exvivo.label --l lh.BA4p_exvivo.label --l lh.BA6_exvivo.label --l lh.BA44_exvivo.label --l lh.BA45_exvivo.label --l lh.V1_exvivo.label --l lh.V2_exvivo.label --l lh.MT_exvivo.label --l lh.entorhinal_exvivo.label --l lh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-01 --hemi lh --ctab /opt/freesurfer-6.0.0/freesurfer/average/colortable_BA.txt --l lh.BA1_exvivo.thresh.label --l lh.BA2_exvivo.thresh.label --l lh.BA3a_exvivo.thresh.label --l lh.BA3b_exvivo.thresh.label --l lh.BA4a_exvivo.thresh.label --l lh.BA4p_exvivo.thresh.label --l lh.BA6_exvivo.thresh.label --l lh.BA44_exvivo.thresh.label --l lh.BA45_exvivo.thresh.label --l lh.V1_exvivo.thresh.label --l lh.V2_exvivo.thresh.label --l lh.MT_exvivo.thresh.label --l lh.entorhinal_exvivo.thresh.label --l lh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.stats -b -a ./lh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-01 lh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/lh.BA_exvivo.thresh.stats -b -a ./lh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-01 lh white 

#--------------------------------------------
#@# BA_exvivo Labels rh Mon Jul 15 21:11:52 CEST 2019

 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA1_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA2_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA3a_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA3a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA3b_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA3b_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA4a_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA4a_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA4p_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA4p_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA6_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA6_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA44_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA44_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA45_exvivo.label --trgsubject sub-01 --trglabel ./rh.BA45_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.V1_exvivo.label --trgsubject sub-01 --trglabel ./rh.V1_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.V2_exvivo.label --trgsubject sub-01 --trglabel ./rh.V2_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.MT_exvivo.label --trgsubject sub-01 --trglabel ./rh.MT_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.entorhinal_exvivo.label --trgsubject sub-01 --trglabel ./rh.entorhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.perirhinal_exvivo.label --trgsubject sub-01 --trglabel ./rh.perirhinal_exvivo.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA3a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA3a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA3b_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA3b_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA4a_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA4a_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA4p_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA4p_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA6_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA6_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA44_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA44_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.BA45_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.BA45_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.V1_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.V1_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.V2_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.V2_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.MT_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.MT_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.entorhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.entorhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mri_label2label --srcsubject fsaverage --srclabel /bcbl/home/public/Consciousness/uncon_feat/data/MRI/sub-01/anat/fsaverage/label/rh.perirhinal_exvivo.thresh.label --trgsubject sub-01 --trglabel ./rh.perirhinal_exvivo.thresh.label --hemi rh --regmethod surface 


 mris_label2annot --s sub-01 --hemi rh --ctab /opt/freesurfer-6.0.0/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.label --l rh.BA2_exvivo.label --l rh.BA3a_exvivo.label --l rh.BA3b_exvivo.label --l rh.BA4a_exvivo.label --l rh.BA4p_exvivo.label --l rh.BA6_exvivo.label --l rh.BA44_exvivo.label --l rh.BA45_exvivo.label --l rh.V1_exvivo.label --l rh.V2_exvivo.label --l rh.MT_exvivo.label --l rh.entorhinal_exvivo.label --l rh.perirhinal_exvivo.label --a BA_exvivo --maxstatwinner --noverbose 


 mris_label2annot --s sub-01 --hemi rh --ctab /opt/freesurfer-6.0.0/freesurfer/average/colortable_BA.txt --l rh.BA1_exvivo.thresh.label --l rh.BA2_exvivo.thresh.label --l rh.BA3a_exvivo.thresh.label --l rh.BA3b_exvivo.thresh.label --l rh.BA4a_exvivo.thresh.label --l rh.BA4p_exvivo.thresh.label --l rh.BA6_exvivo.thresh.label --l rh.BA44_exvivo.thresh.label --l rh.BA45_exvivo.thresh.label --l rh.V1_exvivo.thresh.label --l rh.V2_exvivo.thresh.label --l rh.MT_exvivo.thresh.label --l rh.entorhinal_exvivo.thresh.label --l rh.perirhinal_exvivo.thresh.label --a BA_exvivo.thresh --maxstatwinner --noverbose 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.stats -b -a ./rh.BA_exvivo.annot -c ./BA_exvivo.ctab sub-01 rh white 


 mris_anatomical_stats -th3 -mgz -f ../stats/rh.BA_exvivo.thresh.stats -b -a ./rh.BA_exvivo.thresh.annot -c ./BA_exvivo.thresh.ctab sub-01 rh white 


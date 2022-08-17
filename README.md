# plot_atlas
## plot on standard brain
 ![standard](https://github.com/nmningmei/plot_atlas/blob/master/figures/ROIs.jpeg)
## plot on inflated brain
![inflated](https://github.com/nmningmei/plot_atlas/blob/master/figures/ROI_surf.jpg)

# To plot ROIs

1. prepare all the mask images in the data folder
2. specify the mask folder
```python
data_dir = os.path.join('../data','fmri_rois')
```
3. specify the ROI names we want to plot
```python
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
```
4. specify the figure name
```python
figure name = 'ROI_surf.jpg'
```
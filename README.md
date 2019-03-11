# TextureHeterogeneityDetection
We present an approach of Spatial Heterogeneity, e.i, Habitats, detection using texture information. First, We compute circular harmonic wavelets for small patches within a Region of Interest (RoI). Second, we cluster patches in order to define the sub-regions of an image with similar texture patterns (habitats). Finally, information about resulting clusters and their texture signatures is presented as habitat descriptors.

<b>Introduction</b><br>
This code is part of a project which results are published in the paper: "Revealing Tumor Habitats from Texture Heterogeneity Analysis for Classification of Lung Cancer Malignancy and Aggressiveness". Please, see the original paper for details:<br>
TBA


<b>Input Arguments</b><br>
There are three input variables. The first is a 2D image. The second is a mask (RoI) for the image. The third is Harmonic Vector description.<br>
The image can be represented by any data type. There are no requirements for pixel value range or type.<br>
The mask has to be the same resolution as the image. Non-zero elements represent a RoI where heterogeneity will be evaluated.<br>
The Harmonic Vector (hV) represents the complexity and the number of a “convolution kernels”. All operations are done in Fourier space, so you may think about them as representatives of convolution kernels. The simplest texture description represented by 0. Next is -1 and 1 and so on. Thus, you can use hV as (0), (-1, 0), (-1, 0, 1), ..., (-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5) and so on. For more details see papers in the reference section.<br>
<br>


<b>Output Arguments</b><br>
Habitat detection algorithm produces two outputs.<br>
"Habitats": NxXxY matrix, where N is number of detected habitats, X and Y are resolutions of the input image. Each habitat is marked with non-zero elements in an individual habitat map. Function workflow/show_habitats.m can be used for displaying combined map.<br>
"Features": Structure variable containing description of habitats and tumor heterogeneity.<br>
"Features.num_clusters": number of detected habitats;<br>
"Features.fingerprint": texture signature values for each habitat. The order of signatures is the same as the order of habitat maps in "Habitats" output.<br>
"Features.q_features": Stracture field which describe statistical information about habitat areas.<br>
"Features.q_features.smallest_ration_v": Stracture field which describe statistical information about habitat areas.<br>
"Features.q_features.largest_region_v": Stracture field which describe statistical information about habitat areas.<br>
"Features.q_features.mean_region_v": Stracture field which describe statistical information about habitat areas.<br>
"Features.q_features.median_region_v": Stracture field which describe statistical information about habitat areas.<br>
"Features.q_features.disjoint_smallest_ration_v": Stracture field which describe statistical information about habitat areas.<br>
"Features.q_features.disjoint_largest_region_v": Stracture field which describe statistical information about habitat areas.<br>
"Features.q_features.disjoint_mean_region_v": Stracture field which describe statistical information about habitat areas.<br>
"Features.q_features.disjoint_median_region_v": Stracture field which describe statistical information about habitat areas.<br>




<b>Cohort processing</b><br>

<b>Example code</b>

%Include all subfolders into Matlab's PATH

clc;<br>
clear;<br>
close all;<br>
load('test_data.mat');<br>

hV = [-1,0,1];<br>
[habitats, features] = compute_features( img, mask, hV );<br>
show_habitats(habitats);title('Habitat map');<br>
figure; imagesc(img); colormap gray;title('CT data');<br>
figure; imagesc(mask); colormap gray;title('Original segmentation');<br>


<b>Assumptions and reproducibility</b>

rng('default')<br>
Line 21 at cluster_texture.m<br>

<b>References</b><br>
If you are going to use it, please, use the reference:<br>
TBA


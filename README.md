# TextureHeterogeneityDetection
We present an approach of Spatial Heterogeneity, e.i, Habitats, detection using texture information. First, We compute circular harmonic wavelets for small patches within a Region of Interest (RoI). Second, we cluster patches in order to define the sub-regions of an image with similar texture patterns (habitats). Finally, information about resulting clusters and their texture signatures is presented as habitat descriptors.

<H2>Introduction</H2><br>
This code is part of a project which results are published in the paper: "Revealing Tumor Habitats from Texture Heterogeneity Analysis for Classification of Lung Cancer Malignancy and Aggressiveness". Please, see the original paper for details:<br>
TBA


<H2>Input Arguments</H2><br>
There are three input variables. The first is a 2D image. The second is a mask (RoI) for the image. The third is Harmonic Vector description.<br><br>
1.  <i>"img"</i>: The Source 2D image. There are no requirements for pixel value range or type.<br><br>
2.  <i>"mask"</i>: An RoI for the source image. It has to have the same resolution as the input image. Non-zero elements represent an RoI where heterogeneity should be evaluated.<br><br>
3.  <i>"hV"</i>: The Harmonic Vector (hV) represents the complexity and the number of a “convolution kernels”. All operations are done in Fourier space, so you may think about them as representatives of convolution kernels. The simplest texture description represented by 0. Next is -1 and 1 and so on. Thus, you can set hV to (0), (-1, 0), (-1, 0, 1), ..., (-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5) and so on. For more details see papers in the reference section.<br>



<H2>Output Arguments</H2><br>

Habitat detection algorithm produces two outputs.<br><br>
+ <i>"Habitats"</i>: NxXxY matrix, where N is number of detected habitats, X and Y are resolutions of the input image. Each habitat is marked with non-zero elements in an individual habitat map. Function workflow/show_habitats.m can be used for displaying of combined map.
+ <i>"Features"</i>: Structure variable containing description of habitats and tumor heterogeneity.<br>
  + <i>"Features.num_clusters"</i>: number of detected habitats;<br>
  + <i>"Features.fingerprint"</i>: texture signature values for each habitat. The order of signatures is the same as the order of habitat maps in "Habitats" output.<br>
    + <i>"Features.q_features"</i>: Stracture field which describe statistical information about habitat areas.<br>
        + <i>"Features.q_features.smallest_ration_v"</i>: The smallest ratio of a habitat area to an RoI area.<br>
        + <i>"Features.q_features.largest_region_v"</i>: The largest ratio of a habitat area to an RoI area.<br>
        + <i>"Features.q_features.mean_region_v"</i>: The mean ratio of a habitat area to an RoI area.<br>
        + <i>"Features.q_features.median_region_v"</i>: The median ratio of a habitat area to an RoI area.<br>
        + <i>"Features.q_features.disjoint_smallest_ration_v"</i>: The smallest ratio of a <b>disjoint*</b> habitat area to an RoI area.<br>
        + <i>"Features.q_features.disjoint_largest_region_v"</i>: The largest ratio of a <b>disjoint*</b> habitat area to an RoI area.<br>
        + <i>"Features.q_features.disjoint_mean_region_v"</i>: The mean ratio of a <b>disjoint*</b> habitat area to an RoI area.<br>
        + <i>"Features.q_features.disjoint_median_region_v"</i>: The median ratio of a <b>disjoint*</b> habitat area to an RoI area.<br>
  + <i>"Features.centroids_mean_dist"</i>: Mean euclidean distance from each habitat texture signature to a RoI texture signature. The RoI texture signature is defined as mean value of all texture signatures.<br>
  + <i>	"Features.centroids_std_dist"</i>: Standart deviation of euclidean distances from each habitat texture signature to a RoI texture signature. The RoI texture signature is defined as mean value of all texture signatures.<br><br>


<b>*Habitats</b> are detected without the respect to their location within an RoI. As a result, an individual habitat can be presented as set of disjoint sub-regions within an RoI. In case where area statistics is computed on disjoint habitats each disjoint region of a habitat is considered as an independent habitat.<br>




<H2>Patient cohort processing</H2><br>

During processing a dataset of images it is important to fulfill the following requirements.<br><br>
+ Uniform spatial resolution. Medical image spatial resolution depends on a patient. For consistency of habitat detection across patients it is important to make spatial resulution uniform.<br><br>
+ Uniform image size. Texture computation is performed in the frequency space after the fourier transform. Varience in input image sizes will cause difference in texture signature computation and as a result drop in texture signatures comparability.<br><br>
+ Minimum data outside RoI. The result of the fourier transform depends on a content of an input image. <br><br>



<H2>Example code</H2>

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


<H2>Assumptions and reproducibility</H2>

rng('default')<br>
Line 21 at cluster_texture.m<br>

<H2>References</b></H2>
If you are going to use it, please, use the reference:<br>
TBA


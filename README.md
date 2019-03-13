# Texture Heterogeneity Detection
We present an approach of Spatial Heterogeneity, i.e., Habitats, detection using texture information. First, we compute circular harmonic wavelets for small patches within a Region of Interest (RoI). Second, we cluster patches in order to define the sub-regions of an image with similar texture patterns (habitats). Finally, information about resulting clusters and their texture signatures is presented as habitat descriptors.

<H2>Introduction</H2><br>
This code is part of a project which results are published in the paper: "Revealing Tumor Habitats from Texture Heterogeneity Analysis for Classification of Lung Cancer Malignancy and Aggressiveness". Please, see the original paper for details:<br>
TBA


<H2>Input Arguments</H2><br>
There are three input variables. The first one is a 2D image. The second one is a mask (RoI) for the input image. The third one is Harmonic Vector description.<br><br>
1.  <i>"img"</i>: The Source 2D image. There are no requirements for pixel value range or type.<br><br>
2.  <i>"mask"</i>: An RoI for the source image. It has to have the same resolution as the input image. Non-zero elements represent an RoI where heterogeneity should be evaluated.<br><br>
3.  <i>"hV"</i>: The Harmonic Vector (hV) represents the complexity and number of texture features. All texture computations are done in Fourier space, so you may think about hV as a representative of convolution kernels. The simplest texture description represented by 0. Next is -1 and 1 and so on. Thus, you can set hV to (0), (-1, 0), (-1, 0, 1), ..., (-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5) and so on. For more details see papers in the introduction section.<br>



<H2>Output Arguments</H2><br>

Habitat detection algorithm produces two outputs.<br><br>
+ <i>"Habitats"</i>: NxXxY matrix, where N is number of detected habitats, X and Y are resolutions of the input image. Each habitat is marked with non-zero elements in an individual habitat map. Function workflow/show_habitats.m can be used for displaying of combined habitat map.
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


<b>*Habitats</b> are detected without the respect to their location within an RoI. As a result, an individual habitat can be presented as a set of disjoint sub-regions within an RoI. In the case where area statistics is computed on disjoint habitats each disjoint region of a habitat is considered as an independent habitat.<br><br>

For a detailed description of the statistical features see the paper.<br>




<H2>Patient Cohort Processing</H2><br>

During processing a dataset of images it is important to fulfill the following requirements.<br><br>
+ <i>Uniform spatial resolution</i>. Medical image spatial resolution depends on the patient. For consistency of habitat detection across patients, it is important to make spatial resolution uniform.<br><br>
+ <i>Uniform image size</i>. Texture computation is performed in the frequency space after the Fourier transform. Variance in input image size will cause a difference in texture signature computation and as a result drop in texture signatures comparability.<br><br>
+ <i>Image size = 2^n</i>. Texture computation function requires input image size to be equal to 2^n, e.g. 256 or 512. Nevertheless, the content of an image located "far" from RoI affect the result of Fourier transform and as a result it affect texture computation result within RoI. Thus, the content of an image located "far" from RoI can be considered as noise. We recommend assigning pixels which are "far" from RoI to zero. See test data from example code section for an example.<br><br>

Overall, here is recommended preprocessing algorithm:<br>
1. Resample images into uniform spacing.<br>
2. Define the largest bounding box across training and test (if present) cohorts.<br>
3. Extend the bounding box by a constant.<br>
4. Extract a patch with resulting bounding box size from source image.<br>
5. Find n, such that 2^n is larger then founded bounded box size.<br>
6. Create an image with size 2^n and zero intensity pixel values.<br>
7. Substitute extracted patch into the center of created image.<br>

Result of the preprocessing step can be used as <i>compute_features.m</i> function input. <b>Step 3</b> is needed to prevet artifacts during texture computation on margine of a segmentation.<br><br>

<H2>Available Modifications</H2>

In order to increase reproducibility and simplify preprocessing, we updated the heterogeneity detection algorithm. Its texture computation function is modified in the way that the resolution of input images becomes irrelevant. There is only one requirement: <i>Uniform spatial resolution</i>. Due to changes in texture computation process results of the original and modified methods can vary. Download link for the modified method shown below:<br>
[link]<br>

<H2>Example Code</H2>

After you download the code, include all the folders (features, U, utils, Wavelet, and workflow) and their subfolders into Matlab PATH variable. All the computations are done by function <i>compute_features</i>. Below is an example of its usage.

```
%Include all folders and subfolders into Matlab PATH variable

clc;
clear;
close all;
load('test_data.mat');

hV = [-1,0,1];
[habitats, features] = compute_features( img, mask, hV );
show_habitats(habitats);title('Habitat map');
figure; imagesc(img); colormap gray;title('CT data');
figure; imagesc(mask); colormap gray;title('Original segmentation');
```

<H2>Assumptions and Peproducibility</H2>

We use k-mean algorithm for detection of clusters with similar texture signatures. For reproducibility we used default Random Number Generator.
```
rng('default')
```
Line 21 at <i>workflow/cluster_texture.m</i><br>

<H2>References</b></H2>
If you are going to use it, please, use the reference:<br>
TBA


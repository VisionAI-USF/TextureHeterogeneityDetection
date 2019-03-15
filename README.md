# Texture Heterogeneity Detection
We present an approach of Spatial Heterogeneity, i.e., Habitat detection using texture information. First, we compute circular harmonic wavelets for small patches within a Region of Interest (RoI). Second, we cluster patches in order to define the sub-regions of an image with similar texture patterns (habitats). Finally, information about resulting clusters and their texture signatures, habitat descriptors, is presented.

<H2>Introduction</H2><br>
This code is part of a project whose results are published in the paper: "Revealing Tumor Habitats from Texture Heterogeneity Analysis for Classification of Lung Cancer Malignancy and Aggressiveness". The paper is in open access and can be found here: <br>
https://www.nature.com/articles/s41598-019-38831-0<br>


<H2>Input Arguments</H2><br>
There are three input variables. The first one is a 2D image. The second one is a mask (RoI) for the input image. The third one is a Harmonic Vector description.<br><br>
1.  <i>"img"</i>: The Source 2D image. There are no requirements for pixel value range or type.<br><br>
2.  <i>"mask"</i>: An RoI for the source image. It has to have the same resolution as the input image. Non-zero elements represent an RoI where heterogeneity should be evaluated.<br><br>
3.  <i>"hV"</i>: The Harmonic Vector (hV) represents the complexity and number of texture features. All texture computations are done in Fourier space, so you may think about hV as a representative of convolution kernels. The simplest texture description represented by 0. Next is -1 and 1 and so on. Thus, you can set hV to (0), (-1, 0), (-1, 0, 1), ..., (-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5) and so on.<br>
Deteiled description of texture computation can be found in the following paper:<br>
Depeursinge, A., Puspoki, Z., Ward, J.-P. & Unser, M. Steerable Wavelet Machines (SWM): Learning Moving Frames for Texture Classification.<br>
IEEE Transactions on Image Process. 26, 1626–1636 (2017)<br>



<H2>Output Description</H2><br>

The Habitat detection algorithm produces two outputs.<br><br>
+ <i>"Habitats"</i>: An NxXxY matrix, where N is number of detected habitats, X and Y are the size of the input image. Each habitat is marked with non-zero elements in an individual habitat map. Function workflow/show_habitats.m can be used for displaying a combined habitat map.
+ <i>"Features"</i>: Structure variable containing a description of habitats and tumor heterogeneity.<br>
  + <i>"Features.num_clusters"</i>: number of detected habitats;<br>
  + <i>"Features.fingerprint"</i>: texture signature values for each habitat. The order of signatures is the same as the order of habitat maps in "Habitats" output.<br>
  + <i>"Features.q_features"</i>: Stracture field which describes statistical information about habitat areas.<br>
      + <i>"Features.q_features.smallest_ration_v"</i>: The smallest ratio of a habitat area to an RoI area.<br>
      + <i>"Features.q_features.largest_region_v"</i>: The largest ratio of a habitat area to an RoI area.<br>
      + <i>"Features.q_features.mean_region_v"</i>: The mean ratio of a habitat area to an RoI area.<br>
      + <i>"Features.q_features.median_region_v"</i>: The median ratio of a habitat area to an RoI area.<br>
      + <i>"Features.q_features.disjoint_smallest_ration_v"</i>: The smallest ratio of a <b>disjoint*</b> habitat area to an RoI area.<br>
      + <i>"Features.q_features.disjoint_largest_region_v"</i>: The largest ratio of a <b>disjoint*</b> habitat area to an RoI area.<br>
      + <i>"Features.q_features.disjoint_mean_region_v"</i>: The mean ratio of a <b>disjoint*</b> habitat area to an RoI area.<br>
      + <i>"Features.q_features.disjoint_median_region_v"</i>: The median ratio of a <b>disjoint*</b> habitat area to an RoI area.<br>
  + <i>"Features.centroids_mean_dist"</i>: Mean Euclidean distance from each habitat texture signature to an RoI texture signature. The RoI texture signature is defined as a mean value of all texture signatures.<br>
  + <i>	"Features.centroids_std_dist"</i>: Standard deviation of Euclidean distances from each habitat texture signature to an RoI texture signature. The RoI texture signature is defined as the mean value of all texture signatures.<br><br>


<b>*Habitats</b> are detected without the requirment that they be a contiguous region within an RoI. As a result, an individual habitat can be presented as a set of disjoint sub-regions within an RoI. In the case where area statistics are computed on disjoint habitats each disjoint region of a habitat is considered as an independent habitat.<br><br>

For a detailed description of the statistical features please see the paper.<br>




<H2>Patient Cohort Processing</H2><br>

During processing a dataset of images it is important to fulfill the following requirements.<br><br>
+ <i>Uniform spatial resolution</i>. Medical image spatial resolution depends on the patient. For consistency of habitat detection across patients, it is important to make spatial resolution uniform.<br><br>
+ <i>Uniform image size</i>. Texture computation is performed in the frequency space after the Fourier transform. Variance in input image size will cause a difference in texture signature computation and as a result one will see a drop in texture signatures comparability.<br><br>
+ <i>Image size = 2^n</i>. Texture computation function requires input image size to be equal to 2^n, e.g. 256 or 512. Nevertheless, the content of an image located "far" from the RoI affects the result of the Fourier transform and as a result it affects the texture computation result within the RoI. Thus, the content of an image located "far" from the RoI can be considered  noise. We recommend assigning pixels which are "far" from the RoI to zero. See test data from example code section for an example.<br><br>

Overall, here is the recommended preprocessing algorithm:<br>
1. Resample images into uniform spacing.<br>
2. Define the largest bounding box across training and test (if present) cohorts.<br>
3. Extend the bounding box by a constant.<br>
4. Extract a patch with resulting bounding box size from a source image.<br>
5. Find n, such that 2^n is larger then the bounded box size in 4.<br>
6. Create an image with size 2^n and zero intensity pixel values.<br>
7. Substitute the extracted patch into the center of the created image.<br>

The result of the preprocessing step can be used as the <i>compute_features.m</i> function input. <b>Step 3</b> is needed to prevent artifacts during texture computation on the margin of a segmentation.<br><br>

<H2>Available Modifications</H2>

In order to increase reproducibility and simplify preprocessing, we updated the heterogeneity detection algorithm. Its texture computation function was modified such that way that the resolution of input images becomes irrelevant. There is only one requirement: <i>Uniform spatial resolution</i>. Due to changes in the texture computation process results of the original and modified methods can vary. A download link for the modified method is shown below:<br>
https://github.com/VisionAI-USF/TextureHeterogeneityDetection_easy_preprocess<br>

<H2>Example Code</H2>


After you download the code, include all the folders (features, U, utils, Wavelet, and workflow) and their subfolders into Matlab PATH variable.<br>
To do that in a terminal you need to change working directory (<i>cd</i> command) to the one where the downloaded code is located. Then you can use the code below after starting Matlab.

```
cur_folder = pwd();
addpath([cur_folder,filesep,'features']);
addpath([cur_folder,filesep,'U']);
addpath([cur_folder,filesep,'utils']);
addpath([cur_folder,filesep,'Wavelet']);
addpath([cur_folder,filesep,'Wavelet',filesep,'Radial']);
addpath([cur_folder,filesep,'workflow']);
```


All the computations are done by the function <i>compute_features</i>. Below is an example of its usage.

```
clc;
clear;
close all;
load('test_data.mat');

hV = [-1,0,1];
[habitats, features] = compute_features( img, mask, hV );

```

After execution the code above you should get following resuls:

```
habitats = 14x512x512 double

features = 
           num_clusters: 14
            fingerprint: [14×9 double]
             q_features: [1×1 struct]
    centroids_mean_dist: 75.5132
     centroids_std_dist: 39.2991
```

If you are running Matlab using a graphical user interface (GUI), then you can plot input data and resulting habitat map using following code.
```
show_habitats(habitats);title('Habitat map');
figure; imagesc(img); colormap gray;title('CT data');
figure; imagesc(mask); colormap gray;title('Original segmentation');
```
<H2>Assumptions and Reproducibility</H2>

We use the k-means algorithm for detection of clusters with similar texture signatures. For reproducibility we used the default Random Number Generator.
```
rng('default')
```
Line 21 at <i>workflow/cluster_texture.m</i><br>

<H2>References</b></H2>
If you are going to use this code, please, use the reference:<br>
TBA


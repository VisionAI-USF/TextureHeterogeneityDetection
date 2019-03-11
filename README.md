# TextureHeterogeneityDetection
We present an approach of Spatial Heterogeneity, e.i, Habitats, detection using texture information. First, We compute circular harmonic wavelets for small patches within a Region of Interest (RoI). Second, we cluster patches in order to define the sub-regions of an image with similar texture patterns (habitats). Finally, information about resulting clusters and their texture signatures is presented as habitat descriptors.

<b>Introduction</b><br>
This code is part of a project which results are published in the paper: "Revealing Tumor Habitats from Texture Heterogeneity Analysis for Classification of Lung Cancer Malignancy and Aggressiveness". Please, use the reference below if you are going to use the provided code:<br>
TBA


<b>Input</b><br>
There are three variables as an input. The first of them is an image. The second is a mask (RoI) for the image. The third is Harmonic Vector description.<br>
The image can be represented by any data type. There are no requirements for pixel value range or type.<br>
The mask has to be the same resolution as the image. Non-zero elements represent a region where heterogeneity will be evaluated.<br>
The Harmonic Vector (hV) represents the complexity and the number of a “convolution kernels”. All operations are done in Fourier space, so you may think about them as representatives of convolution kernels. The simplest texture description represented by 0. Next is -1 and 1 and so on. Thus, you can use hV as (0), (-1, 0), (-1, 0, 1), ..., (-5, -4, -3, -2, -1, 0, 1, 2, 3, 4, 5) and so on. For more details see papers in the reference section.<br>
<br>


<b>Output</b><br>
features<br>
habitats<br>

<b>Example code</b>

%Include all subfolders into Matlab's PATH

clc;<br>
clear;<br>
close all;<br>
load('test_data.mat');<br>

hV = [-1,0,1];<br>
[habitats, features] = compute_features( img, mask, hV );<br>
show_habitats(habitats);<br>
figure; imagesc(img); colormap gray;<br>
figure; imagesc(mask); colormap gray;<br>


<b>Assumptions and reproducibility</b>

rng('default')<br>
Line 21 at cluster_texture.m<br>

<b>References</b><br>
If you are going to use it, please, use the reference:<br>
TBA


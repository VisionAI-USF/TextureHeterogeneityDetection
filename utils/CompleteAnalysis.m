function [Q, res] = CompleteAnalysis(A,num_scales,ha,hd,harmonics,prefilter,pyramid)
%
% function [Q res] = CompleteAnalysis(A,num_scales,ha,hd,harmonics,prefilter,pyramid) 
%
%
% steerable wavelet analysis.
%
%
% INPUTS
% ------
%
% A             image to process
%
% num_scales    number of scales
%
% ha            approximation filter (function handle)
%
% hd            detail filter  (function handle)
%
% harmonics     vector of harmonics (corresponding to exp^j*harmonics*angle)
%
% prefilter     whether to prefilter the image (logical, defaults to false)
%
% pyramid     use false for undecimated wavelet transform
%
% OUTPUTS
% -------
%
% Q             cell array of wavelet coefficients per scale.
%               Q{i}.channels(j,:,:) is the array of coefficients in the jth
%               channel in scale i, with additional field
%               Q{end}.channels_approx for lowpass coefficients.
%               
% res           residue from prefiltering (empty if no prefiltering).
%
%
% REFERENCE
% ---------
%
% M. Unser and N. Chenouard, "A Unifying Parametric Framework for 2D Steerable
% Wavelet Transforms", SIAM J. Imaging Sci., vol. 6., pp 102-135, 2013.
%
%
% AUTHOR
% ------
%
% Zs. Puspoki (zsuzsanna.puspoki@epfl.ch)
%
% Biomedical Imaging Group
% Ecole Polytechnique Federale de Lausanne (EPFL)

if ~exist('prefilter','var')
    prefilter = false;
end

% Initialization
Q = cell(num_scales,1);

% Multiscale Isotropic Wavelet Analysis
[Qi, res] = MultiScaleIsoWaveAnalysis(A,num_scales,ha,hd,prefilter,pyramid);

% Channel Analysis
for i=1:num_scales
%       Q{i}.channels = channelAnalysis(A,harmonics);
      Q{i}.channels = channelAnalysis(Qi{i}.detail,harmonics);
end
 
% Channel Analysis (lowpass)
% Q{end}.channels_approx = channelAnalysis(A,harmonics);
Q{end}.channels_approx = channelAnalysis(Qi{end}.approx,harmonics);

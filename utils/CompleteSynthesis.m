function A = CompleteSynthesis(Q,ha,hd,harmonics,res,pyramid)
%
% function A = CompleteSynthesis(Q,ha,hd,harmonics,res)
%
%
% steerable wavelet synthesis.
%
%
% INPUTS
% ------
%
% Q             cell array of wavelet coefficients per scale
%
% ha            approximation filter (function handle)
%
% hd            detail filter  (function handle)
%
% harmonics     vector of harmonics (corresponding to exp^j*harmonics*angle)
%
% res           residue from prefiltering (optional)
%
%
% OUTPUTS
% -------
%
% A             synthesized image
%
%
% REFERENCE
% ---------
%
% M. Unser and N. Chenouard, "A Unifying Parametric Framework for 2D Steerable
% Wavelet Transforms", SIAM J. Imaging Sci., in press.
%
%
% AUTHOR
% ------
%
% Zs. Puspoki (zsuzsanna.puspoki@epfl.ch)
%
% Biomedical Imaging Group
% Ecole Polytechnique Federale de Lausanne (EPFL)

if ~exist('res','var')
    res = [];
end

% Initialization
num_scales = length(Q);
Qi = cell(num_scales,1);


% Computation of isotropic wavelet coefficients
for i=1:num_scales
      Qi{i}.detail = channelSynthesis(Q{i}.channels,harmonics);
end

% Computation of isotropic wavelet coefficients (lowpass)
Qi{end}.approx = channelSynthesis(Q{end}.channels_approx,harmonics);

A = MultiScaleIsoWaveSynthesis(Qi,ha,hd,res,pyramid);

function [Q,res] = MultiScaleIsoWaveAnalysis(A,num_scales,ha,hd,prefilter,pyramid)
%
% function [Q,res] = MultiScaleIsoWaveAnalysis(A,num_scales,ha,hd,prefilter)
%
%
% multiscale isotropic wavelet analysis.
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
% prefilter     whether to prefilter the image (logical, defaults to false)
%
% pyramid     use false for undecimated wavelet transform
%
% OUTPUTS
% -------
%
% Q             cell array of wavelet coefficients per scale; Q{i} has fields
%               .approx and .detail for approximation and detail coefficients
%               at the i-th scale Q{i}.
%               
% res           residue from prefiltering (empty if no prefiltering).
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

if ~exist('prefilter','var')
    prefilter = false;
end

% Initialization
Q = cell(num_scales,1);

% prefilter
if prefilter
    [A,res] = Prefilter(A,@(r) ha(r/2));
else
    res = [];
end

% keep initial image size
sizeInit=size(A);
sizeDown=sizeInit;

% Wavelet coefficients for the first scale:
[Q{1}.approx, Q{1}.detail] = isoWaveAnalysis(A,ha,hd,pyramid,sizeInit,sizeDown);

if pyramid
    Q{1}.approx = Q{1}.approx(1:2:end,1:2:end);
end;
sizeDown=round(sizeDown/2);

% Wavelet coefficients for the remaining scales
for i=2:num_scales
    
    [Q{i}.approx, Q{i}.detail] = isoWaveAnalysis(Q{i-1}.approx,ha,hd,pyramid,sizeInit,sizeDown);
    
    if pyramid
        Q{i}.approx = Q{i}.approx(1:2:end,1:2:end);
    end;
    sizeDown=sizeDown/2;
end

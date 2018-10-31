function A = MultiScaleIsoWaveSynthesis(Q,ha,hd,res,pyramid)
%
% function A = MultiScaleIsoWaveSynthesis(Q,ha,hd,res)
%
%
% multiscale isotropic wavelet synthesis.
%
%
% INPUTS
% ------
%
% Q             cell array of wavelet coefficients per scale; Q{i} has fields
%               .approx and .detail for approximation and detail coefficients
%               at the i-th scale Q{i}. The .approx fields from all but the
%               last scale are not used.
%
% ha            approximation filter (function handle)
%
% hd            detail filter  (function handle)
%               
% res           residue from prefiltering
%
%
% OUTPUTS
% -------
%
% A             resynthesized image
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

% function A = MultiScaleIsoWaveSynthesis(Q,ha,hd,res)

% Q: wavelet coeffs for the different scales, cell
% ha: approximation wavelet, function
% hd: detail wavelet, function
% res: residue from prefiltering (optional)

if ~exist('res','var')
    res = [];
end

num_scales = length(Q);

approx = Q{num_scales}.approx;

sizeInit=size(approx);
sizeDown=sizeInit;

for i = num_scales:-1:1,    
   
    if pyramid,
        approxup = zeros(2*size(approx)); 
        approxup(1:2:end,1:2:end) = 4*approx; % 4x 1/4th of the coeffs
        sizeDown=sizeDown*2;
    else
        approxup=approx;
        sizeDown=sizeInit/2^(i-1);
    end;

    detailup = Q{i}.detail;
    approx = isoWaveSynthesis(approxup,detailup,ha,hd,pyramid,sizeInit,sizeDown);
end

A = approx;

if ~isempty(res)
    A = Postfilter(A,res,@(r) ha(r/2));
end

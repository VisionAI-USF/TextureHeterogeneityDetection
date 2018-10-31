function A = isoWaveSynthesis(approx,detail,ha,hd,pyramid,sizeInit,sizeDown)
%
% function A = isoWaveSynthesis(approx,detail,ha,hd)
%
%
% single-scale isotropic wavelet synthesis.
%
%
% INPUTS
% ------
%
% approx        lowpass channel
%
% detail        highpass channel
%
% ha            approximation filter (function handle)
%
% hd            detail filter  (function handle)
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

% sA = size(approx);
sA = sizeDown;

wmax1 = pi;
wmax2 = pi;
dw1   = 2*pi/sA(1);
dw2   = 2*pi/sA(2);
w1    = -wmax1:dw1:(wmax1-dw1);
w2    = -wmax2:dw2:(wmax2-dw2);

[W1, W2] = ndgrid(w1,w2);

RHO = sqrt(W1.^2+W2.^2);

Fscaling = ha(RHO);
Fwavelet = hd(RHO);

if ~pyramid,
    
    Fscaling=fftshift(Fscaling);
    Fscaling=cat(1,Fscaling(1:floor(end/2),:),zeros(sizeInit(1)-sizeDown(1),sizeDown(1)),Fscaling(floor(end/2)+1:end,:));
    Fscaling=cat(2,Fscaling(:,1:floor(end/2)),zeros(sizeInit(2),sizeInit(2)-sizeDown(2)),Fscaling(:,floor(end/2)+1:end));
    Fscaling=ifftshift(Fscaling);
    
    Fwavelet=fftshift(Fwavelet);
    Fwavelet=cat(1,Fwavelet(1:floor(end/2),:),ones(sizeInit(1)-sizeDown(1),sizeDown(1)),Fwavelet(floor(end/2)+1:end,:));
    Fwavelet=cat(2,Fwavelet(:,1:floor(end/2)),ones(sizeInit(2),sizeInit(2)-sizeDown(2)),Fwavelet(:,floor(end/2)+1:end));
    Fwavelet=ifftshift(Fwavelet);
end;

Fapprox = fftshift(fftn(approx));
Fdetail = fftshift(fftn(detail));

A = ifftn(fftshift(Fscaling.*Fapprox + Fwavelet.*Fdetail));

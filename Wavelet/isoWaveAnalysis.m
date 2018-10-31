function [approx, detail] = isoWaveAnalysis(A,ha,hd,pyramid,sizeInit,sizeDown)
%
% function [approx detail] = isoWaveAnalysis(A,ha,hd)
%
%
% single-scale isotropic wavelet analysis.
%
%
% INPUTS
% ------
%
% A             image to process
%
% ha            approximation filter (function handle)
%
% hd            detail filter  (function handle)
%
%
% OUTPUTS
% -------
%
% approx        lowpass channel
%
% detail        highpass channel
%
% pyramid     use false for undecimated wavelet transform
%
% sizeInit     intial size of the image
%
% sizeDown size of the subband when decimated 
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


sA = sizeDown;

wmax1 = pi;
wmax2 = pi;
dw1   = 2*pi/sA(1);
dw2   = 2*pi/sA(2);
w1    = -wmax1:dw1:(wmax1-dw1);
w2    = -wmax2:dw2:(wmax2-dw2);

[W1, W2] = ndgrid(w1,w2);

RHO = sqrt(W1.^2+W2.^2);

% figure
% imshow(RHO)

Fscaling = ha(RHO); 
Fwavelet = hd(RHO);
 
if ~pyramid
    
    Fscaling=fftshift(Fscaling);
    Fscaling=cat(1,Fscaling(1:floor(end/2),:),zeros(sizeInit(1)-sizeDown(1),sizeDown(1)),Fscaling(floor(end/2)+1:end,:));
    Fscaling=cat(2,Fscaling(:,1:floor(end/2)),zeros(sizeInit(2),sizeInit(2)-sizeDown(2)),Fscaling(:,floor(end/2)+1:end));
    Fscaling=ifftshift(Fscaling);
    
    Fwavelet=fftshift(Fwavelet);
    Fwavelet=cat(1,Fwavelet(1:floor(end/2),:),ones(sizeInit(1)-sizeDown(1),sizeDown(1)),Fwavelet(floor(end/2)+1:end,:));
    Fwavelet=cat(2,Fwavelet(:,1:floor(end/2)),ones(sizeInit(2),sizeInit(2)-sizeDown(2)),Fwavelet(:,floor(end/2)+1:end));
    Fwavelet=ifftshift(Fwavelet);
end;

FA = fftshift(fftn(A));

approx = ifftn(fftshift(Fscaling.*FA));
detail = ifftn(fftshift(Fwavelet.*FA));

% fftshift Shift zero-frequency component to center of spectrum.

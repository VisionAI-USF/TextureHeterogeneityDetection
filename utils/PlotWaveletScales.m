function PlotWaveletScales(hafun,hdfun,hfun,U,harmonics,sA,num_scales,steerangle)
%
% function PlotWaveletScales(hafun,hdfun,hfun,U,harmonics,sA,num_scales,steerangle)
%
%
% plot wavelet function for each scale and channel and mother wavelet for the
% last scale at the same resolution as used for analysis (all channels for each
% scale are given in a separate plot).
%
%
% INPUTS
% ------
%
% hafun         approximation filter (function handle)
%
% hdfun         detail filter  (function handle)
%
% hfun          isotropic mother wavelet Fourier transform (function handle)
%
% U             construction matrix
%
% harmonics     vector of harmonics (corresponding to exp^j*harmonics*angle)
%
% sA            size of the image
%
% num_scales    number of scales
%
% steerangle    angle by which to steer the wavelet (optional, defaults to 0)
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

if ~exist('steerangle','var')
    steerangle = 0;
end

%fprintf('\nPlot wavelet...\n');

num_chan   = size(U,1);

for i=1:num_scales    
    figure;
    for j=1:num_chan

        alpha = 1;
        dx = 1;
        xmax = 2*sA(1)/2^(i-1);

        psi = psiWav(hfun,U(j,:),harmonics,alpha,dx,xmax,steerangle);

        subplot(3,num_chan,j);
        imagesc(abs(psi));
        title(sprintf('chan %d',j));
        axis image;
        axis square;
        axis off;
        %colorbar;

        subplot(3,num_chan,j+num_chan);
        imagesc(real(psi));
        title(sprintf('chan %d',j));
        title(sprintf('chan %d',j));
        axis image;
        axis square;
        axis off;
        %colorbar;

        subplot(3,num_chan,j+2*num_chan);
        imagesc(imag(psi));
        title(sprintf('chan %d',j));
        axis image;
        axis square;
        axis off;
        %colorbar;
    end
    suptitle(sprintf('wavelet scale %d, 1st row: mag, 2nd row: real, 3rd row: imag',i));
end


figure;

alpha = 1;
dx = 1;
xmax = 2*sA(1)/2^(num_scales-1);

for j=1:num_chan
    phi = psiWav(hafun,U(j,:),harmonics,alpha,dx,xmax,steerangle);

    subplot(3,num_chan,j);
    imagesc(abs(phi));
    title(sprintf('chan %d',j));
    axis image;
    axis square;
    axis off;
    %colorbar;

    subplot(3,num_chan,j+num_chan);
    imagesc(real(phi));
    title(sprintf('chan %d',j));
    axis image;
    axis square;
    axis off;
    %colorbar;

    subplot(3,num_chan,j+2*num_chan);
    imagesc(imag(phi));
    title(sprintf('chan %d',j));
    axis image;
    axis square;
    axis off;
    %colorbar;
end
suptitle(sprintf('scaling function, 1st row: mag, 2nd row: real, 3rd row: imag'));

drawnow;

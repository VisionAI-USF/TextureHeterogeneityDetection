function PlotWavelet(hfun,u,harmonics,steerangle)
%
% function PlotWavelet(hfun,u,harmonics,steerangle)
%
%
% plot wavelet function.
%
%
% INPUTS
% ------
%
% hfun          isotropic mother wavelet Fourier transform (function handle)
%
% u             vector of Riesz expansion coefficients for given harmonics
%
% harmonics     vector of harmonics (corresponding to exp^j*harmonics*angle)
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

% parameters for Fourier domain sampling of the wavelet function for plots
plot_dx   = .1;
plot_xmax = 50;

psi = psiWav(hfun,u,harmonics,1,plot_dx,plot_xmax,steerangle);

figure;

subplot 221
imagesc(abs(psi));
title(sprintf('wavelet abs'));
axis square;
axis off;
colorbar;

subplot 222
imagesc(angle(psi));
title('wavelet phase');
axis square;
axis off;
colorbar;

subplot 223
imagesc(real(psi));
title('wavelet real');
axis square;
axis off;
colorbar;

subplot 224
imagesc(imag(psi));
title('wavelet imag');
axis square;
axis off;
colorbar;

drawnow;

end

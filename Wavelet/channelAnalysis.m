function rv = channelAnalysis(A,harmonics)
%
% function rv = channelAnalysis(A,harmonics)
%
%
% channel analysis.
%
%
% INPUTS
% ------
%
% A             image (or coefficient matrix) to process
%
% harmonics     vector of harmonics (corresponding to exp^j*harmonics*angle)
%
%
% OUTPUT
% ------
%
% rv            3D array with rv(j,:,:) corresponding to the channel transformed by
%               exp^j*harmonics(j)*Fourier_angle
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

num_chan = length(harmonics);

sA = size(A);
FA = fftshift(fftn(A));

wmax1 = pi;
wmax2 = pi;
dw1   = 2*pi/sA(1);
dw2   = 2*pi/sA(2);
w1    = -wmax1:dw1:(wmax1-dw1);
w2    = -wmax2:dw2:(wmax2-dw2);

[W1, W2] = ndgrid(w1,w2);

PHI = atan2(W2,W1);

rv = zeros([num_chan sA]);

for iter=1:num_chan,
    rv(iter,:,:) = ifftn(fftshift((FA.*exp(1j*harmonics(iter)*PHI))));
end


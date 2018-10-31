function hr = h_Papadakis_d(r)
%
% function hr = h_Papadakis_d(r)
%
%
% for Papadakis wavelet.
%
%
% INPUTS
% ------
%
% r             Fourier radius vector
%
%
%
% OUTPUT
% ------
%
% hr            radial Fourier value at r
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

h = (r> (3*pi/10)).*(r<= (pi/2)).*sqrt((1+cos(5*r - (3*pi/2)))/2) + (r <= (3*pi/10));
h(r == 0) = 1;
h(r == pi) = 0;

hr = sqrt(1- h.^2);

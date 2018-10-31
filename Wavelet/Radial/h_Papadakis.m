function hr = h_Papadakis(r)
%
% function hr = h_Papadakis(r)
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

hr = (r> (3*pi/10)).*(r<= (pi/2)).*sqrt((1+sin(5*r))/2) + (r <= (3*pi/5)).*(r > (pi/2)) + (r > (3*pi/5)).*(r <= pi).*sqrt((1-sin(5*r/2))/2);
hr(r==0) = 0;

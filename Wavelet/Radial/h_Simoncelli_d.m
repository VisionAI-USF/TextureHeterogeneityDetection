function hr = h_Simoncelli_d(r)
%
% function hr = h_Simoncelli_d(r)
%
%
% for Simoncelli wavelet.
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

hr = (r<= (pi/2)).*(r> (pi/4)).*(cos((pi/2)*log2(2*r/pi))) + (r > (pi/2));
hr(r==0) = 0;

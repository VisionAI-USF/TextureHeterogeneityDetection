function hr = h_Meyer(r)
%
% function hr = h_Meyer(r)
%
%
% for Meyer wavelet.
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

hr = (r<= (pi/2)).*(r> (pi/4)).*(sin((pi/2)*nu((4*r/pi)-1))) + (r <= pi).*(r > (pi/2)).*(cos((pi/2)*nu((2*r/pi)-1)));

function v = nu(t)
v = (t>0).*(t<1).*(t.^4 .*(35 - 84.*t + 70*t.^2 -20*t.^3));

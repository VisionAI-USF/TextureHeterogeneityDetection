function [U,harmonics] = Hessian()
%
% function [U,harmonics] = Hessian()
%
%
% U matrix for Hessian design.
%
%
% INPUTS
% ------
%
%
% OUTPUTS
% -------
%
% U             construction matrix
%
% harmonics     vector of harmonics (corresponding to exp^j*harmonics*angle)
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

U = [-1/4 , -1/2 , -1/4 
     -1i/(2*sqrt(2)) , 0 , 1i/(2*sqrt(2))
     1/4 , -1/2 , 1/4];

harmonics = -2:2:2;

end

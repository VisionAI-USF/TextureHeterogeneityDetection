function [U,harmonics] = Monogenic()
%
% function [U,harmonics] = Monogenic()
%
%
% U matrix for Monogenic design.
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

U = [0 , 1 , 0; -1i/2 , 0 , -1i/2; 1/2 , 0 , -1/2]/sqrt(2);

harmonics = -1:1;

end

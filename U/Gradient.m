function [U,harmonics] = Gradient()
%
% function [U,harmonics] = Gradient()
%
%
% U matrix for gradient design.
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

U = [1i/2 , 1i/2; -1/2 , 1/2];

harmonics = [-1,1];

end

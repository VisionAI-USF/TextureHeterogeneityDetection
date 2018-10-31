function [U,harmonics] = CircularHarmonic(harmonics)
%
% function [U,harmonics] = CircularHarmonic(harmonics)
%
%
% U matrix for circular harmonic design.
%
%
% INPUTS
% ------
%
% harmonics     vector of harmonics (corresponding to exp^j*harmonics*angle)
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

lH = length(harmonics);

U = eye(lH)/sqrt(lH);

end


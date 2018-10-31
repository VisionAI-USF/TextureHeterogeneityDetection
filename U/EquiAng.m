function [U,harmonics] = EquiAng(harmonics,u,M)
%
% function [U,harmonics] = EquiAng(harmonics,u,M)
%
%
% U matrix for generalized equiangular design.
%
%
% INPUTS
% ------
%
% harmonics     vector of harmonics (corresponding to exp^j*harmonics*angle)
%
% u             design vector
%
% M             number of equiangular channels
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

lu = length(u);
N = max(abs(harmonics));

if M < 2*N + 1
    error(sprintf('Theorem 5.2 requires M >= 2N + 1 (currently M = %d, N = %d)',M,N));
end

U = zeros(M,lu);

for i = 1:M,
    theta =  2*pi*(i-1)/M;
    for j = 1:lu,
        U(i,j) = u(j)*exp(-1j*harmonics(j)*theta);
    end
end

U = U/sqrt(trace(U'*U));

function [U,harmonics] = SimoncelliEven(order)
%
% function [U,harmonics] = SimoncelliEven(order)
%
%
% U matrix for even Simoncelli design.
%
%
% INPUTS
% ------
%
% order         wavelet order
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
% Based on code by N. Chenouard
%
% Biomedical Imaging Group
% Ecole Polytechnique Federale de Lausanne (EPFL)

if(mod(order,2)==1)
    error('For SimoncelliEven design the order should be even.');
end

harmonics = -order:2:order;

lH = length(harmonics);

Np = order/2;
U = zeros(lH);
for j = 1:lH;
    thetaj = pi*(j-1)/lH + pi/2;
    for i=1:lH
        npp = harmonics(i);
        fact = factorial(order)/(factorial(Np + npp/2)*factorial(Np - npp/2));
        U(i, j) = ((-1j)^order)*fact*exp(1j*npp*thetaj);
    end
end
U = U/sqrt(real(trace(U*U')));% rescale to be tight frame

U = U.';

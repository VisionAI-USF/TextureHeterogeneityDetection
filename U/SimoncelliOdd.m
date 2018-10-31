function [U,harmonics] = SimoncelliOdd(order)
%
% function [U,harmonics] = SimoncelliOdd(order)
%
%
% U matrix for odd Simoncelli design.
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

if(mod(order,2)==0)
    error('For SimoncelliOdd design the order should be odd.');
end

harmonics = -order:2:order;

lH = length(harmonics);

Np = floor(order/2);
U = zeros(lH);
for j = 1:lH,
    thetaj = pi*(j-1)/lH + pi/2;
    for i=1:lH
        npp = harmonics(i);
        fact = factorial(2*Np+1)/(factorial(Np + (npp+1)/2)*factorial(Np - (npp-1)/2));
        U(i, j) = ((-1j)^order)*fact*exp(1j*npp*thetaj);
    end
end
U = U/sqrt(real(trace(U*U')));% rescale to be tight frame

U = U.';

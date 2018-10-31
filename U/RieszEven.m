function [U,harmonics] = RieszEven(order)
%
% function [U,harmonics] = RieszEven(order)
%
%
% U matrix for even Riesz design.
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
    error('For RieszEven design the order should be even.');
end

harmonics = -order:2:order;

lH = length(harmonics);

U = zeros(lH);
n = floor(order/2);
for n1 = 0:order,
    n2 = order - n1;
    fact = (-1j/2)^order*sqrt(factorial(order)/(factorial(n1)*factorial(n2)))/(1j^n2);
    for n1b = 0:n1,
        for n2b = 0:n2,
            factb = (-1)^(n2-n2b)*factorial(n1)*factorial(n2)/(factorial(n1b)*factorial(n1-n1b)*factorial(n2b)*factorial(n2-n2b));
            h = 2*(n1b+n2b-n);
            U(harmonics==h, n1+1) = U(harmonics==h, n1+1) + fact*factb;
        end
    end
end

U = U.';

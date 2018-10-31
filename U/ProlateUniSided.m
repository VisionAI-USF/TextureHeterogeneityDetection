function [U,harmonics] = ProlateUniSided(harmonics)
%
% function [U,harmonics] = ProlateUniSided(harmonics)
%
%
% U matrix for uni-sided Prolate design.
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
% Based on code by N. Chenouard
%
% Biomedical Imaging Group
% Ecole Polytechnique Federale de Lausanne (EPFL)

if min(harmonics) < 0
    error('For ProlateUniSided design all harmonics should be non-negative.');
end

lH = length(harmonics);

W = zeros(lH);
for j = 1:lH;
    W(j,:) = harmonics(j)-harmonics;
end
for i = 1:lH
    for j = 1:lH
        if (W(i,j)==0)
            W(i,j) = pi^2/3;
        else
            W(i,j) = (2*pi*W(i,j)*cos(pi*W(i,j)) + sin(pi*W(i,j))*(pi^2*W(i,j)^2-2))/(pi*W(i,j)^3);
        end
        
    end
end

[U, D] = eig(W);
[~,idx] = sort(abs(diag(D)),'ascend');
U = U.';
U = U(idx,:);
U = U/sqrt(trace(U'*U));

end

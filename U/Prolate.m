function [U,harmonics] = Prolate(harmonics)
%
% function [U,harmonics] = Prolate(harmonics)
%
%
% U matrix for Prolate design.
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
            W(i,j) = (4*pi*W(i,j) + 4*pi*W(i,j)*cos(pi*W(i,j))+(pi^2*W(i,j)^2-8)*sin(pi*W(i,j)))/(pi*W(i,j)^3);
        end
        
    end
end

[U, D] = eig(W);
[~,idx] = sort(abs(diag(D)),'ascend');
U = U.';
U = U(idx,:);
U = U/sqrt(trace(U'*U));


end


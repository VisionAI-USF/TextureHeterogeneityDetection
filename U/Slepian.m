function [U,harmonics] = Slepian(harmonics,B)
%
% function [U,harmonics] = Slepian(harmonics,B)
%
%
% U matrix for Slepian design.
%
%
% INPUTS
% ------
%
% harmonics     vector of harmonics (corresponding to exp^j*harmonics*angle)
%
% B             bandwidth 
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
            W(i,j) = B;
        else
            W(i,j) = sin(B*pi*W(i,j))/(pi*W(i,j));
        end
        
    end
end

[U, D] = eig(W);
[~,idx] = sort(abs(diag(D)),'ascend');
U = U.';
U = U(idx,:);
U = U/sqrt(trace(U'*U));

end

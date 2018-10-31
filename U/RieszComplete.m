function [U,harmonics] = RieszComplete(order)
%
% function [U,harmonics] = RieszComplete(order)
%
%
% U matrix for complete Riesz design.
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


harmonics = -order:order;

lH = length(harmonics);

U = zeros(lH);
orderEven = order - mod(order, 2);
harmonicsEven = -orderEven:2:orderEven;
Ueven = zeros(length(harmonicsEven), length(harmonicsEven));
n = floor(orderEven/2);
for n1 = 0:orderEven,
    n2 = orderEven - n1;
    fact = (-1j/2)^orderEven*sqrt(factorial(orderEven)/(factorial(n1)*factorial(n2)))/(1j^n2);
    for n1b = 0:n1,
        for n2b = 0:n2,
            factb = (-1)^(n2-n2b)*factorial(n1)*factorial(n2)/(factorial(n1b)*factorial(n1-n1b)*factorial(n2b)*factorial(n2-n2b));
            heven = 2*(n1b+n2b-n);
            Ueven(harmonicsEven==heven, n1+1) = Ueven(harmonicsEven==heven, n1+1) + fact*factb;
        end
    end
end
orderOdd = order + mod(order, 2) -1;
harmonicsOdd = -orderOdd:2:orderOdd;
Uodd = zeros(length(harmonicsOdd), length(harmonicsOdd));
n = floor(orderOdd/2);
for n1 = 0:orderOdd,
    n2 = orderOdd - n1;
    fact = (-1j/2)^orderOdd*sqrt(factorial(orderOdd)/(factorial(n1)*factorial(n2)))/(1j^n2);
    for n1b = 0:n1,
        for n2b = 0:n2,
            factb = (-1)^(n2-n2b)*factorial(n1)*factorial(n2)/(factorial(n1b)*factorial(n1-n1b)*factorial(n2b)*factorial(n2-n2b));
            hodd = 2*(n1b+n2b-n)-1;
            Uodd(harmonicsOdd==hodd, n1+1) = Uodd(harmonicsOdd==hodd, n1+1) + fact*factb;
        end
    end
end
if (mod(order, 2)==0)
    for i=1:size(Ueven, 2)
        U(harmonicsEven-harmonicsEven(1)+1,i*2-1) = Ueven(:,i);
    end
    for i=1:size(Uodd, 2)
        U(harmonicsOdd-harmonicsEven(1)+1,i*2) = Uodd(:,i);
    end
else
    for i=1:size(Ueven, 2)
        U(harmonicsEven-harmonicsOdd(1)+1,i*2) = Ueven(:,i);
    end
    for i=1:size(Uodd, 2)
        U(harmonicsOdd-harmonicsOdd(1)+1,i*2-1) = Uodd(:,i);
    end
end
U = U/sqrt(2);

U = U.';

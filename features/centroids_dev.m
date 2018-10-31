function [ mu, std_val ] = centroids_dev( C )

[row, ~] = size(C);

if row==1
    mu = 0;
    std_val = 0;
    return
end


mu = mean(C);

[row,~] = size(C);

distV = zeros(1,row);

for j = 1:row
    xi = C(j,:);
    dist = sqrt(sum((xi-mu).^2));
    distV(j) = dist;
end
    mu=mean(distV);
    std_val = std(distV);

end


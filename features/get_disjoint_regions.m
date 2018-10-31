function [ result ] = get_disjoint_regions( patches )

disjoint_patches = {};

[clusters_num, row, col] = size(patches);

for j=1:clusters_num
    p = zeros(row,col);
    
    p(:,:) = patches(j,:,:);
    d_p = bwconncomp(p>0);
    
    disjoint_patches = [disjoint_patches, d_p.PixelIdxList];
end

result = zeros(length(disjoint_patches),row, col);

for j = 1:length(disjoint_patches)
    
    tmp = zeros(row,col);
    tmp(disjoint_patches{j}) = 1;
    result(j,:,:) = tmp(:,:);
    
end



end


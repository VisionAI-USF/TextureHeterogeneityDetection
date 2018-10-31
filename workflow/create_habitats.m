function [ habitats ] = create_habitats(patches, cluster_idx, mask, options)


scale_num = options.num_scales;




[row,col] = size(mask);
%habitats = cell(1,scale_num);
habitats = cell(1,1);
%for j =1:scale_num

[r,~] = size(cluster_idx{1});
if r ==1
    habitats{1} = zeros(1,512,512);
    habitats{1}(1,:,:) = patches{1}(:,:);
    return
end


for j =1:1

    cluster_num = max(cluster_idx{j});

    habitats{j} = zeros(cluster_num,row,col);

end

for scale = 1:length(cluster_idx)
    idx = cluster_idx{scale};
    X_val = [];
    X_labels = [];

    for j = 1:length(patches)

        patch = patches{j};
        stat = regionprops(patch,'centroid');
        tmp_val = [];
        tmp_labels = [];

        for k = 1:length(stat)
            tmp_val = [tmp_val;stat(k).Centroid(:,2),stat(k).Centroid(:,1)];
        end
        tmp_labels = ones(length(stat),1)*j;
        X_val = [X_val;tmp_val];
        X_labels = [X_labels;tmp_labels ];
    end
    
    msk_idx = find(mask>0);
    col_c = ceil(msk_idx/row);
    row_c = msk_idx-(col_c-1).*col;
    Y = [row_c,col_c];


    IDX = knnsearch(X_val,Y);

    for j = 1:length(IDX)
        
        habitats{scale}(idx(X_labels(IDX(j))),Y(j,1),Y(j,2))=1;
        
    end

end
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
% 
%     
%     for j = 1:scale_num
%         
%         X_c = [];
%         Y_c = [];
%         class_lable = [];
%         
%         
%         idx = cluster_idx{j};
%         cluster_num = max(cluster_idx{j});
%         d_map = zeros(cluster_num+1,row, col);
%         for k = 1:cluster_num
%             
%             patch_idx = find(idx ==k);
%             summed_patch = zeros(row,col);
%             
%             for l = 1:length(patch_idx)
%                 
%                 ppatch = patches{patch_idx(l)};
%                 
%                 coord = find(ppatch>0);
%                 col_c = ceil(coord/row);
%                 row_c = coord-(col_c-1).*col;
% 
%                 X_c = [X_c; col_c];
%                 Y_c = [Y_c; row_c];
%                 class_lable = [class_lable; ones(length(coord),1).*k];
% 
%                 summed_patch = summed_patch + ppatch;
%                 
%             end
%             
%             summed_patch = summed_patch./max(max(summed_patch));
%             
%             d_map(k+1,:,:) = summed_patch;
%         end
%         
%         data = [Y_c,X_c];
%             
%         %nb = fitcnb(data,class_lable,'DistributionNames', 'mvmn');
%         nb = fitcnb(data,class_lable,'DistributionNames', 'kernel');
%         
%         msk_idx = find(mask>0);
%         col_c = ceil(msk_idx/row);
%         row_c = msk_idx-(col_c-1).*col;
%         X = [row_c,col_c];
%         result = predict(nb,X);
%         
%         missed_clusters = [];
%         
%         for k = 1:cluster_num
%             
%             if (sum(result==k)==0)
%                 
%                 missed_clusters = [missed_clusters, k];
%                 
%             end
%             
%         end
%         
%         for k = 1:length(result)
%             
%             habitats{j}(result(k),X(k,1),X(k,2)) = 1;
%             
%         end
%         
%         for k = 1:length(missed_clusters)
%         
%             missed_idx = find(class_lable == missed_clusters(k));
%             
%             for n = 1:cluster_num
%                 for l = 1:length(missed_idx)
% 
%                     if n == missed_clusters(k)
%                         
%                         habitats{j}(missed_clusters(k),data(missed_idx(l),1),data(missed_idx(l),2)) = 1;
%                         
%                     else
%                         
%                         habitats{j}(n,data(missed_idx(l),1),data(missed_idx(l),2)) = 0;
%                         
%                     end
% 
%                 end
%             end
%         end
% 
% %         [~,ti] = max(d_map);
% %         for k = 1:cluster_num
% %             
% %             coord = find(ti==k+1);
% %             tmp = zeros(row,col);
% %             tmp(coord) = 1;
% %             
% %             habitats{j}(k,:,:) = tmp(:,:);
% %         end
%     end
%     
% end
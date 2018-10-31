function [ idx, centroids ] = cluster_texture( features, options )


[r,~] = size(features{1});

idx={};
centroids={};

if r==1
    
    idx{1} = 1;
    centroids{1} = features{1};
    return
end


Replicates = options.kmean_replicate;



rng('default')

for j = 1:1
    
    eva = evalclusters(features{j},'kmeans','gap','KList',[1:min(15,length(features{j}))]);
    cluster_num = eva.OptimalK;
    scale_features = features{j};
    
    if cluster_num>1
        [cur_idx,C] = kmedoids(scale_features, cluster_num,'Replicates',Replicates);
        idx{j} = cur_idx;
        centroids{j} = C;
    else
        idx{1} = ones(r,1);
        
        centroids{1} = mean(scale_features);
    end
    
    
end

end
    
    
    
    
    

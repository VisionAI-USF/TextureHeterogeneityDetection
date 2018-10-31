function [ features ] = nodule_classification_features(  habitat_patches, mask,cluster_centroids )



row = length(habitat_patches);
features=cell(1,row);

for j = 1:row
    patches = habitat_patches{j};
    
    [num_clusters,~,~] = size(patches);

    min_Vr = habitat_ratio_V( patches, mask, 'min' );
    max_Vr = habitat_ratio_V( patches, mask, 'max' );
    mean_Vr = habitat_ratio_V( patches, mask, 'mean' );
    median_Vr = habitat_ratio_V( patches, mask, 'median' );
    
    [mean_clusters_dist, std_clusters_dist] = centroids_dev(cluster_centroids{j});
    
    disjoint_patches = get_disjoint_regions(patches);
    
	d_min_Vr = habitat_ratio_V( disjoint_patches, mask, 'min' );
    d_max_Vr = habitat_ratio_V( disjoint_patches, mask, 'max' );
    d_mean_Vr = habitat_ratio_V( disjoint_patches, mask, 'mean' );
    d_median_Vr = habitat_ratio_V( disjoint_patches, mask, 'median' );
    
    scale.num_clusters = num_clusters;
    scale.fingerprint = cluster_centroids{j};
    
    scale.q_features.smallest_ration_v = min_Vr;
    scale.q_features.largest_region_v = max_Vr;
    scale.q_features.mean_region_v = mean_Vr;
    scale.q_features.median_region_v = median_Vr;
    
    scale.centroids_mean_dist = mean_clusters_dist;
    scale.centroids_std_dist =   std_clusters_dist;

    
    scale.q_features.disjoint_smallest_ration_v = d_min_Vr;
    scale.q_features.disjoint_largest_region_v = d_max_Vr;
    scale.q_features.disjoint_mean_region_v = d_mean_Vr;
    scale.q_features.disjoint_median_region_v = d_median_Vr;
    
    features{j} = scale;
end


end


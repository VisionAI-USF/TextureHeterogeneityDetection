function [habitats, features] = compute_features( img, mask, hv_order )
    
    options.kmean_replicate = 40;

    options.patchRadius = 6;                                                  % radius of the circular patch
    options.distCtrs = 3;                                                     % distance between the centers of the patches (controls patch overlap)
    options.harmonicsVector =hv_order;                                              % [-4,-3,-2,-1,0,1,2,3,4];                                            % number of circular harmonics
    options.num_scales = 3;                                                   % number of scales: number of iterations of the isotropic wavelet transform
    options.pyramid = 0;                                                      % 1: decimated, 0: undecimated wavelet transform
    options.align = 3;                                                        % 0: no steering, >1: moving frames built from scale = align
    options.complexType = 'abs';                                              % 'abs' is recommended if align = 0. 'concatenated' should be used otherwise
    options.cropSupport = 0;


    [tex_features, patches] = nodule_texture_features( img, mask, options );

    [cluster_idx, cluster_centroids] = cluster_texture(tex_features, options);

    habitat_patches = create_habitats(patches,cluster_idx,mask,options);

    features = nodule_classification_features( habitat_patches, mask,cluster_centroids);
    habitats = habitat_patches{1};
    features = features{1};

end

function [ nodule_feature, patches_set ] = nodule_texture_features( img, mask, options )



% parameters for texture analysis
patchRadius = options.patchRadius;                                                 % radius of the circular patch
distCtrs = options.distCtrs;                                                    % distance between the centers of the patches (controls patch overlap)
harmonicsVector = options.harmonicsVector;                                            % number of circular harmonics
num_scales = options.num_scales;                                                   % number of scales: number of iterations of the isotropic wavelet transform
pyramid = options.pyramid;                                                      % 1: decimated, 0: undecimated wavelet transform
align = options.align;                                                        % 0: no steering, >1: moving frames built from scale = align
complexType = options.complexType;                                              % 'abs' is recommended if align = 0. 'concatenated' should be used otherwise
cropSupport = options.cropSupport;                                                  % crop the mask based on the spatial support of the wavelet to avoid the influence of surrounding objects

nodule_feature = {};
patches_set = {};
mask_bool = mask>0;
patches_ready = 0;

% extract circular harmonic wavelet (CHW) coefficientstruth
Qu1 = SWMtextureAnalysis(img,harmonicsVector,num_scales,pyramid,align);


features = [];
p_idx = 1;

idx = find(max(mask)>0);
x_min = min(idx);
x_max = max(idx);

idx = find(max(mask')>0);
y_min = min(idx);
y_max = max(idx);


min_area = 56.5;



for x=x_min:distCtrs:x_max+distCtrs
    for y=y_min:distCtrs:y_max+distCtrs

        patch = getCircularPatch(img,x,y,patchRadius);
        patch = patch & mask_bool;
        if (sum(sum(patch))<min_area)
            continue
        end
%         figure;imshow(patch,[]);

        feat = averageChannelAbsInMask(Qu1,patch,complexType,harmonicsVector,pyramid,cropSupport);

        features = [features;feat];
        patches_set{p_idx} = patch; 
        p_idx= p_idx + 1;
        
    end
end

if isempty(features)
%     x = mean(find(max(mask)>0));
%     y = mean(find(max(mask')>0));
%     
%     patch = getCircularPatch(img,x,y,patchRadius);
    feat = averageChannelAbsInMask(Qu1,mask,complexType,harmonicsVector,pyramid,cropSupport);
    
    features = [features;feat];
    patches_set{p_idx} = mask>0; 
    p_idx= p_idx + 1;
    
end


patches_ready = 1;
nodule_feature{1} =features;

end
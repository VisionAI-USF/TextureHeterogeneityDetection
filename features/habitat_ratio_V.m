function [ Vr ] = habitat_ratio_V( Patches, V, type )

    Vr = 0;

    area = sum(sum(V>0));
    
    [cluster_num,~,~] = size(Patches);
    
    Vr_array = zeros(1,cluster_num);
    
    for j =1:cluster_num
        
        patch_area = sum(sum(Patches(j,:,:)>0));
        Vr_array(j) = patch_area/area;
        
    end
    
    switch type
       case 'min'
            Vr = min(Vr_array);
       case 'max'
            Vr = max(Vr_array);
        case 'mean'
            Vr = mean(Vr_array);
        case 'median'
            Vr = median(Vr_array);
       otherwise
          disp('wrong type argument')
    end

    
end


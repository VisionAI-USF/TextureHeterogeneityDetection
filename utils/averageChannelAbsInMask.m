function absValues=averageChannelAbsInMask(Qu,mask,complexType,harmonicsVector,pyramid,cropSupport)
%
% function absValues=averageChannelAbsInMask(Qu,mask,complexType,pyramid)
%
%
% compute mean of the abs of the CHW within an image region defined by a binary mask
%
% INPUTS
% ------
%
% Qu                      cell array of wavelet coefficients per scale.
%                               Qu{i}.channels(j,:,:) is the array of coefficients in the jth
%                               channel in scale i, with additional field
%
% mask                    a binary image with the same size as Qu{1}.channels(1,:,:)
%                               with ones in the region of interest and zeros elsewhere
%
% complexType             specify which measure to get from the complex
%                               coefficients: valid values are:
%                               'real', 'imag', 'abs', 'angle', and 'concatenated'
%
% harmonicsVector         vector of circular harmonics
%
% pyramid                 use false for undecimated wavelet transform
%
% cropSupport             crop the mask based on the spatial support of the wavelet to avoid the influence of surrounding objects
%
% OUTPUTS
% -------
%
% absValues   vector of values organized as:
%                     [channel1scale1 channel2scale1 ...
%                      channel1scale2 channel2scale2 ...] 
%
% -------------------------------------------------------------------
%
% Adrien Depeursinge, adrien.depeursinge@epfl.ch
% EPFL, Biomedical Imaging Group (BIG), Lausanne, Switzerland
% HES-SO Valais, MedGIFT, Institute of Information Systems, Sierre, Switzerland
% -------------------------------------------------------------------
%
% REFERENCES:
% [1] A. Depeursinge, Z. Puspoki, J.P. Ward, M. Unser,
%       "Steerable Wavelet Machines (SWM): Learning Moving Frames for
%       Texture Classification", in press.
%
% [2] M. Unser and N. Chenouard, "A Unifying Parametric Framework for 2D Steerable
%       Wavelet Transforms", SIAM J. Imaging Sci., vol. 6., pp 102-135, 2013.
%
% -------------------------------------------------------------------

mask=double(mask);
absValues=[];
for iterScale=1:size(Qu,1)
    
    if cropSupport
        
        se = strel('disk', round(2.5*2^(iterScale-1)));  % estimated with the Simoncelli isotropic wavelet type
        maskEroded = imerode(mask,se);
        idxNonZeros= maskEroded(:)~=0;
    else
        idxNonZeros= mask(:)~=0;
    end;
    k=sum(idxNonZeros,1);
    if(k==0)
        warning('The mask is empty. If you used cropSupport=true, the number of scales used might be too large when compared to the size of your mask.')
    end;

    for iterChannel=1:size(harmonicsVector,2)

        if strcmpi(complexType,'concatenated')

            subband=squeeze(real(Qu{iterScale}.channels(iterChannel,:,:)));
            c=subband(idxNonZeros);
            absValReal=sum(abs(c))/k;

            if harmonicsVector(iterChannel)~=0 % harmonic 0 is always real
                subband=squeeze(imag(Qu{iterScale}.channels(iterChannel,:,:)));
                c=subband(idxNonZeros);
                absValImag=sum(abs(c))/k;
            else
                absValImag=[];
            end;

            absValues=[absValues absValReal absValImag];
            
        elseif strcmpi(complexType,'angle') % no abs with angle!
            subband=squeeze(angle(Qu{iterScale}.channels(iterChannel,:,:)));
            c=subband(idxNonZeros);
            absVal=sum(c)/k;
            absValues=[absValues absVal];
        else
            switch complexType
                case 'real'
                    subband=squeeze(real(Qu{iterScale}.channels(iterChannel,:,:)));
                case 'imag'
                    subband=squeeze(imag(Qu{iterScale}.channels(iterChannel,:,:)));
                case 'abs'
                    subband=squeeze(abs(Qu{iterScale}.channels(iterChannel,:,:)));    
                otherwise
                    error('invalid complex type.'); 
            end;
            
            if ~(harmonicsVector(iterChannel)==0 && strcmpi(complexType,'imag')) % harmonic 0 is always real
                c=subband(idxNonZeros);
                absVal=sum(abs(c))/k;
                absValues=[absValues absVal];
            end;
        end;
    end;
    if pyramid
        mask=mask(1:2:end,1:2:end);
    end;
end;

function PlotWaveletCoeffs(Q,type)
%
% function PlotWaveletCoeffs(Q,type)
%
%
% plot wavelet coefficients.
%
%
% INPUTS
% ------
%
% Q             cell array of wavelet coefficients per scale
%
% type          one of the two strings 'allinone' (to plot each channel and
%               scale in a subplot in a single figure) or 'perchannel' (to plot
%               each channel as a spiral of coefficients in a separate figure);
%               optional (defaults to 'allinone')
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
% Zs. Puspoki (zsuzsanna.puspoki@epfl.ch)
%
% Biomedical Imaging Group
% Ecole Polytechnique Federale de Lausanne (EPFL)

if ~exist('type','var')
    type = 'allinone';
end

num_scales = length(Q);
num_chan   = size(Q{1}.channels,1);

switch type

    case 'allinoneAbs'
        figure;
        for i=1:num_scales    
            ran = [min(abs(Q{i}.channels(:))),max(abs(Q{i}.channels(:)))];
            for j=1:num_chan
                subplot(num_scales+1,num_chan,(i-1)*num_chan + j);

                imagesc(abs(squeeze(Q{i}.channels(j,:,:))),ran);
                title(sprintf('scale %d, chan %d',i,j));
                axis image;
                axis square;
                axis off;
                %colorbar;
            end
        end
        suptitle('wavelet coeff magnitudes, all-in-one');

        ran = [min(abs(Q{end}.channels_approx(:))),max(abs(Q{end}.channels_approx(:)))];
        for j=1:num_chan
            subplot(num_scales,num_chan,(num_scales-1)*num_chan + j);

            imagesc(abs(squeeze(Q{end}.channels_approx(j,:,:))),ran);
            title(sprintf('scale %d, chan %d',num_scales,j));
            axis image;
            axis square;
            axis off;
            %colorbar;
        end

        case 'allinoneReal'
        figure;
        for i=1:num_scales    
            ran = [min(real(Q{i}.channels(:))),max(real(Q{i}.channels(:)))];
            for j=1:num_chan
                
                subplot(num_scales+1,num_chan,(i-1)*num_chan + j);
                imagesc(real(squeeze(Q{i}.channels(j,:,:))),ran);
                title(sprintf('scale %d, chan %d',i,j));           
                axis image;
                axis square;
                axis off;
                %colorbar;
            end
        end
        suptitle('wavelet coeff real, all-in-one');
        
        ran = [min(real(Q{end}.channels_approx(:))),max(real(Q{end}.channels_approx(:)))];
        for j=1:num_chan
            subplot(num_scales,num_chan,(num_scales-1)*num_chan + j);

            imagesc(real(squeeze(Q{end}.channels_approx(j,:,:))),ran);
            title(sprintf('scale %d, chan %d',num_scales,j));
            axis image;
            axis square;
            axis off;
            %colorbar;
        end
        
        case 'allinoneImag'
        figure;
        for i=1:num_scales    
            ran = [min(imag(Q{i}.channels(:))),max(imag(Q{i}.channels(:)))];
            for j=1:num_chan
                
                subplot(num_scales+1,num_chan,(i-1)*num_chan + j);
                imagesc(imag(squeeze(Q{i}.channels(j,:,:))),ran);
                title(sprintf('scale %d, chan %d',i,j));           
                axis image;
                axis square;
                axis off;
                %colorbar;
            end
        end
        suptitle('wavelet coeff imag, all-in-one');
        
        ran = [min(imag(Q{end}.channels_approx(:))),max(imag(Q{end}.channels_approx(:)))];
        for j=1:num_chan
            subplot(num_scales,num_chan,(num_scales-1)*num_chan + j);

            imagesc(imag(squeeze(Q{end}.channels_approx(j,:,:))),ran);
            title(sprintf('scale %d, chan %d',num_scales,j));
            axis image;
            axis square;
            axis off;
            %colorbar;
        end
        
    case 'perchannel'
        for j=1:num_chan
            C = cell(num_scales+1,1);
            for i=1:num_scales
                C{i} = squeeze(Q{i}.channels(j,:,:));
            end
            C{end} = squeeze(Q{end}.channels_approx(j,:,:));

            M = waveletspiral(C);

            figure;
            imagesc(abs(M(1:end/2,1:3*end/4))); 
            axis image;
            axis off;
            title(sprintf('wavelet coeff magnitudes, channel %d',j));
            colorbar;
        end

    otherwise
        error('invalid plot type.');
end

drawnow;


function M = waveletspiral(C,dir)

if ~exist('dir','var')
    dir = 1;
end

if isempty(C)
    M = 0;
    return;
end

sC = size(C{1});
M = nan(2*sC);

switch dir
    case 0
        M(1:sC(1),1:sC(2)) = C{1};
        M(sC(1)+1:2*sC(1),1:sC(2)) = waveletspiral(C(2:end),1);
    case 1
        M(1:sC(1),1:sC(2)) = C{1};
        M(1:sC(1),sC(2)+1:2*sC(2)) = waveletspiral(C(2:end),2);
    case 2
        M(sC(1)+1:2*sC(1),1:sC(2)) = C{1};
        M(1:sC(1),1:sC(2)) = waveletspiral(C(2:end),3);
    case 3
        M(1:sC(1),sC(2)+1:2*sC(2)) = C{1};
        M(1:sC(1),1:sC(2)) = waveletspiral(C(2:end),0);
end

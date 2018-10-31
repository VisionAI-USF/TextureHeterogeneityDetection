clearvars
close all
clc

addpath U
addpath Wavelet
addpath Wavelet/Radial


%% Initialization 

imfile   = 'cameraman.png';  % image to process
A = double(imread(imfile));
sA = size(A);

htype = 'Simoncelli'; % isotropic wavelet type (string), one of 'Simoncelli', 'Meyer', 'Papadakis' or 'Shannon'

Utype = 'CircularHarmonic';  %steerable construction type (string). Available constructions are 
%               'Gradient', 'Monogenic', 'Hessian', 'CircularHarmonic',
%               'Prolate', 'ProlateUniSided', 'Slepian', 'RieszEven',
%               'RieszOdd', 'RieszComplete', 'SimoncelliEven', 'SimoncelliOdd',
%               'SimoncelliComplete', 'UserDefined'.

Uparams.harmonics = -1:1:1; % For 'RieszEven', 'RieszOdd', 'RieszComplete', 'SimoncelliEven', 'SimoncelliOdd', 
                            %'SimoncelliComplete' - wavelet order
                            
Uparams.B = .1;     % For 'Slepian' - bandwidth 
num_scales = 1;     % number of scales
steerangle = 0;  % angle by which to steer the wavelet (optional, defaults to 0)

equiangular = false; % whether to construct equiangular wavelets from the first channel of Utype
Mequiangular = 9;   % number of equiangular channels

% init wavelet transform
[hafun,hdfun,hfun,U,harmonics] = Init(htype,Utype,Uparams);

if equiangular
    [U,harmonics] = EquiAng(harmonics,U(1,:),Mequiangular); % Equiangular design
end


% plot wavelets

for j=1:size(U,1)
    PlotWavelet(hfun,U(j,:),harmonics,steerangle);
    suptitle(sprintf('channel %d',j));
end
% PlotWaveletScales(hafun,hdfun,hfun,U,harmonics,sA,num_scales,steerangle);

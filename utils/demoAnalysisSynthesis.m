clearvars
close all
clc

% addpath U
% addpath Wavelet
% addpath Wavelet/Radial


%% Initialization 

imfile   = 'cameraman.png';  % image to process
A = double(imread(imfile));

htype = 'Simoncelli'; % isotropic wavelet type (string), one of 'Simoncelli', 'Meyer', 'Papadakis' or 'Shannon'

Utype = 'Monogenic'; %steerable construction type (string). Available constructions are 
%               'Gradient', 'Monogenic', 'Hessian', 'CircularHarmonic',
%               'Prolate', 'ProlateUniSided', 'Slepian', 'RieszEven',
%               'RieszOdd', 'RieszComplete', 'SimoncelliEven', 'SimoncelliOdd',
%               'SimoncelliComplete', 'UserDefined'.

Uparams.order = 4;  % For 'RieszEven', 'RieszOdd', 'RieszComplete', 'SimoncelliEven', 'SimoncelliOdd', 
                    % 'SimoncelliComplete' - wavelet order

Uparams.harmonics = -4:2:4; % For 'CircularHarmonic', 'Prolate', 'ProlateUniSided', 'Slepian', 
                            % 'UserDefined' - vector of harmonics for the chosen design and parameters
                           
Uparams.B = 0.1;    % For 'Slepian' - bandwidth 
num_scales = 4;     % number of scales
prefilter = false;   % whether to prefilter the image (logical, defaults to false)
pyramid = 0;
equiangular = false; % whether to construct equiangular wavelets from the first channel of Utype
Mequiangular = 5;   % number of equiangular channels

% init wavelet transform
[hafun,hdfun,hfun,U,harmonics] = Init(htype,Utype,Uparams);

if equiangular
    [U,harmonics] = EquiAng(harmonics,U(1,:),Mequiangular); % Equiangular design
end


%% Wavelet analysis

% steerable analysis
[Q,res] = CompleteAnalysis(A,num_scales,hafun,hdfun,harmonics,prefilter,pyramid);

% apply U
Qu = Projection(Q,U);

% plot coefficients
% PlotWaveletCoeffs(Qu,'allinoneAbs');
% PlotWaveletCoeffs(Qu,'perchannel');


%% Reconstruction

% apply U'
Qr = Projection(Qu,U');

% steerable synthesis
Ar = real(CompleteSynthesis(Qr,hafun,hdfun,harmonics,res,pyramid));

% plot reconstruction and error
figure;
imagesc(Ar);
axis image;
axis square;
axis off;
colormap gray;
colorbar;
title('reconstruction');

figure;
imagesc(A-Ar);
axis image;
axis square;
axis off;
colormap gray;
colorbar;
title('error');

function [Qu, theta0OptMap] = SWMtextureAnalysis(A,harmonicsVector,num_scales,pyramid, align, weightsAlign)
%
% function Qu = SWMTextureAnalysis(A,harmonicsVector,nbOfScales,pyramid, align, weightsAlign)
%
%
% steerable wavelet machines.
%
%
% INPUTS
% ------
%
% A                                 image to process
%
% harmonicsVector      number of harmonics, example: 0:1:5
%
% num_scales               number of scales: number of iterations of the isotropic wavelet transform
%
% pyramid                     use false for undecimated wavelet transform
%
% align                          0: no steering, >1: moving frames built from scale=align
%
% weightsAlign            optional: provide harmonic-wise weights for aligning: yields learned moving frames
%
% OUTPUTS
% -------
%
% Qu             cell array of wavelet coefficients per scale.
%                   Qu{i}.channels(j,:,:) is the array of coefficients in the jth
%                   channel in scale i, with additional field
%               
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


%% Initialization 
htype = 'Simoncelli'; % isotropic wavelet type (string), one of 'Simoncelli', 'Meyer', 'Papadakis' or 'Shannon'

Utype = 'CircularHarmonic'; %steerable construction type (string). Available constructions are 
%               'Gradient', 'Monogenic', 'Hessian', 'CircularHarmonic',
%               'Prolate', 'ProlateUniSided', 'Slepian', 'RieszEven',
%               'RieszOdd', 'RieszComplete', 'SimoncelliEven', 'SimoncelliOdd',
%               'SimoncelliComplete', 'UserDefined'.

% Uparams.order = 4;  % For 'RieszEven', 'RieszOdd', 'RieszComplete', 'SimoncelliEven', 'SimoncelliOdd', 
%                     % 'SimoncelliComplete' - wavelet order

Uparams.harmonics = harmonicsVector; % For 'CircularHarmonic', 'Prolate', 'ProlateUniSided', 'Slepian', 
                            % 'UserDefined' - vector of harmonics for the chosen design and parameters
                           
prefilter = false;   % whether to prefilter the image (logical, defaults to false)

% init wavelet transform
[hafun,hdfun,~,U,harmonics] = Init(htype,Utype,Uparams);


%% Wavelet analysis

% steerable analysis
[Q,~] = CompleteAnalysis(A,num_scales,hafun,hdfun,harmonics,prefilter,pyramid);

% apply U
Qu = Projection(Q,U);

if align > 0

    if nargin==5
        weightsAlign=ones(size(harmonicsVector));
    elseif size(weightsAlign,1)>size(harmonicsVector,2) % keep weights from the chosen scale
        weightsAlign=weightsAlign(size(harmonicsVector,2)*(align-1)+1:size(harmonicsVector,2)*(align-1)+size(harmonicsVector,2));
    end;
    
    % find the angle that maximizes the sum of Re(w'*blockDiagSteerMat*channelCoeffs)
    stepTheta=0.01;
    domainTheta0=0:stepTheta:2*pi;
    
    steeredCoeffsSumReal=zeros([numel(squeeze(Qu{align}.channels(1,:,:))) size(domainTheta0,2)]);
    for iterHarmonics=1:size(Uparams.harmonics,2)
		if Uparams.harmonics(iterHarmonics) == 0
			% don't bother calculating for harmonic zero, since it is
			% isotropic
			continue; 
		end

        harm=Uparams.harmonics(iterHarmonics);
        
        QuReal=real(squeeze(Qu{align}.channels(iterHarmonics,:,:)));
        QuImag=imag(squeeze(Qu{align}.channels(iterHarmonics,:,:)));

		
        steeredCoeffsSumReal = steeredCoeffsSumReal + weightsAlign(iterHarmonics) ...
			*[QuReal(:)  QuImag(:)] * [cos(harm*domainTheta0); sin(harm*domainTheta0)];
    end;

    % create angle map from max
    [~,idx]=max(steeredCoeffsSumReal,[],2);
	idx = reshape(idx, size(squeeze(Qu{align}.channels(1,:,:))));
    theta0OptMap=domainTheta0(idx); 

    % now steer everyone from every scale
    for iterScale=1:size(Qu,1)
        for iterHarmonics=1:size(Uparams.harmonics,2)
            
            harm=Uparams.harmonics(iterHarmonics);

            realQu= cos(harm*theta0OptMap).*squeeze(real(Qu{iterScale}.channels(iterHarmonics,:,:))) + ...
                           sin(harm*theta0OptMap).*squeeze(imag(Qu{iterScale}.channels(iterHarmonics,:,:)));

            imagQu= -sin(harm*theta0OptMap).*squeeze(real(Qu{iterScale}.channels(iterHarmonics,:,:))) + ...
                               cos(harm*theta0OptMap).*squeeze(imag(Qu{iterScale}.channels(iterHarmonics,:,:)));

            Qu{iterScale}.channels(iterHarmonics,:,:) = realQu + 1i*imagQu;
        end;
    end;
else
	theta0OptMap = zeros(size(A));
end;





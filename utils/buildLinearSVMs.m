function [w,model,minFeat,maxFeat]=buildLinearSVMs(features1,features2)
%
% function [w,model,minFeat,maxFeat]=buildLinearSVMs(features1,features2)
%
%
% learns maximum margin hyperplane
% IMPORTANT: It requires compiling the libsvm wrapper for matlab: 
% execute onces make.m in ./SteerableWaveletMachines/libsvm/matlab/
%
%
% INPUTS
% ------
%
% features1                                 matrix containing the features of class 1: 
%                                                  lines=instances and columns=variables
%
% features2                                 matrix containing the features of class 2
%
% OUTPUTS
% -------
%
% w                                              direction vector of the hyperplane
%  
% model                                      libsvm model object for further use in svmpredict
%
% minFeat                                   minimum feature values for nomalizing test variables in [0,1]
%
% maxFeat                                  maximum feature values for nomalizing test variables in [0,1]
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
% -------------------------------------------------------------------


% SVM parameters for libsvm
svm_type = 0; %  C-SVC
kernel_type = 0; % 0: linear kernel for weights
cost = 10^2; % default value

options = ['-s ', num2str(svm_type),...
' -t ', num2str(kernel_type),...
' -c ', num2str(cost)];

minFeat = nan;
maxFeat = nan;

classesTrain=[ones(size(features1,1),1);-ones(size(features2,1),1)];
featuresTrain=[features1;features2];

% rescale individual features to [0,1]
minFeat = min(featuresTrain,[],1);
featuresTrain = featuresTrain-repmat(minFeat,[size(featuresTrain,1) 1]);
maxFeat = max(featuresTrain,[],1);
for iterFeat=1:size(maxFeat,2)
    if maxFeat(iterFeat) == 0
        maxFeat(iterFeat) = 1;
    end;
end;
featuresTrain = featuresTrain./repmat(maxFeat,[size(featuresTrain,1) 1]);

model = svmtrain(classesTrain,featuresTrain,options); % libSVMs' svmtrain()

w = model.SVs'*model.sv_coef; % primal-dual relationship
b = -model.rho;
if model.Label(1) == -1
  w = -w;
  b = -b;
end;
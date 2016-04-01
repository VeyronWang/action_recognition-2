clear
clc
tic
fprintf('initialization\n')
load('./data/HMDB51_info.mat');
addpath(genpath('./function/'));
run('../lib/vlfeat-0.9.20/toolbox/vl_setup.m')
toc

fprintf('feature extraction\n')
sampleDescNum = (2.56e5)*2;
sampleFileNum = 256;
sampleType = 'sampleForKind';%sampleRondom,sampleForKind
desc = extract_desc(dataset,sampleFileNum,sampleDescNum,sampleType);
toc

fprintf('feature pre-processing\n');
pcaDim = size(desc,1)/2;
[desc,W,M] = pcaWhiten(desc,pcaDim);
toc

fprintf('codebook generation and feature encoding\n')
numClusters = 512;

%fv
[Mean,covr,priors] = vl_gmm(desc,numClusters);
feature = encoding_fv(dataset,M,W,Mean,covr,priors);

% % vlad
% centers = vl_kmeans(desc,numClusters);
% feature = encoding_vlad(dataset,M,W,centers);
% toc

fprintf('SVM\n')
accFoldTest = svm_vl(dataset,feature);
toc

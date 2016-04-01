function [X,W,M] = pcaWhiten(X,K,epsilon)
% pca and pcawhiten
% X :data
% K :pca dim
% W :pca and whiten matrix
% M :mean
if ~exist('epsilon','var')
    epsilon = 0;
end
M = mean(X,2);
X = X - repmat(M,1,size(X,2));
C = X*X'/size(X,2);
[E, D] = eig(C);
d = diag(D); 
[d,order] = sort(d,'descend');
E = E(:,order);

% E = E * diag(1./sqrt(abs(d) + epsilon));
% W = E(:,1:K);
% X = W'*X;

L = diag(1./sqrt(abs(d) + epsilon));
E = E(:,1:K);
L = L(1:K,1:K);
W = E*L';
X = W'*X;

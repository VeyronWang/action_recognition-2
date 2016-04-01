function [feature] = encoding_vlad(dataset,M,W,centers)
numClusters = size(centers,2);
feature = [];
for i = 1:numel(dataset.files)
    [~, name, ~] = fileparts(dataset.files{i});
    fprintf('%d:%s\n',i,name);
    desc = load(fullfile(dataset.filePath,strcat(name,'.mat')),'hog');
    desc = desc.hog;    
    desc = desc - repmat(M,1,size(desc,2));
    desc = W'*desc;
    kdtree = vl_kdtreebuild(centers);
    nn = vl_kdtreequery(kdtree,centers,desc);
    assignments = zeros(numClusters,size(desc,2));
    assignments(sub2ind(size(assignments),nn,1:length(nn))) = 1;
    enc = vl_vlad(desc,centers,single(assignments),'NormalizeComponents');
    feature = [feature,enc];
end

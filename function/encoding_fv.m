function [feature] = encoding_fv(dataset,M,W,Mean,covr,priors)
feature = [];
for i = 1:numel(dataset.files)
    [~, name, ~] = fileparts(dataset.files{i});
    fprintf('%d:%s\n',i,name);
    desc = load(fullfile(dataset.filePath,strcat(name,'.mat')),'hog');
    desc = desc.hog;    
    desc = desc - repmat(M,1,size(desc,2));
    desc = W'*desc;
    enc = vl_fisher(desc,Mean,covr,priors,'Improved');
    feature = [feature,enc];
end

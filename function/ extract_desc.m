function [sampleDesc] = extract_desc(dataset,sampleFileNum,sampleDescNum,sampleType)
fileList = dir(fullfile(dataset.filePath,'*.mat'));
switch sampleType
    case 'randomSample'
        sampleFile = randsample(fileList,sampleFileNum);
    case 'sampleForKind'
        numOfEachKind = ceil(sampleFileNum/numel(dataset.kinds));
        sampleFile = [];
        for i = 1:numel(dataset.kinds)
            file = fileList(logical(dataset.labels == i));
            sampleFile = [sampleFile;randsample(file,numOfEachKind)];
        end
        sampleFile = randsample(sampleFile,sampleFileNum);
end
sampleDesc = [];
for i = 1:sampleFileNum
    fprintf('.');
    desc = load(fullfile(dataset.filePath,sampleFile(i).name));    
    replacement = false;
    if size(desc.hog,2) < sampleDescNum/sampleFileNum
        replacement = true;
    end
    desc = desc.hog;
    sampleDesc = [sampleDesc,desc(:,randsample(size(desc,2),sampleDescNum/sampleFileNum,replacement))];
end

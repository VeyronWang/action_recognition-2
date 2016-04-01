function [accFoldTest] = svm_vl(dataset,feature)
fid = fopen('./result/result.txt','w');
fprintf(fid,'%s:\n',datestr(now));
accFoldTest = zeros(dataset.numFold, 1);
for iFold = 1 : dataset.numFold
    trainX = feature(:,dataset.indexTrain(:, iFold));
    trainY = dataset.labels(dataset.indexTrain(:, iFold));
    testX = feature(:,dataset.indexTest(:, iFold));
    testY = dataset.labels(dataset.indexTest(:, iFold));
    normM = mean(trainX, 2);
    normV = sqrt(var(trainX, [], 2) + 0.01);
    trainX = bsxfun(@rdivide, bsxfun(@minus, trainX, normM), normV);
    testX = bsxfun(@rdivide, bsxfun(@minus, testX, normM), normV);
    svmW = cell(numel(dataset.kinds), 1);
    svmB = cell(numel(dataset.kinds), 1);
    parfor ik = 1 : numel(dataset.kinds)
        trainYY = -ones(size(trainY), 'like', trainY);
        trainYY(trainY==ik) = 1;
        [svmW{ik}, svmB{ik}, ~] = vl_svmtrain(trainX, trainYY, 1e-4, ...
            'Epsilon', 1e-4);
    end
    svmW = cell2mat(svmW');
    svmB = cell2mat(svmB');
    svmScore = bsxfun(@plus, testX' * svmW, svmB);
    [~, predictY] = max(svmScore, [], 2);
    testAcc = sum(predictY==testY) / numel(testY);
    fprintf(fid,'Fold %d: Test Acc=%2.3f%% \n', iFold, testAcc*100);
    accFoldTest(iFold) = testAcc;
end
fprintf(fid,'Final: Test Acc=%2.3f%% \n', sum(accFoldTest)/dataset.numFold*100);
fclose(fid);

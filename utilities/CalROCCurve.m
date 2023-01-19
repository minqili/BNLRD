function [TPR, FPR] = CalROCCurve(algPath, algSuffix, gtPath, gtSuffix, thresholds, color)    
    algFiles = dir(fullfile(algPath, strcat('*', algSuffix)));
    files_GT=imdir(gtPath);
    
    imgTPR = zeros(length(files_GT), length(thresholds));
    imgFPR = zeros(length(files_GT), length(thresholds));
%     parfor i = 1:length(files_GT)
    for i = 1:length(files_GT)
        algImgName = algFiles(i).name;
        gtImgName = strrep(algImgName, algSuffix, gtSuffix);
        if strfind( algImgName(1:strfind(algImgName,'.')-1), gtImgName(1:strfind(gtImgName,'.')-1) )
            % get ground truth
            gtName = files_GT(i).name;
            GT = im2double(imread(fullfile(gtPath, gtName)));
            % get foreground map
            FG = im2double(imread(fullfile(algPath,algImgName)));              
            % compute precision and recall
            [imgTPR(i,:), imgFPR(i,:)] = CalROC(FG, GT, thresholds);
        else
            error('Img name is mismatching.');
        end
    end
    TPR = mean(imgTPR, 1);
    FPR = mean(imgFPR, 1);

    if ~strcmp(color, '0')
        figure;
        plot(FPR, TPR, color, 'linewidth', 2);
    end
    
end
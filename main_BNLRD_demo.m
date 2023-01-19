%============================================
% This demo shows parts of the fabric defect detection results by the algorithm from the paper:
% "Fabric Defect Detection based on Bayesian  Non-negative Low-rank Decomposition".
% Verison: 1.0
% Date : 14/12/2022
% Author  : Minqi Li
% Tested on MATLAB 2018a
%============================================

clear;  clc;
close all;

addpath('.\data');
addpath(genpath('.\code'));
addpath(genpath('.\utilities'));
addpath('.\results');


method= 'BNLRDs'; 
Text_type = 'star'; 
Fabric_type = 'All_star' % All_star 'BrokenEnd' 'Hole' 'NettingMultiple' 'ThickBar' 'ThinBar'    %% L3  Knots
Fabric_type_GT = [Fabric_type '_GT'];

%% Path set 
inputImgPath= ['./data/HongKong/star-patterned_fabric_with_groundtruth/'  Fabric_type];    
inputImgPath_GT=['./data/HongKong/star-patterned_fabric_with_groundtruth/'  Fabric_type_GT]; 

data_path=pwd;
resSalPath =[data_path '\results\' Text_type '\' method '\' Fabric_type];
resSalPath2 =[data_path '\results\results_salmap\' Text_type];

%% Test images 
imgFiles = imdir(inputImgPath);
imgFiles_GT = imdir(inputImgPath_GT);

for indImg = 1:length(imgFiles)/2      
    imgPath = fullfile(inputImgPath, imgFiles(indImg).name);
    img.RGB = imread(imgPath);
    img.name = imgPath((strfind(imgPath,'\')+1):end);
    img1 = img.RGB;
    
    imgPath_GT = fullfile(inputImgPath_GT, imgFiles_GT(indImg).name);
    img_GT= imread(imgPath_GT);
    smapName = imgFiles(indImg).name;

    paras.supersize=11;  
    paras.k=27;

     salMap = ml_BNLD_simple(img1,paras); 
    
    Low_map=double(img1(:,:,1));
    if (max(Low_map(:))>1)
        Low_map=Low_map/255;
    end
    salMap=salMap/max(salMap(:));

    figure;
    subplot(2,2,1);imshow(img.RGB,[]);title('Input RGB Image'); 
    subplot(2,2,2);imshow(img_GT,[]);title('Ground trueth'); 
    subplot(2,2,3);imshow(salMap,[]);title('Defect Map of Our Method');         

    salPath = fullfile(resSalPath, [Fabric_type, '_', smapName]);  
    imwrite(salMap,salPath);          
    T=2*graythresh(salMap); 

    salMap_vec=salMap(:);
    [s_value, s_list]=sort(salMap_vec,'ascend');
    
    defects=im2bw(salMap,T);
    subplot(2,2,4);  
    imshow(defects);
    
    title('Defects of Our Method'); 
    salPath = fullfile(resSalPath2, [method, '_', Text_type, '_', Fabric_type,  int2str(indImg), 'b','.bmp']);  
    imwrite(defects,salPath);   
end 
    

%% Evaluate saliency map
resPath =[data_path '\figure'];
gtPath =[inputImgPath '_GT'];
gtSuffix = '.bmp';
IM0= [method, '_', Text_type, '_', Fabric_type, '_'];

%% Compute PR curve
[rec, pre] = DrawPRCurve(resSalPath, '.bmp', gtPath, gtSuffix, true, true, 'r');
PRPath = fullfile(resPath, [IM0 'PR.mat']);
save(PRPath, 'rec', 'pre');
fprintf('The precison-recall curve is saved in the file: %s \n', resPath);
title(' PRCurve ');

%% Compute ROC curve
thresholds = [0:1:255]./255;
[TPR, FPR] = CalROCCurve(resSalPath, '.bmp', gtPath, gtSuffix, thresholds, 'r');    
ROCPath = fullfile(resPath, [IM0 'ROC.mat']);
save(ROCPath, 'TPR', 'FPR');
fprintf('The ROC curve is saved in the file: %s \n', resPath);
title(' ROC curve ');

end_code=1


  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
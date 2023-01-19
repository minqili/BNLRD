% function featureimg = my_ExtractFeature(img)
function [feature_gabor53    feature_img_gabor] = my_GaborFeature(img, sup)

%path(path, './matlabPyrTools');
%path(path, './matlabPyrTools/MEX');
%path(path, './edison_matlab_interface');

[height,width,channel] = size(img);
if channel <3
    img0=img;
    img(:,:,2)=img0;
    img(:,:,3)=img0;
end
dim = 53;
featureimg = zeros(height,width,dim);
if max(img(:)<1.1)
img = img.*255;
end
pos = 1;
%% Color
img1 = double(img);
img2 = rgb2hsv(double(img));
featureimg(:,:,pos:pos+2) = img1;
featureimg(:,:,pos+3) = (img2(:,:,1)-0.5).*255;
featureimg(:,:,pos+4) = img2(:,:,2).*255;

pos = pos+5;
%% Steerable Pyramid
grayimg = double(rgb2gray(uint8(img)));
[pyr,pind] = buildSpyr(grayimg,3,'sp3Filters');
pyramids = getSpyr(pyr,pind);
pyrNum = size(pyramids,2);
for n = 1:pyrNum-1
    pyrImg = imresize(pyramids{n},[height, width], 'bicubic');
    for i = 1:height
        for j = 1:width   
            featureimg(i,j,pos) = pyrImg(i,j);
        end
    end
    pos = pos+1;
end
%% gabor filter
scales = 3;
directions = 12;
[EO, BP] = gaborconvolve(grayimg, scales, directions, 6,2,0.65);

for wvlength = 1:scales
    for angle = 1:directions
        Aim = abs(EO{wvlength,angle});
        maxres = max(Aim(:));
        for i = 1:height
            for j = 1:width
                featureimg(i,j,pos) = Aim(i,j)/maxres*255;
            end
        end
        pos = pos+1;
    end
end
% -----------------------------------------
featImg=featureimg;

for i = 1:3
    featImg(:,:,i) = mat2gray(featImg(:,:,i)).*255;
end

featMat = GetMeanFeat(featImg, sup.pixIdx);  
featMat = featMat./255;
colorFeatures = featMat(:,1:3);
medianR = median(colorFeatures(:,1)); medianG = median(colorFeatures(:,2)); medianB = median(colorFeatures(:,3));
featMat(:,1:3) = (featMat(:,1:3)-1.2*repmat([medianR, medianG, medianB],size(featMat,1),1))*1.5;
% get the indexes of boundary superpixels
bndIdx = GetBndSupIdx(sup.label);
feature_gabor53 = featMat;
feature_img_gabor = featImg;

function [E,R,T] = Essential(img1,img2)
%ESSENTIAL Summary of this function goes here
%   This function calculates the relative position and orientation
%   (essential matrix) of camera2 wrt camera1
%   Input: img1, img2, images taken by camera1 and camera2
%   respectively;Int1, Int2, intrisinc parameters of the form [fx fy ox oy]
%   of the two cameras respectively.
%   Output: The rotation matrix in form of [r11 r12 r13
%                                           r21 r22 r23
%                                           r31 r32 r33]
%           The translation matrix in form of [0 -tz ty
%                                              tz 0 -tx
%                                              -ty tx 0]
% Load stereo points.
load stereoPointPairs
load upToScaleReconstructionCameraParameters.mat
% Estimate the fundamental matrix.

imageDir = '/Users/mshong0320/Desktop/CV_Project_Data/From_spot3';
images = imageDatastore(imageDir);

img1 = undistortImage(readimage(images,1),cameraParams);
img2 = undistortImage(readimage(images,2),cameraParams);

img1_gray= rgb2gray(I1);
img2_gray = rgb2gray(I2);

%%

%Detect feature points each image.
imagePoints1 = detectSURFFeatures(img1_gray); %function derives the descriptors from pixels surrounding an interest point.
imagePoints2 = detectSURFFeatures(img2_gray);

corners1 = detectHarrisFeatures(img1_gray); 
corners2 = detectHarrisFeatures(img2_gray);

[features1, valid_corners1] = extractFeatures(img1_gray, corners1);
[features2, valid_corners2] = extractFeatures(img2_gray, corners2);
[SURFfeatures1, imagePoints1] = extractFeatures(img1_gray, imagePoints1);
[SURFfeatures2, imagePoints2] = extractFeatures(img2_gray, imagePoints2);

figure; 
imshow(img1_gray);
hold on
plot(valid_corners1);
plot(imagePoints1.selectStrongest(10),'showOrientation',true);
hold off

%%

% Extract feature descriptors from each image.
SURFfeatures1 = extractFeatures(img1_gray,imagePoints1,'Upright',true);
SURFfeatures2 = extractFeatures(img2_gray,imagePoints2,'Upright',true);


%%

%Match features across the images.
indexPairs = matchFeatures(SURFfeatures1,SURFfeatures2);
matchedPoints1 = imagePoints1(indexPairs(:,1));
matchedPoints2 = imagePoints2(indexPairs(:,2));

figure
showMatchedFeatures(img1_gray,img2_gray, matchedPoints1,matchedPoints2, 'montage', 'PlotOptions',{'ro','go','y--'});

title('Putative Matches')
%%

% Estimate the essential matrix.
[E,inliers] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2,'NumTrials',4000);
E

% Display the inlier matches.
inlierPoints1 = matchedPoints1(inliers);
inlierPoints2 = matchedPoints2(inliers);
figure
showMatchedFeatures(img1_gray,img2_gray,inlierPoints1,inlierPoints2, 'montage', 'PlotOptions',{'ro','go','y--'});
title('Inlier Matches with outer points removed')

% R = eye(3);
% T = zeros(3);

%%
% Getting Rotation matrix R and translation matrix t using SVD:
[U, sing, V] = svd(E);

Rotation = U
Translation = [U(1,1); U(2,2); U(3,3)]


end

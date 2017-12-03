function [R,T] = Essential(img1,img2,Int1,Int2)
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
% fRANSAC = estimateFundamentalMatrix(matchedPoints1,matchedPoints2,'Method','RANSAC','NumTrials',2000,'DistanceThreshold',1e-4)

imageDir = '/Users/mshong0320/Desktop/CV_Project_Data/From_spot3' %change this to your own directory containing picture data

images = imageDatastore(imageDir);

I1 = undistortImage(readimage(images,1),cameraParams);

I2 = undistortImage(readimage(images,2),cameraParams);

I1gray = rgb2gray(I1);
I2gray = rgb2gray(I2);

%%

%Detect feature points each image.
imagePoints1 = detectSURFFeatures(I1gray); %function derives the descriptors from pixels surrounding an interest point.
imagePoints2 = detectSURFFeatures(I2gray);

corners1 = detectHarrisFeatures(I1gray); 
corners2 = detectHarrisFeatures(I2gray);

[features1, valid_corners1] = extractFeatures(I1gray, corners1);
[features2, valid_corners2] = extractFeatures(I2gray, corners2);
[SURFfeatures1, imagePoints1] = extractFeatures(I1gray, imagePoints1);
[SURFfeatures2, imagePoints2] = extractFeatures(I2gray, imagePoints2);

figure; 
imshow(I1gray);
hold on
plot(valid_corners1);
plot(imagePoints1.selectStrongest(10),'showOrientation',true);
hold off

%%

% Extract feature descriptors from each image.
SURFfeatures1 = extractFeatures(I1gray,imagePoints1,'Upright',true);
SURFfeatures2 = extractFeatures(I2gray,imagePoints2,'Upright',true);


%%

%Match features across the images.
indexPairs = matchFeatures(SURFfeatures1,SURFfeatures2);
matchedPoints1 = imagePoints1(indexPairs(:,1));
matchedPoints2 = imagePoints2(indexPairs(:,2));

figure
showMatchedFeatures(I1gray,I2gray,matchedPoints1,matchedPoints2);
title('Putative Matches')
%%

% Estimate the essential matrix.
[E,inliers] = estimateFundamentalMatrix(matchedPoints1, matchedPoints2,'NumTrials',4000)

% Display the inlier matches.
inlierPoints1 = matchedPoints1(inliers);
inlierPoints2 = matchedPoints2(inliers);
figure
showMatchedFeatures(I1gray,I2gray,inlierPoints1,inlierPoints2);
title('Inlier Matches')

% R = eye(3);
% T = zeros(3);

%%
% Getting Rotation matrix R and translation matrix t using SVD:
[Rotation, singular, Translation] = svd(E);

Rotation
Translation

end

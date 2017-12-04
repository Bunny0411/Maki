% Single Camera Calibration function
function [CameraParams, imageUsed, EstimationErrors] = CameraCalib(imageFileNames)

%EPIPOLAR Summary of this function goes here
%   This function calculates the estimate intrinsic parameters of our
%   single camera as well as the accuracy of our measurements. 

%  INPUT:We need to provide as input variable our input file names from our
%        input data text files of calibration image dataset

%  Output: outputs the CameraParms, the imageUsed, and estimation errors.


% imageDir = '/Users/mshong0320/Desktop/CV_Project_Data/Calibration1_data';
% images = imageSet(fullfile(imageDir));
% imageFileNames = images.ImageLocation;

%%

[imagePoints, boardSize] = detectCheckerboardPoints(imageFileNames);
squareSizeInMM = 54;
worldPoints = generateCheckerboardPoints(boardSize,squareSizeInMM);

%%
[CameraParams,ImagesUsed, EstimationErrors] = estimateCameraParameters(imagePoints,worldPoints);
showReprojectionErrors(params);
figure;
showExtrinsics(params);
drawnow;
CameraParams
ImagesUsed
EstimationErrors

figure; 
imshow(imageFileNames{1}); 
hold on;
plot(imagePoints(:,1,1), imagePoints(:,2,1),'go');
plot(params.ReprojectedPoints(:,1,1),params.ReprojectedPoints(:,2,1),'r+');
legend('Detected Points','ReprojectedPoints');
hold off;


end

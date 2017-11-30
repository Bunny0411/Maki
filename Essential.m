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
img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

R = eye(3);
T = zeros(3);

end


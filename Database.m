function database = Database(file)
%DATABASE Summary of this function goes here
%   This function calculates out the R and T of all images relative to the
%   reference image. Note that it may not be the case that all the images
%   overlap with the reference image, so R and T of some images are
%   calculated relative to another overlapping image and then transformed
%   to that relative to the reference image.

%   Input: A txt file that has the name of all the images, which has a
%   format of (just an example):
%   IMG_01.jpg
%   IMG_02.jpg
%   ...
%   Assume that the first image is always the reference image. Also assume
%   that the order has been sorted that every image is at least overlapped
%   with the one following it.

%   Output: An n x 5 cell (like a dictionary, use help cell to learn more)
%   where n is the number of images in total. For the i th image,
%   database(i,1) is the rotation matrix R of the i th camera,
%   database(i,2) is the translation matrix T of the i th camera and
%   database(i,3) is a 1 x 4 array thay stores the intrisinc parameters
%   such that [fx fy ox oy], database(i,4) is a m x 2 array that stores
%   feature coordinates where m is the feature number and database(i,5) is
%   a m x 128 array that stores descriptors of the feature.
%   Make sure that order of database corresponds to order of the file,
%   which means database(i) corresponds to the i th line in file.
fid = fopen(file);
A = textscan(fid,'%s');

[~, n]=size(size(A));
database = cell(n,2);

end


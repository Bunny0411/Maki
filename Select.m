function selection = Select(R,T,database)
%SELECT Summary of this function goes here
%   This function selects the images for calculation given a camera
%   position and orientation

%   Input: R is the given orientation of the camera and T is the given
%   traslation wrt the reference camera and database is the one acquired in
%   Database.m

%   Output: A 1 x n array where n is the number of images selected. Each
%   column stands for the order number of the selected image. For example,
%   if you have selected the i th image, put i in the array. The selection
%   should be sorted such that each selection overlaps with the one before
%   it. Note that the first selection (A(1)) will only serve as a mere
%   reference and will not contribute. Also sort the selection from the
%   nearest to the farthest. By nearest, it doesn't mean nearest to the
%   target frame but nearest to the object (for example, the building in
%   the image)

selection = [];
end


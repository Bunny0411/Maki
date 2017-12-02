function Its = Intersection(line1,line2)
%INTERSECTION Summary of this function goes here
%   Given two lines, this function calculates the intersection of the two
%   lines. If the intersction is out of the image range, return [0;0]
%   Inputs: Two line coordinates matrices of n x 2 and m x 2
%   Output: The coordinate of the intersection of the form [x;y]
Its = [0;0];
[line1_num,~] = size(line1);
[line2_num,~] = size(line2);
X1 = [line1(1,1) 1;line1(line1_num,1) 1];
Y1 = [line1(1,2);line1(line1_num,2)];
[k1,b1] = (X1 \ Y1)';
X2 = [line2(1,1) 1;line2(line2_num,1) 1];
Y2 = [line2(1,2);line1(line2_num,2)];
[k2,b2] = (X2 \ Y2)';
Its = [k1 -1;k2; -1] \ [-b1;-b2];
end


function Output = NotInRange(x,y,w,h)
%NOTINRANGE Summary of this function goes here
%   This function determines whether a coordinate is within the image frame
%   range
%   Inputs: x,y are the coordinates given; w,h are dimensions of the image
%   Output: Output is a bool type variable. It will return TRUE if the
%   coordinate is not within the image frame range and FALSE otherwise.
Output = true;
if (x  >= 0 && x <= w && y >= 0 && y <= h )
    Output = false;
end
end


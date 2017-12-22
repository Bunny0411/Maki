function output = Transform(H,v)
%TRANSFORM Summary of this function goes here
%   v = [ x, y ]
output = [ 0, 0 ];

v_ = H * [ v'; 1 ];
output = [v_( 1 ) / v_( 3 ), v_( 2 ) / v_( 3 )];
end


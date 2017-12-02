function [R,T] = Relative(R1,T1,R2,T2)
%UNTITLED Summary of this function goes here
%   This function calculates the relative R and T of position2 with respect
%   to position1
%   Inputs: T1 and R1 are the postion and orientation of position1; T2 and
%   R2 are the position and orientation of position2
%   Outputs: R and T are the position and orientation of position2 with
%   respect to position1
R = eye(3);
T = zeros(3);
t1 = [T1(3,2);T1(1,3);T1(2,1)];
t2 = [T2(3,2);T2(1,3);T2(2,1)];
H1 = [R1 t1;0 0 0 1];
H2 = [R2 t2;0 0 0 1];
H = H1 \ H2;
R = H(1:3,1:3);
t = H(1:3,4);
T = [0 -t(3) t(2);t(3) 0 -t(1);-t(2) t(1) 0];
end


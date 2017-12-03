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
clear
clc

% Generating graph of the postions of the pictures taken
names = {'pos1' 'pos2' 'pos3' 'pos4' 'pos5' 'pos6' 'pos7' 'pos8' 'given_pos'};
A= ones(9) - diag([1 1 1 1 1 1 1 1 1]);
G = graph(A,names,'upper','OmitSelfLoops');
h = plot(G);

h.XData = [10 10 5 0 0 0 5 10 T(1)];
h.YData = [5 0 0 0 5 10 10 10 T(2)];
highlight(h,'pos1','NodeColor','r','EdgeColor','r');
N = size(names) 

% Set the distance threshold
threshold = 8;

% Calculating distances and selecting new nodes
no = 0;
for i = 1:8
    dist = CalcDistance(h.XData(i),h.YData(i), h.XData(9),h.YData(9));
    if dist < threshold
        no = no + 1;
        nodes(no) = i;
        xdata(no) = h.XData(i);
        ydata(no) = h.YData(i);        
    end
        
end
nodes(no+1) = 9;
xdata(no+1) = h.XData(9);
ydata(no+1) = h.YData(9); 

% Plotting new graph
figure();
Sub = subgraph(G,nodes);
sub_c = plot(Sub);
sub_c.XData = xdata;
sub_c.YData = ydata;

% Reading data from folders specified as above
n = 1;
currentfilename = [];
while (n < size(nodes,2))
    disp(n)
    cd /home/priyanka/Pictures/2017/12/
    name ="/pos"+string(nodes(n))+"/";
    cd('name')
    imagefiles = dir('*.JPG');      
    nfiles = length(imagefiles);    % Number of files found
    for ii=1:nfiles
        selection(:,n) = imagefiles(ii).name;
    end
    n=n+1;
end

function euclideanDistance = CalcDistance(x1, y1, x2, y2) 
euclideanDistance = sqrt((x2-x1)^2+(y2-y1)^2);
return
end

end




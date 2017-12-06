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
% Generating graph of the postions of the pictures taken
names = {'pos1' 'pos2' 'pos3' 'pos4' 'pos5' 'pos6' 'pos7' 'pos8' 'given_pos'};
A= ones(9) - diag([1 1 1 1 1 1 1 1 1]);
G = graph(A,names,'upper','OmitSelfLoops');
h = plot(G);

h.XData = [0.9175 0.5527 -0.0080 0.0790 -0.0952 -0.4773 -0.1097 -0.2841 0.05];
h.YData = [0.1332 0.1746 0.1852 0.2949 0.1677 0.2771 0.0105 0.0697 0.2];
highlight(h,'given_pos','NodeColor','r','EdgeColor','r');
N = size(names); 

% Set the distance threshold
threshold = 0.55;

% Calculating distances and selecting new nodes
no = 0;
for i = 1:8
    dist = CalcDistance(h.XData(i),h.YData(i), h.XData(9),h.YData(9))
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
currentfilename = 0;
s=0;
temp = 0;
while (n < size(nodes,2))
    disp(n)
    temp=temp + s;
    img = get_images(n);
    s = size(img,2);
    selection(1,temp+1:temp+s) = img;
    n=n+1;
end
end
function images = get_list()
    imagefiles = dir('*.JPG');    
    nfiles = length(imagefiles);   % Number of files found
    for ii=1:nfiles
        currentfilename = imagefiles(ii).name;
        currentimage = imread(currentfilename);
        images{ii} = currentimage;
    end
    return
end

function euclideanDistance = CalcDistance(x1, y1, x2, y2) 
euclideanDistance = sqrt((abs(x2)-abs(x1))^2+(abs(y2)-abs(y1))^2);
return
end

function images = get_images(pos)
    
    if (pos == 1)
        cd '/home/priyanka/Desktop/Project/Brody/pos1'
        images = get_list();
    elseif (pos == 2)
        cd '/home/priyanka/Desktop/Project/Brody/pos2'
        images = get_list();
    elseif (pos == 3)
        cd '/home/priyanka/Desktop/Project/Brody/pos3'
        images = get_list();
    elseif (pos == 4)
        cd '/home/priyanka/Desktop/Project/Brody/pos4'
        images = get_list();
    elseif (pos == 5)
        cd '/home/priyanka/Desktop/Project/Brody/pos5'
        images = get_list();
    elseif (pos == 6)
        cd '/home/priyanka/Desktop/Project/Brody/pos6'
        images = get_list();
    elseif (pos == 7)
        cd '/home/priyanka/Desktop/Project/Brody/pos7'
        images = get_list();
    elseif (pos == 8)
        cd '/home/priyanka/Desktop/Project/Brody/pos8'
        images = get_list();
    else 
        % close up pictures
        cd '/home/priyanka/Desktop/Project/Brody'
        images = get_list();
    end
    return
end









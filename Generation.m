function image = Generation(R,T,A,database)
%GENERATION Summary of this function goes here
%   This is the core function which will generate a new image given a
%   position.

%   Input: R and T are the relative position to reference image. A is the
%   selected image matrix given by Select.m and database is given by
%   Database.m

%   Output: An rgb image generated.
image = zeros(h,w,3);
Intrisinc = [fx 0 ox 0;0 fy oy 0;0 0 1 0];
[~,n] = size(A);
all = cell(n - 1,2 * 441);

for i = 2:n - 1
    R_main = database(A(1),1);
    T_main = database(A(1),2);
    t_main = [T_main(3,2);T_main(1,3);T_main(2,1)];
    H_main = [R_main t_main;0 0 0 1];%Transformation from reference frame to main frame
    t = [T(3,2);T(1,3);T(2,1)];
    H = [R t;0 0 0 1];%Transformation from reference frame to target frame
    H_m_target = H_main \ H;%Transformation from main frame to target frame
    R_m_target = H_m_target(3:3,3:3);
    t_m_target = H_m_target(1:3,4);
    T_m_target = [0 -t_m_target(3) t_m_target(2);t_m_target(3) 0 -t_m_target(1);-t_m_target(2) t_m_target(1) 0];
    R_current = database(A(i),1);
    T_current = database(A(i),2);
    t_current = [T_current(3,2);T_current(1,3);T_current(2,1);1];
    H_current = [R_current t_current;0 0 0 1];%Transformation from reference frame to current frame
    H_m_current = H_main \ H_current;%Transformation from main frame to current frame
    R_m_current = H_m_current(3:3,3:3);
    t_m_current = H_m_current(1:3,4);
    T_m_current = [0 -t_m_current(3) t_m_current(2);t_m_current(3) 0 -t_m_current(1);-t_m_current(2) t_m_current(1) 0];
    k = Intrisinc * t_current;
    epi_point = ceil([k(1) / k(3);k(2) / k(3)]);
    
    count = 0;
    for p = epi_point(1) - 10:epi_point(1) + 10
        for q =epi_point(2) - 10:epi_point(2) + 10
            count = count + 1;
            all(i - 1,count * 2 - 1) = Epipolar(R_m_target,T_m_target,p,q);%epipolar line coordinate of the target image
            all(i - 1,count * 2) = Epipolar(R_m_current,T_m_current,p,q);%epipolar line coordinate fo the current image
        end
    end
end

for i = 1:n -1
    for j = 1:441
        tar_line = all(i,2 * j - 1);%Epipolar line on the target image
        [n,~] = size(tar_line);
        tar_num = n;
        fill_line =all(i,2 * j);%Epipolar line on the corresponding image
        [n,~] = size(fill_line);
        fill_num = n;
        tar_up = tar_line(1,:);
        tar_down = tar_line(tar_num,:);%Two end points of the epipolar line on target image
        fill_up = fill_line(1,:);
        fill_down = fill_line(fill_num,:);%Two end points of the epipolar line on corresponding image
        R1 = R;
        T1 = T;%Target position wrt reference image
        R2 = database(A(i + 1),1);
        T2 = database(A(i + 1),2);%Corresponding position wrt reference frame
        [R_rel,T_rel] = Relative(R1,T1,R2,T2);
        line1 = Epipolar(R_rel,T_rel,fill_up(1),fill_up(2));
        Point1 = Intersection(line1,tar_line);
        line2 = Epipolar(R_rel,T_rel,fill_down(1),fill_down(2));
        Point2 = Intersection(line2,tar_line);
        line3 = Epipolar(inv(R_rel),R_rel \ T_rel,tar_up(1),tar_up(2));
        Point3 = Intersection(line3,fill_line);
        line4 = Epipolar(inv(R_rel),R_rel \ T_rel,tar_down(1),tar_down(2));
        Point4 = Intersection(line4,fill_line);
        if (NotInRange(Point1(1),Point1(2)))
            P1 = Point3;
        else
            P1 = fill_up;
        end
        if (NotInRange(Point2(1),Point2(2)))
            P2 = Point4;
        else
            P2 = fill_down;%Pin down the start and end point on corresponding image
        end
        range = fill_line;
        fill = [];
        for r = 1:fill_num
            if (range(r,1) > P1(1) && range(r,1) < P2(1))
                fill = [fill;range(r,:)];
            end
        end
    end
end
    
end



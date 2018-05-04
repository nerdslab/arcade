function [point, end_point, region] = defineregions(im, point, patch_width, hyp)

%% take a point 

x0 = point(1);
y0 = point(2);
slope_of_tang = point(3);
slope_of_norm = point(4);


%% take the edge direction of that point
%      - find the {+,-}patch_size/2 of each side of the point 
%      - need designated length
%         - potentially need to have the end box lenth to not interfer with
%         boundaries of picture

% genertate end point to the length of the patch
if slope_of_norm<0
    hyp = (-hyp);
end
[x1,y1] = generatecoordinate(x0, y0, slope_of_norm, hyp*2, 'na');
end_point = [x1,y1];

%% once the boundary of the patch is computed 
% -> extract that area from origonal picture 

% need boundary points around the area

% get points around start point
[left_upper_corner_x,left_upper_corner_y] = ...
    generatecoordinate(x0, y0, slope_of_tang, patch_width, 'left');
[right_upper_corner_x,right_upper_corner_y] = ...
    generatecoordinate(x0, y0, slope_of_tang, patch_width, 'right');

% get points around end_point
[left_lower_corner_x,left_lower_corner_y] = ...
    generatecoordinate(x1, y1, slope_of_tang, patch_width, 'left');
[right_lower_corner_x,right_lower_corner_y] = ...
    generatecoordinate(x1, y1, slope_of_tang, patch_width, 'right');

% define the region
region = [left_upper_corner_x left_upper_corner_y ...
         right_upper_corner_x right_upper_corner_y ...
         right_lower_corner_x right_lower_corner_y ...
         left_lower_corner_x left_lower_corner_y];

%{
% graph

figure, imshow(im(:,:,1));
hold on, plot(point(1),point(2),'r*') %plot start point
hold on, plot(x1,y1,'g*') %plot end point
hold on, plot(region(1),region(2),'c*')
hold on, plot(region(3),region(4),'c*')
hold on, plot(region(5),region(6),'c*')
hold on, plot(region(7),region(8),'c*')
%}




end
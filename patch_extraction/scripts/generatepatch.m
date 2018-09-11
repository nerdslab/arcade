function [patch_mx,greater_area] = generatepatch(im, region, point, patch_size, hyp, dir)
%GENERATEPATCH Summary of this function goes here
%   Detailed explanation goes here

%
% for reference:
%
% region = [left_upper_corner_x left_upper_corner_y ...  1 2
%          right_upper_corner_x right_upper_corner_y ... 3 4
%          right_lower_corner_x right_lower_corner_y ... 5 6
%          left_lower_corner_x left_lower_corner_y];     7 8
%

switch(dir)
    case 1
        if region(2) < region(4) %left top orientation 
            greater_area = [region(3) region(2) ... % 1 2
                            region(7) region(2) ... % 3 4
                            region(7) region(6) ... % 5 6
                            region(3) region(6)];   % 7 8
        else                     %right top orientation
            greater_area = [region(5) region(4) ... % 1 2
                            region(1) region(4) ... % 3 4
                            region(1) region(8) ... % 5 6
                            region(5) region(8)];   % 7 8        
        end

    case 2
        if region(2) < region(4) %left top orientation 
            greater_area = [region(3) region(2) ... % 1 2
                            region(7) region(2) ... % 3 4
                            region(7) region(6) ... % 5 6
                            region(3) region(6)];   % 7 8
        else
            greater_area = [region(5) region(4) ... % 1 2
                            region(1) region(4) ... % 3 4
                            region(1) region(8) ... % 5 6
                            region(5) region(8)];   % 7 8
            
        end
                    
    case 3 
        if region(6) < region(8)
            greater_area = [region(3) region(6) ... % 5 6
                            region(7) region(6) ... % 7 8
                            region(7) region(2) ... % 1 2
                            region(3) region(2)];   % 3 4 
        else
            greater_area = [region(5) region(8) ... % 5 6
                            region(1) region(8) ... % 7 8
                            region(1) region(4) ... % 1 2
                            region(5) region(4)];   % 3 4
        end
            
            
        
    case 4 
        if region(6) < region(8)
            greater_area = [region(7) region(6) ... % 5 6
                            region(3) region(6) ... % 7 8
                            region(3) region(2) ... % 1 2
                            region(7) region(2)];   % 3 4 
        else
            greater_area = [region(1) region(8) ... % 5 6
                            region(5) region(8) ... % 7 8
                            region(5) region(4) ... % 1 2
                            region(1) region(4)];   % 3 4
            
        end    
end

big_square = [];
for j = floor(greater_area(2)):floor(greater_area(6))
    row_entries = [];
    for i = floor(greater_area(1)):floor(greater_area(3))
        row_entries = [row_entries im(j,i,:)];        
    end
    big_square = [big_square; row_entries];
end


% testing
%figure, imshow(big_square);

rotated_big_square = imrotate(big_square(:,:,:), -point(5)); %need negative for clockwise rotation

% testing
%figure,subplot(1,2,1),imshow(big_square),subplot(1,2,2),imshow(rotated_big_square);

patch_mx = [];
s = size(rotated_big_square);

for j = ceil((s(1)-hyp)/2):...
        ceil(s(1) - ((s(1)-hyp)/2))-1
    
        patch_row = [];
        
        for i = ceil((s(2)-patch_size)/2):...
                ceil(s(2) - ((s(2)-patch_size)/2))-1
              
            patch_row = [patch_row rotated_big_square(j,i,:)];
        end
    patch_mx = [patch_mx; patch_row];
end

if point(4)<0
    patch_mx = flipud(patch_mx);
end

end


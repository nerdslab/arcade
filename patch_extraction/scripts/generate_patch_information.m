function [outline_of_brain_top, outline_of_brain_bottom, p1, p2, x1, x2, y1, y2] = generate_patch_information(Mask, num_of_patches, d)
%GENERATE_PATCH_INFORMATION Summary of this function goes here
%   Detailed explanation goes here


[Gx, Gy] = imgradientxy(Mask,'prewitt');
%figure, imagesc(abs(Gx) + abs(Gy))

boundary = (abs(Gx) + abs(Gy));

%[BW,thresh,gv,gh] = edge(boundary,'sobel');
%edge_dir = atan2(Gx, Gy);

[edge_dir_row, edge_dir_col, edge_dir_val] = find(boundary);
outline = [edge_dir_col, edge_dir_row, edge_dir_val];
outline_of_brain_top = [];
outline_of_brain_bottom = [];


for k = min(outline(:,1)):max(outline(:,1))
    l1 = find(outline(:,1) == k, 1, 'first');
    l2 = find(outline(:,1) == k, 1, 'last');
    outline_of_brain_top = [outline_of_brain_top; outline(l1,1:2)];   
    outline_of_brain_bottom = [outline_of_brain_bottom; outline(l2,1:2)];
end

degree_of_fitted_polynomial = 10;

p1 = polyfit(outline_of_brain_top(:,1), outline_of_brain_top(:,2), degree_of_fitted_polynomial);
p2 = polyfit(outline_of_brain_bottom(:,1), outline_of_brain_bottom(:,2), degree_of_fitted_polynomial);

% Graph the function
x1 = linspace(min(outline_of_brain_top(:,1)), ...
    max(outline_of_brain_top(:,1)),num_of_patches);
x2 = linspace(min(outline_of_brain_bottom(:,1)), ...
    max(outline_of_brain_bottom(:,1)),num_of_patches);
y1 = polyval(p1,x1);
y2 = polyval(p2,x2);

if d
   x1 = fliplr(x1);
   y1 = fliplr(y1);
else
   x2 = fliplr(x2);
   y2 = fliplr(y2);  
   
end


end


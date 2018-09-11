function [patches_overall, points_overall, end_points_overall] = extracting_patches(patches_of_interest, outline_of_brain_with_slopes, im2, patch_size, hyp, dir, dispflag)
%EXTRACTING_PATCHES Summary of this function goes here
%   Detailed explanation goes here

% visualizing
if nargin<7
    dispflag=0;
end

patches_overall = zeros(hyp, patch_size, length(patches_of_interest));
points_overall = zeros(1, 5, length(patches_of_interest));
end_points_overall = zeros(1, 2, length(patches_of_interest));

if dispflag
    figure, imshow(im2),hold on, 
end


parfor m = 1:length(patches_of_interest)-1
    x_point_of_interest = patches_of_interest(m);
    point = ...
        outline_of_brain_with_slopes(outline_of_brain_with_slopes(:,1) == x_point_of_interest, :);

    [points_overall(:,:,m), end_points_overall(:,:,m), region] = defineregions(im2, point, patch_size, hyp, dir);
    [patches_overall(:,:,m), ~] = generatepatch(im2, region, points_overall(:,:,m), patch_size, hyp, dir);
    disp(['Added patch: ', num2str(m), ' from Q', num2str(dir)]);
    %{
    % graphing
    if dispflag
        hold on, plot(points_overall(1,1,m),points_overall(1,2,m),'r*')
        hold on, plot(end_points_overall(1,1,m),end_points_overall(1,2,m),'g*')

        hold on, plot([region(1) region(3)],[region(2) region(4)],'m')
        hold on, plot([region(3) region(5)],[region(4) region(6)],'m')
        hold on, plot([region(5) region(7)],[region(6) region(8)],'m')
        hold on, plot([region(7) region(1)],[region(8) region(2)],'m')

        %hold on, plot([greater_area(1) greater_area(3)],[greater_area(2) greater_area(4)],'k')
        %hold on, plot([greater_area(3) greater_area(5)],[greater_area(4) greater_area(6)],'k')
        %hold on, plot([greater_area(5) greater_area(7)],[greater_area(6) greater_area(8)],'k')
        %hold on, plot([greater_area(7) greater_area(1)],[greater_area(8) greater_area(2)],'k')
    end
    %}
end

%normalize
patches_overall = patches_overall./255;
end


%{
script_patch_extraction.m
developed by: Theodore J. LaGrow

Description: This script is an example of the patch extraction used in the
    ArCaDe pipeline. The data generated in script can be found at:
    https://drive.google.com/open?id=1p6NiX26l39gscg6nYFltlT1fZ7nwZqpG

%}


%% load data generated from script's output for experiment 100048576_293
%load('patch_extraction_09_10_2018');

% or
%% init 

warning('off','all')
patch_size = 100; % designating all of the widths of the patchs
hyp = 810; %designating all of the heigths of the patches

% load in original image
im_og = imread('100048576_293_nissl.jpg');
im = im_og(:,:,3); % third channel
im2 = padarray(im,[hyp hyp],255,'both');
[h, w] = size(im2);
% load in recalculated probability maps
im3 = imread('Nmap_100048576_293.tif');
im_prob = padarray(im3,[hyp hyp],0,'both');
% load in the Allen Institute's manually labeled atlas
im4 = imread('100048576_293_atlas.jpg');
im_atlas = padarray(im4,[hyp hyp],255,'both');

%% plot the 3 images loaded from experiment 100048576_293
figure,
subplot(1,3,1), imshow(im_og), title('Original Image'),
subplot(1,3,2), imshow(im3), title('Cell Probability Map'),
subplot(1,3,3), imshow(im4), title('Manual Annotation of Atlas');

%% Splitting the image in half to run connected components and polynomial fitting
im_left  = ones(h,w).*255;
im_right  = ones(h,w).*255;

im_left(:,1:w/2)  = im2(:,1:w/2);
im_right(:,w/2:w) = im2(:,w/2:w);

%% plot the splitting
figure, 
subplot(1,2,1), imagesc(im_left), title('Left division'),
subplot(1,2,2), imagesc(im_right), title('Right division');


%% Get the outline of the brain

Mask_left = findbrainboundary(im_left, 245);
Mask_right = findbrainboundary(im_right, 245);
figure,
subplot(1,2,1), imagesc(Mask_left), title('Left mask'),
subplot(1,2,2), imagesc(Mask_right),title('Right mask');


%% Setting the number of patches for each quartile 
num_of_patches = 400;
ratio = ceil(num_of_patches*(.4)); % we only want the sections in the neocortex on the 3rd and 4th quartile

[outline_of_brain_top_left, outline_of_brain_bottom_left, p1_left, p2_left, x1_left, x2_left, y1_left, y2_left] = ...
    generate_patch_information(Mask_left, num_of_patches, 1);

[outline_of_brain_top_right, outline_of_brain_bottom_right, p1_right, p2_right, x1_right, x2_right, y1_right, y2_right] = ...
    generate_patch_information(Mask_right, num_of_patches, 0);

%% Generate slopes of each patch in each quartile

[outline_of_brain_top_with_slopes_left] = generateslopes(p1_left, outline_of_brain_top_left, x1_left);
[outline_of_brain_bottom_with_slopes_left] = generateslopes(p2_left, outline_of_brain_bottom_left, x2_left);
[outline_of_brain_top_with_slopes_right] = generateslopes(p1_right, outline_of_brain_top_right, x1_right);
[outline_of_brain_bottom_with_slopes_right] = generateslopes(p2_right, outline_of_brain_bottom_right, x2_right);


%% Graphing outline

figure, 
imshow(im2);
title('Location of each patch center'),
axis on,
hold on, scatter(x1_left, y1_left)
hold on, plot(x1_left, y1_left);
hold on, scatter(x2_left(1:ratio), y2_left(1:ratio))
hold on, plot(x2_left(1:ratio), y2_left(1:ratio));

hold on, scatter(x1_right, y1_right)
hold on, plot(x1_right, y1_right);
hold on, scatter(x2_right(1:ratio), y2_right(1:ratio))
hold on, plot(x2_right(1:ratio), y2_right(1:ratio));


%% Graph demonstrating patches extracted

example_patches = [25 100 150 200 250 300 350 395];
figure, imshow(im2);
for m = 1:length(example_patches)
    x_point_of_interest = example_patches(m);
    point = ...
        outline_of_brain_top_with_slopes_right(x_point_of_interest, :);

    [point, end_point, region] = defineregions(im2, point, patch_size, hyp, 1);
    [patch_mx, greater_area] = generatepatch(im2, region, point, patch_size, hyp, 1);

    hold on, plot(point(1),point(2),'r*')
    hold on, plot(end_point(1),end_point(2),'g*')

    hold on, plot([region(1) region(3)],[region(2) region(4)],'m')
    hold on, plot([region(3) region(5)],[region(4) region(6)],'m')
    hold on, plot([region(5) region(7)],[region(6) region(8)],'m')
    hold on, plot([region(7) region(1)],[region(8) region(2)],'m')

    hold on, plot([greater_area(1) greater_area(3)],[greater_area(2) greater_area(4)],'k')
    hold on, plot([greater_area(3) greater_area(5)],[greater_area(4) greater_area(6)],'k')
    hold on, plot([greater_area(5) greater_area(7)],[greater_area(6) greater_area(8)],'k')
    hold on, plot([greater_area(7) greater_area(1)],[greater_area(8) greater_area(2)],'k')
end

title('Depiction of outline of patch extraction');

%% Generating patches from original image

% top right - quartile 1
[patch_mx_top_right, point_top_right, end_point_top_right] = ...
    extracting_patches(x1_right, outline_of_brain_top_with_slopes_right, im2, patch_size, hyp, 1);

% top left - quartile 2
[patch_mx_top_left, point_top_left, end_point_top_left] = ...
    extracting_patches(x1_left, outline_of_brain_top_with_slopes_left, im2, patch_size, hyp, 2);

% bottom left - quartile 3
[patch_mx_bottom_left, point_bottom_left, end_point_bottom_left] = ...
    extracting_patches(x2_left(1:ratio), outline_of_brain_bottom_with_slopes_left, im2, patch_size, hyp, 3);

% bottom right - quartile 4
[patch_mx_bottom_right, point_bottom_right, end_point_bottom_right] = ...
    extracting_patches(x2_right(1:ratio), outline_of_brain_bottom_with_slopes_right, im2, patch_size, hyp, 4);


%% Generate patches from probability map

% top right - quartile 1
[patch_mx_top_right_prob, point_top_right_prob, end_point_top_right_prob] = ...
    extracting_patches(x1_right, outline_of_brain_top_with_slopes_right, im_prob, patch_size, hyp, 1); 

% top left - quartile 2
[patch_mx_top_left_prob, point_top_left_prob, end_point_top_left_prob] = ...
    extracting_patches(x1_left, outline_of_brain_top_with_slopes_left, im_prob, patch_size, hyp, 2);

% bottom left - quartile 3
[patch_mx_bottom_left_prob, point_bottom_left_prob, end_point_bottom_left_prob] = ...
    extracting_patches(x2_left(1:ratio), outline_of_brain_bottom_with_slopes_left, im_prob, patch_size, hyp, 3);

% bottom right - quartile 4
[patch_mx_bottom_right_prob, point_bottom_right_prob, end_point_bottom_right_prob] = ...
    extracting_patches(x2_right(1:ratio), outline_of_brain_bottom_with_slopes_right, im_prob, patch_size, hyp, 4);


%% Generate patches from manually annotated atlas

% top right - quartile 1
[patch_mx_top_right_atlas, point_top_right_atlas, end_point_top_right_atlas] = ...
    extracting_patches(x1_right, outline_of_brain_top_with_slopes_right, im_atlas(:,:,3), patch_size, hyp, 1);

% top left - quartile 2
[patch_mx_top_left_atlas, point_top_left_atlas, end_point_top_left_atlas] = ...
    extracting_patches(x1_left, outline_of_brain_top_with_slopes_left, im_atlas(:,:,3), patch_size, hyp, 2);

% bottom left - quartile 3
[patch_mx_bottom_left_atlas, point_bottom_left_atlas, end_point_bottom_left_atlas] = ...
    extracting_patches(x2_left(1:ratio), outline_of_brain_bottom_with_slopes_left, im_atlas(:,:,3), patch_size, hyp, 3);

% bottom right - quartile 4
[patch_mx_bottom_right_atlas, point_bottom_right_atlas, end_point_bottom_right_atlas] = ...
    extracting_patches(x2_right(1:ratio), outline_of_brain_bottom_with_slopes_right, im_atlas(:,:,3), patch_size, hyp, 4);


%% Save data (if needed)
%save('patch_extraction_09_10_2018');

%EOF
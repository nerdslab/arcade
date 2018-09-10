%% patch extraction script

%% init
% set everything that is hard coded
patch_size = 150; 
hyp = 1250;
patches_of_interest = [350 650 1400 2500 3500];


%%  import images and ground truth
im1 = imread('100048576_293-crop.jpg');
im2 = im1(1:3737, 1:4620);
%large_image = imread('../data/100048576_293.jpg'); %full image

ground_truth = load_nii('100048576_293-crop_y_1151_1350_x_1651_1850_JP_anno.nii');
im_train = ground_truth.img(:,:,2);

%im3 = imread('../data/Nmap_cortex.tiff');
%im4 = imread('../data/Nmap_retina.tiff');

%% Get the outline of the brain

Mask = findbrainboundary(im2);
%figure, imagesc(Mask)

[Gx, Gy] = imgradientxy(Mask,'prewitt');
%figure, imagesc(abs(Gx) + abs(Gy))

boundary = (abs(Gx) + abs(Gy));

[edge_dir_row, edge_dir_col, edge_dir_val] = find(boundary);
outline = [edge_dir_col, edge_dir_row, edge_dir_val];
outline_of_brain = [];

for k = min(outline(:,1)):max(outline(:,1))
    l = find(outline(:,1) == k, 1, 'first');
    outline_of_brain = [outline_of_brain; outline(l,1:2)];
end

p = polyfit(outline_of_brain(:,1), outline_of_brain(:,2), 8);
x1 = linspace(min(outline_of_brain(:,1)), max(outline_of_brain(:,1)));
y1 = polyval(p,x1);


%% Graphing outline

figure, imshow(im1);
axis on,
hold on, scatter(outline_of_brain(:,1), outline_of_brain(:,2))
hold on, plot(x1, y1);
title('Display even fit polynomial around surface');

%% Calculate all of the slopes

[outline_of_brain_with_slopes] = generateslopes(p, outline_of_brain);


%% Patch extraction
% init::arbitary patch size to start

all_cell_counts = [];
%all_surface_cells = (min(outline_of_brain_with_slopes(:,1))+ceil(patch_size/2)):(max(outline_of_brain_with_slopes(:,1))-ceil(patch_size/2));

%% Visualize Test

figure, imshow(im1);
for m = 1:length(patches_of_interest)
    x_point_of_interest = patches_of_interest(m);
    point = ...
        outline_of_brain_with_slopes(outline_of_brain_with_slopes(:,1) ...
        == x_point_of_interest, :);

    [point, end_point, region] = defineregions(im2, point, patch_size, hyp);
    [patch_mx, greater_area] = generatepatch(im2, region, point, patch_size, hyp);

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


%% plot the cutouts

figure, 
% ****plot all of the patches, used for testing//graphing
for m = 1:length(patches_of_interest)
    x_point_of_interest = patches_of_interest(m);
    point = ...
        outline_of_brain_with_slopes(outline_of_brain_with_slopes(:,1) ...
        == x_point_of_interest, :);

    [point, end_point, region] = defineregions(im2, point, patch_size, hyp);

    [patch_mx, ~] = generatepatch(im1, region, point, patch_size, hyp);
    
    subplot(1,length(patches_of_interest),m),
    imshow(patch_mx); %axis equal
    s = "Patch " + num2str(patches_of_interest(m));
    xlabel(s),
    hold on;
end


%EOF
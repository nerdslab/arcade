%{
script_cell_detection.m
developed by: Theodore J. LaGrow

Description: This script is an example of the cell detection used in the
    ArCaDe pipeline. The data used and generated in script can be found at:
    https://drive.google.com/open?id=1p6NiX26l39gscg6nYFltlT1fZ7nwZqpG

%}

%% load in previous data 

% choose 1 if you want to run the long cell detection test, 0 otherwise
long_test_flag = 0;

% mark 1 to see only figures, or 0 to run code yourself
ex_flag = 1;

if ex_flag == 1
    load('cell_detection_09_14_2018');
end
ex_flag = 1;

%% Generate Probability Maps

% Gaussian Mixture Models

if ex_flag == 0
    numcomp = 2; 
    numsamp = 5e6;
    numfreq = 0; 
    im_og = rgb2gray(im2double(imread('100048576_293_nissl.jpg'))); % V1 image
    im = rgb2gray(im2double(imread('100048576_293_nissl_crop.jpg'))); % V1 image croped
    whichsamp = randi(numel(im),numsamp,1);
    traind = im(whichsamp);
    gm = fitgmdist(traind,numcomp);
    [~,whichCell] = min(gm.mu); 
    Probx = posterior(gm,im(:));
    CellMap = reshape(Probx(:,whichCell),size(im));
    CellMapErode = imerode(CellMap,strel(2));
end

% plot the probability produced
figure, imshow(CellMapErode), title('GMM Probability Map');



%% Iterative Cell Detection

if ex_flag == 0
    % load in ground truth
    image = imread('100048576_293_nissl_crop.jpg');
    ground_truth = load_nii('100048576_293_nissl_crop_y_1151_1350_x_1651_1850_JP_anno.nii');

    row_idx = 1151:1350;
    col_idx = 1651:1850;

    im_actual = im(row_idx,col_idx);
    im_test = CellMapErode(row_idx,col_idx);
    im_train = ground_truth.img(:,:,2);
end

% display the testing patch and ground truth
figure, 
subplot(1,3,1), imshow(im_actual), title('Original Image Cutout'),
subplot(1,3,2), imagesc(im_test), title('Probability Map Cutout'),
subplot(1,3,3), imagesc(im_train), title('Ground Truth Annotations')


%% hyperparameter optimization

if ex_flag == 0
    p_threshold = [0.2:0.1:0.5];
    p_residual = [0.5:0.1:0.7];
    sphere_sz = [6:2:12];
    dilate_sz = 2:1:4;
    max_numcells = 500;
    NumIter = prod([length(p_threshold),length(p_residual),length(sphere_sz),length(dilate_sz)]);
end

%% run the optimization sweep
if ex_flag == 0
    Params = hyperparam_celldetect(im_test,im_train,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells)
end
%% Graph estimated cells on cutouts
if ex_flag == 0
    [Centroids,Nmap] = OMP_ProbMap2D(im_test,Params.p_threshold,Params.p_residual,Params.sphere_sz,Params.dilate_sz,max_numcells,0);
    stats = regionprops('table',Nmap,'Centroid',...
        'MajorAxisLength','MinorAxisLength');
    centers = stats.Centroid;
    diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
    radii = diameters/2; %radius
end

%% display the testing patch and ground truth
figure, 
subplot(1,4,1), imshow(im_actual), title('Original Image Cutout'),
subplot(1,4,2), imagesc(im_test), title('Probability Map Cutout'),
subplot(1,4,3), imagesc(im_train), title('Ground Truth Annotations'),
subplot(1,4,4), imshow(im_actual), title("Overlaid Cells"), viscircles(centers, radii),

%% long run on full probability map

if long_test_flag == 1
    num_of_system_cores = 4;
    num_of_blocks = 100;
    maxnumcells = 100000;

    [Centroids_best,Nmap_chuncks,BlockPos] = OMP_ProbMap2D_parfor(CellMapErode,Params.p_threshold,Params.p_residual,Params.sphere_sz,Params.dilate_sz,maxnumcells,num_of_system_cores,num_of_blocks,1); 

    % recombine
    Nmap_full = combine_celldetect_blocks(Centroids_best,BlockPos,size(CellMapErode));
    
    stats_full = regionprops('table',Nmap_full,'Centroid',...
        'MajorAxisLength','MinorAxisLength');
    centers_full = stats_full.Centroid;
    diameters_full = mean([stats_full.MajorAxisLength stats_full.MinorAxisLength],2);
    radii_full = diameters_full/2; %radius
    
    % see the overlaid cells
    figure, 
    subplot(1,4,1), imshow(im_og), title('Original Image'),
    subplot(1,4,2), imagesc(CellMapErode), title('Probability Map'),
    subplot(1,4,4), imshow(im_og), title("Overlaid Cells Full"), viscircles(centers_full, radii_full),
end

%% Save data (if needed)
%save('cell_detection_09_14_2018');

%EOF
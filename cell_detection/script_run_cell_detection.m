%% cell detection and hyperparameter script

%%  import images and ground truth
im1 = imread('../data/100048576_293-crop.jpg');
im2 = im1(1:3737, 1:4620);
%large_image = imread('../data/100048576_293.jpg'); %full image

ground_truth = load_nii('../data/100048576_293-crop_y_1151_1350_x_1651_1850_JP_anno.nii');
im_train = ground_truth.img(:,:,2);

im3 = imread('../data/Nmap_cortex.tiff');
%im4 = imread('../data/Nmap_retina.tiff');
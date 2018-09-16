%{
script_cell_detection.m
developed by: Theodore J. LaGrow

Description: This script is an example of the cell detection used in the
    ArCaDe pipeline. The data generated in script can be found at:
    https://drive.google.com/open?id=1p6NiX26l39gscg6nYFltlT1fZ7nwZqpG

%}

%% load in previous data 
%load('cell_detection_09_10_2018');

%% Generate Probability Maps

% Gaussian Mixture Models

numcomp = 2; 
numsamp = 5e6;
numfreq = 0; 
IM = rgb2gray(im2double(imread('100048576_293.jpg'))); % V1 image
whichsamp = randi(numel(IM),numsamp,1);
traind = IM(whichsamp);
gm = fitgmdist(traind,numcomp);
[~,whichCell] = min(gm.mu); 
Probx = posterior(gm,IM(:));
CellMap = reshape(Probx(:,whichCell),size(IM));
CellMapErode = imerode(CellMap,strel(2));

% plot the probability produced
figure, imshow(CellMapErode), title('GMM Probability Map');



%% Iterative Cell Detection





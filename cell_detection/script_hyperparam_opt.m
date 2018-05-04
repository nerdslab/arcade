%% hyperparameter script

%% forgo several of the resulting steps

%this data is too big to put on github
%load('../data/04_03_2018.mat');
load('04_17_2018_02.mat');

%% load in retina annos

im_retina_ilastik = imread('Nmap_retina.tiff');


im_retina = imread('retina.png');

ground_truth_5_TL = load_nii('retina_y_630_779_x_650_799_TL_anno.nii');
im_train_5_TL = ground_truth_5_TL.img;
%im_train_5_TL = rot90(flipud(im_train_5_TL),-1);
row_idx_5 = [630 779]; 
col_idx_5 = [650 799];

ground_truth_6_TL = load_nii('retina_y_800_899_x_800_899_TL_anno.nii');
im_train_6_TL = ground_truth_6_TL.img;
%im_train_6_TL = rot90(flipud(im_train_6_TL),-1);
row_idx_6 = [800 899]; 
col_idx_6 = [800 899];

%%
im2;
row_idx_5 = [630 779]; 
col_idx_5 = [650 799];

row_idx_6 = [800 899]; 
col_idx_6 = [800 899];

figure, 
subplot(2,4,[1,2,5,6]),imshow(im2), axis on,
hold on, plot(col_idx_5(1),row_idx_5(1),'r*')
hold on, plot(col_idx_5(2),row_idx_5(1),'r*')
hold on, plot(col_idx_5(1),row_idx_5(2),'r*')
hold on, plot(col_idx_5(2),row_idx_5(2),'r*')
hold on, line([col_idx_5(1) col_idx_5(1)],[row_idx_5(1) row_idx_5(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx_5(2) col_idx_5(2)],[row_idx_5(1) row_idx_5(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx_5(1) col_idx_5(2)],[row_idx_5(2) row_idx_5(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx_5(2) col_idx_5(1)],[row_idx_5(1) row_idx_5(1)], 'Color','black', 'LineWidth', 2)

hold on, plot(col_idx_6(1),row_idx_6(1),'r*')
hold on, plot(col_idx_6(2),row_idx_6(1),'r*')
hold on, plot(col_idx_6(1),row_idx_6(2),'r*')
hold on, plot(col_idx_6(2),row_idx_6(2),'r*')
hold on, line([col_idx_6(1) col_idx_6(1)],[row_idx_6(1) row_idx_6(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx_6(2) col_idx_6(2)],[row_idx_6(1) row_idx_6(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx_6(1) col_idx_6(2)],[row_idx_6(2) row_idx_6(2)], 'Color','black', 'LineWidth', 2)
hold on, line([col_idx_6(2) col_idx_6(1)],[row_idx_6(1) row_idx_6(1)], 'Color','black', 'LineWidth', 2)


subplot(2,4,3), imshow(im_retina(row_idx_5(1):row_idx_5(2),col_idx_5(1):col_idx_5(2))),
xlabel('cutout of layer 2'),
subplot(2,4,4), imagesc(im_train_5_TL),
xlabel('ground truth labeling'),

subplot(2,4,7), imshow(im_retina(row_idx_6(1):row_idx_6(2),col_idx_6(1):col_idx_6(2))),
xlabel('cutout of layer 3'),
subplot(2,4,8), imagesc(im_train_6_TL),
xlabel('ground truth labeling'),

%{
anno5 = im2(row_idx_5(1):row_idx_5(2),col_idx_5(1):col_idx_5(2));
figure, imshow(anno5)
nii5 = make_nii(anno5);
save_nii(nii5,'retina_y_630_779_x_650_799.nii')

anno6 = im2(row_idx_6(1):row_idx_6(2),col_idx_6(1):col_idx_6(2));
figure, imshow(anno6)
nii6 = make_nii(anno6);
save_nii(nii6,'retina_y_800_899_x_800_899.nii')
%}


%% retina validation

[Params_5_TL,f1_mat_5_TL] = hyperparam_celldetect(im_retina,im_train_5_TL,row_idx_5,col_idx_5,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells,numsamp,numcomp,erode_sz);
[Params_6_TL,f1_mat_6_TL] = hyperparam_celldetect(im_retina,im_train_6_TL,row_idx_6,col_idx_6,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells,numsamp,numcomp,erode_sz);
Params_5_TL
Params_6_TL

%%

[all_f1_scores_5_TL, check_5_TL, max_num_5_TL] = plot_f1_scores(Params_5_TL,f1_mat_5_TL,p_threshold,p_residual,sphere_sz,dilate_sz,numsamp,numcomp,erode_sz);
[all_f1_scores_6_TL, check_6_TL, max_num_6_TL] = plot_f1_scores(Params_6_TL,f1_mat_6_TL,p_threshold,p_residual,sphere_sz,dilate_sz,numsamp,numcomp,erode_sz);

%
% graph
max_y = max([Params_5_TL.f1max, Params_6_TL.f1max]);
figure, 
subplot(1,2,1),
plot(all_f1_scores_5_TL(:,1), all_f1_scores_5_TL(:,2)), hold on,
for i = 1:check_5_TL
    plot(all_f1_scores_5_TL(max_num_5_TL(i),1), all_f1_scores_5_TL(max_num_5_TL(i),2), 'r*', 'MarkerSize', 4),
    if i ~= check_5_TL 
        hold on,
    end
end
xlabel(['TJ5 f1: ', num2str(Params_5_TL.f1max)]),
ylim([.45 max_y]),
%xlim([0 NumIter]),

subplot(1,2,2),
plot(all_f1_scores_6_TL(:,1), all_f1_scores_6_TL(:,2)), hold on,
for i = 1:check_6_TL
    plot(all_f1_scores_6_TL(max_num_6_TL(i),1), all_f1_scores_6_TL(max_num_6_TL(i),2), 'r*', 'MarkerSize', 4),
    if i ~= check_6_TL 
        hold on,
    end
end
xlabel(['TJ6 f1: ', num2str(Params_6_TL.f1max)]),
ylim([.45 max_y]),
%xlim([0 NumIter]),





%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% init and upload the data for cortex


image = imread('../data/100048576_293-crop.jpg');
large_image = imread('../data/100048576_293.jpg');

ground_truth_1_JP = load_nii('100048576_293-crop_y_1151_1350_x_1651_1850_JP_anno.nii');
im_train_1_JP = ground_truth_1_JP.img(:,:,2);
row_idx_1 = [1151 1350]; 
col_idx_1 = [1651 1850];

ground_truth_2_AW = load_nii('100048576_293-crop_y_3000_3201_x_700_901_AW_anno.nii');
ground_truth_2_JP = load_nii('100048576_293-crop_y_3000_3201_x_700_901_JP_anno.nii');
im_train_2_AW = ground_truth_2_AW.img;
im_train_2_JP = ground_truth_2_JP.img;
row_idx_2 = [3000 3201]; 
col_idx_2 = [700 901];

ground_truth_3_AW = load_nii('100048576_293-crop_y_2100_2301_x_1500_1701_AW_anno.nii');
ground_truth_3_JP = load_nii('100048576_293-crop_y_2100_2301_x_1500_1701_JP_anno.nii');
im_train_3_AW = ground_truth_3_AW.img;
im_train_3_JP = ground_truth_3_JP.img;
row_idx_3 = [2100 2301]; 
col_idx_3 = [1500 1701];

ground_truth_4_AW = load_nii('100048576_293-crop_y_1650_1851_x_2300_2501_AW_anno.nii');
ground_truth_4_JP = load_nii('100048576_293-crop_y_1650_1851_x_2300_2501_JP_anno.nii');
im_train_4_AW = ground_truth_4_AW.img;
im_train_4_JP = ground_truth_4_JP.img;
row_idx_4 = [1650 1851]; 
col_idx_4 = [2300 2501];

%% Parameters

p_threshold = [0.11:0.02:0.75];
p_residual = [0.3:.05:.5];
sphere_sz = [11:2:29];
dilate_sz = [1:2:9];
max_numcells = 800;
numsamp = [5e5];
numcomp = [2]; 
erode_sz = [0 1 2 3 5];
NumIter = prod([length(p_threshold),length(p_residual),length(sphere_sz),length(dilate_sz),length(numsamp),length(numcomp),length(erode_sz)]);

%% Judy's first validation

[Params_1_JP,f1_mat_1_JP] = hyperparam_celldetect(image,im_train_1_JP,row_idx_1,col_idx_1,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells,numsamp,numcomp,erode_sz);
Params_1_JP

%% Alexis's first validation, Judy's second validation

[Params_2_AW,f1_mat_2_AW] = hyperparam_celldetect(image,im_train_2_AW,row_idx_2,col_idx_2,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells,numsamp,numcomp,erode_sz);
[Params_2_JP,f1_mat_2_JP] = hyperparam_celldetect(image,im_train_2_JP,row_idx_2,col_idx_2,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells,numsamp,numcomp,erode_sz);
Params_2_AW
Params_2_JP

%% Alexis's second validation, Judy's thrid validation

[Params_3_AW,f1_mat_3_AW] = hyperparam_celldetect(image,im_train_3_AW,row_idx_3,col_idx_3,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells,numsamp,numcomp,erode_sz);
[Params_3_JP,f1_mat_3_JP] = hyperparam_celldetect(image,im_train_3_JP,row_idx_3,col_idx_3,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells,numsamp,numcomp,erode_sz);
Params_3_AW
Params_3_JP

%% Alexis's third validation, Judy's fourth validation

[Params_4_AW,f1_mat_4_AW] = hyperparam_celldetect(image,im_train_4_AW,row_idx_4,col_idx_4,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells,numsamp,numcomp,erode_sz);
[Params_4_JP,f1_mat_4_JP] = hyperparam_celldetect(image,im_train_4_JP,row_idx_4,col_idx_4,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells,numsamp,numcomp,erode_sz);
Params_4_AW
Params_4_JP

%% Graph the f1 scores of set 2

[all_f1_scores_1_JP, check_1_JP, max_num_1_JP] = plot_f1_scores(Params_1_JP,f1_mat_1_JP,p_threshold,p_residual,sphere_sz,dilate_sz,numsamp,numcomp,erode_sz);

[all_f1_scores_2_AW, check_2_AW, max_num_2_AW] = plot_f1_scores(Params_2_AW,f1_mat_2_AW,p_threshold,p_residual,sphere_sz,dilate_sz,numsamp,numcomp,erode_sz);
[all_f1_scores_2_JP, check_2_JP, max_num_2_JP] = plot_f1_scores(Params_2_JP,f1_mat_2_JP,p_threshold,p_residual,sphere_sz,dilate_sz,numsamp,numcomp,erode_sz);

[all_f1_scores_3_AW, check_3_AW, max_num_3_AW] = plot_f1_scores(Params_3_AW,f1_mat_3_AW,p_threshold,p_residual,sphere_sz,dilate_sz,numsamp,numcomp,erode_sz);
[all_f1_scores_3_JP, check_3_JP, max_num_3_JP] = plot_f1_scores(Params_3_JP,f1_mat_3_JP,p_threshold,p_residual,sphere_sz,dilate_sz,numsamp,numcomp,erode_sz);

[all_f1_scores_4_AW, check_4_AW, max_num_4_AW] = plot_f1_scores(Params_4_AW,f1_mat_4_AW,p_threshold,p_residual,sphere_sz,dilate_sz,numsamp,numcomp,erode_sz);
[all_f1_scores_4_JP, check_4_JP, max_num_4_JP] = plot_f1_scores(Params_4_JP,f1_mat_4_JP,p_threshold,p_residual,sphere_sz,dilate_sz,numsamp,numcomp,erode_sz);

%%
% graph
max_y = max([Params_2_AW.f1max, Params_3_AW.f1max, Params_4_AW.f1max, Params_1_JP.f1max, Params_2_JP.f1max, Params_3_JP.f1max, Params_4_JP.f1max]);
figure, 
h1 = subplot(2,4,1); set(h1,'Visible','off'),
subplot(2,4,2),
plot(all_f1_scores_2_AW(:,1), all_f1_scores_2_AW(:,2)), hold on,
for i = 1:check_2_AW
    plot(all_f1_scores_2_AW(max_num_2_AW(i),1), all_f1_scores_2_AW(max_num_2_AW(i),2), 'r*', 'MarkerSize', 4),
    if i ~= check_2_AW 
        hold on,
    end
end
xlabel(['AW2 f1: ', num2str(Params_2_AW.f1max)]),
ylim([.45 max_y]),
xlim([0 NumIter]),

subplot(2,4,3),
plot(all_f1_scores_3_AW(:,1), all_f1_scores_3_AW(:,2)), hold on,
for i = 1:check_3_AW
    plot(all_f1_scores_3_AW(max_num_3_AW(i),1), all_f1_scores_3_AW(max_num_3_AW(i),2), 'r*', 'MarkerSize', 4),
    if i ~= check_3_AW 
        hold on,
    end
end
xlabel(['AW3 f1: ', num2str(Params_3_AW.f1max)]),
ylim([.45 max_y]),
xlim([0 NumIter]),


subplot(2,4,4),
plot(all_f1_scores_4_AW(:,1), all_f1_scores_4_AW(:,2)), hold on,
for i = 1:check_4_AW
    plot(all_f1_scores_4_AW(max_num_4_AW(i),1), all_f1_scores_4_AW(max_num_4_AW(i),2), 'r*', 'MarkerSize', 4),
    if i ~= check_4_AW 
        hold on,
    end
end
xlabel(['AW4 f1: ', num2str(Params_4_AW.f1max)]),
ylim([.45 max_y]),
xlim([0 NumIter]),


subplot(2,4,5),
plot(all_f1_scores_1_JP(:,1), all_f1_scores_1_JP(:,2)), hold on,
for i = 1:check_1_JP
    plot(all_f1_scores_1_JP(max_num_1_JP(i),1), all_f1_scores_1_JP(max_num_1_JP(i),2), 'r*', 'MarkerSize', 4),
    if i ~= check_1_JP 
        hold on,
    end
end
xlabel(['JP1 f1: ', num2str(Params_1_JP.f1max)]),
ylim([.45 max_y]),
xlim([0 NumIter]),

subplot(2,4,6),
plot(all_f1_scores_2_JP(:,1), all_f1_scores_2_JP(:,2)), hold on,
for i = 1:check_2_JP
    plot(all_f1_scores_2_JP(max_num_2_JP(i),1), all_f1_scores_2_JP(max_num_2_JP(i),2), 'r*', 'MarkerSize', 4),
    if i ~= check_2_JP 
        hold on,
    end
end
xlabel(['JP2 f1: ', num2str(Params_2_JP.f1max)]),
ylim([.45 max_y]),
xlim([0 NumIter]),


subplot(2,4,7),
plot(all_f1_scores_3_JP(:,1), all_f1_scores_3_JP(:,2)), hold on,
for i = 1:check_3_JP
    plot(all_f1_scores_3_JP(max_num_3_JP(i),1), all_f1_scores_3_JP(max_num_3_JP(i),2), 'r*', 'MarkerSize', 4),
    if i ~= check_3_JP 
        hold on,
    end
end
xlabel(['JP3 f1: ', num2str(Params_3_JP.f1max)]),
ylim([.45 max_y]),
xlim([0 NumIter]),

subplot(2,4,8),
plot(all_f1_scores_4_JP(:,1), all_f1_scores_4_JP(:,2)), hold on,
for i = 1:check_4_JP
    plot(all_f1_scores_4_JP(max_num_4_JP(i),1), all_f1_scores_4_JP(max_num_4_JP(i),2), 'r*', 'MarkerSize', 4),
    if i ~= check_4_JP 
        hold on,
    end
end
xlabel(['JP4 f1: ', num2str(Params_4_JP.f1max)]),
ylim([.45 max_y]),
xlim([0 NumIter]),


%% Graphing the different ground truths for the image
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure,
h1 = subplot(2,8,1); set(h1, 'Visible', 'off');
h2 = subplot(2,8,2); set(h2, 'Visible', 'off');

subplot(2,8,3), imshow(image(row_idx_2(1):row_idx_2(2),col_idx_2(1):col_idx_2(2))), axis tight,
xlabel(['AW: y 3000:3201, x 700:901, f1: ', num2str(Params_2_AW.f1max, 4)]),
subplot(2,8,4), imagesc(im_train_2_AW), axis off,

subplot(2,8,5), imshow(image(row_idx_3(1):row_idx_3(2),col_idx_3(1):col_idx_3(2))), axis tight,
xlabel(['AW: y 2100:2301 x 1500:1701, f1: ', num2str(Params_3_AW.f1max, 4)]),
subplot(2,8,6), imagesc(im_train_3_AW), axis off,

subplot(2,8,7), imshow(image(row_idx_4(1):row_idx_4(2),col_idx_4(1):col_idx_4(2))), axis tight,
xlabel(['AW: y 1650:1851 x 2300:2501, f1: ', num2str(Params_4_AW.f1max, 4)]),
subplot(2,8,8), imagesc(im_train_4_AW), axis off,

subplot(2,8,9), imshow(image(row_idx_1(1):row_idx_1(2),col_idx_1(1):col_idx_1(2))), axis tight,
xlabel(['JP: y 1151:1350 x 1651:1850, f1: ', num2str(Params_1_JP.f1max, 4)]),
subplot(2,8,10), imagesc(im_train_1_JP), axis off,

subplot(2,8,11), imshow(image(row_idx_2(1):row_idx_2(2),col_idx_2(1):col_idx_2(2))), axis tight,
xlabel(['JP: y 3000:3201 x 700:901, f1: ', num2str(Params_2_JP.f1max, 4)]),
subplot(2,8,12), imagesc(im_train_2_JP), axis off,

subplot(2,8,13), imshow(image(row_idx_3(1):row_idx_3(2),col_idx_3(1):col_idx_3(2))), axis tight,
xlabel(['JP: y 2100:2301 x 1500:1701, f1: ', num2str(Params_3_JP.f1max, 4)]),
subplot(2,8,14), imagesc(im_train_3_JP), axis off,

subplot(2,8,15), imshow(image(row_idx_4(1):row_idx_4(2),col_idx_4(1):col_idx_4(2))), axis tight,
xlabel(['JP: y 1650:1851 x 2300:2501, f1: ', num2str(Params_4_JP.f1max, 4)]),
subplot(2,8,16), imagesc(im_train_4_JP), axis off,


%% Testing training on different sets

Params_1=Params_4_AW;
im_train_1 = im_train_4_AW;

row_idx = row_idx_4;
col_idx = col_idx_4;

b=1;
CC = bwconncomp(im_train_1);     
s  = regionprops(CC, 'centroid');
C0_prev = cat(1, s.Centroid);

[CellMapErode] = gmm(image, Params_1.numsamp, Params_1.numcomp, Params_1.erode_size);                
im_test = CellMapErode(row_idx(1):row_idx(2),col_idx(1):col_idx(2));
[Centroids,~] = OMP_ProbMap2D(im_test,Params_1.p_threshold,Params_1.p_residual,Params_1.sphere_sz,Params_1.dilate_sz,max_numcells,0);
C1_prev = Centroids(:, 1:2); %estimated cells
C1 = pad(C1_prev, Params_1.sphere_sz, size(im_test,1), size(im_test,2));
C0 = pad(C0_prev, Params_1.sphere_sz, size(im_train,1), size(im_train,2));
thresh = Params_1.sphere_sz;
[~,TP,FP,FN,~] = centroiderror_missrates(C0',C1',thresh);
[f1_mat_1, ~, ~] = f1score(TP,FP,FN,b);
f1max_1 = max(f1_mat_1(:))                      
                            
            

%% check ilastik prob maps on ground truth

im_retina = imread('retina.png');
im_cortex = imread('100048576_293-crop.jpg');


im_ilastik_cortex = imread('Nmap_cortex.tiff');
im_ilastik_retina = imread('Nmap_retina.tiff');

%%
% cortex ilastik

figure, 
subplot(4,3,1),
imshow(im_cortex(row_idx_1(1):row_idx_1(2),col_idx_1(1):col_idx_1(2))), 
xlabel('OG Cutout'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
ylabel('Cortex Layer 1'), 
subplot(4,3,2),
imshow(im_ilastik_cortex(row_idx_1(1):row_idx_1(2),col_idx_1(1):col_idx_1(2))), 
xlabel('Ilastik ProbMap'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
subplot(4,3,3),
imagesc(im_train_1_JP), 
xlabel('GT Labeling'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
yyaxis right
ylabel('f1: .8714'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])


subplot(4,3,4),
imshow(im_cortex(row_idx_2(1):row_idx_2(2),col_idx_2(1):col_idx_2(2))), 
xlabel('OG Cutout'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
ylabel('Cortex Layer 2/3'), 
subplot(4,3,5),
imshow(im_ilastik_cortex(row_idx_2(1):row_idx_2(2),col_idx_2(1):col_idx_2(2))), 
xlabel('Ilastik ProbMap'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
subplot(4,3,6),
imagesc(im_train_2_JP), 
xlabel('GT Labeling'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
yyaxis right
ylabel('f1: .7682'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])

 
subplot(4,3,7),
imshow(im_cortex(row_idx_3(1):row_idx_3(2),col_idx_3(1):col_idx_3(2))), 
xlabel('OG Cutout'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
ylabel('Cortex Layer 4/5'), 
subplot(4,3,8),
imshow(im_ilastik_cortex(row_idx_3(1):row_idx_3(2),col_idx_3(1):col_idx_3(2))), 
xlabel('Ilastik ProbMap'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
subplot(4,3,9),
imagesc(im_train_3_JP), 
xlabel('GT Labeling'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
yyaxis right
ylabel('f1: .7716'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])


subplot(4,3,10),
imshow(im_cortex(row_idx_4(1):row_idx_4(2),col_idx_4(1):col_idx_4(2))), 
xlabel('OG Cutout'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
ylabel('Cortex Layer 5/6'), 
subplot(4,3,11),
imshow(im_ilastik_cortex(row_idx_4(1):row_idx_4(2),col_idx_4(1):col_idx_4(2))), 
xlabel('Ilastik ProbMap'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
subplot(4,3,12),
imagesc(im_train_4_JP), 
xlabel('GT Labeling'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
yyaxis right
ylabel('f1: .8536'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])


%%
% retina
figure, 
subplot(2,3,1),
imshow(im_retina(row_idx_5(1):row_idx_5(2),col_idx_5(1):col_idx_5(2))), 
xlabel('OG Cutout'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
ylabel('Retina Layer 1/2'), 
subplot(2,3,2),
imshow(im_ilastik_retina(row_idx_5(1):row_idx_5(2),col_idx_5(1):col_idx_5(2))), 
xlabel('Ilastik ProbMap'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
subplot(2,3,3),
imagesc(im_train_5_TL), 
xlabel('GT Labeling'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
yyaxis right
ylabel('f1: .9200'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])


subplot(2,3,4),
imshow(im_retina(row_idx_6(1):row_idx_6(2),col_idx_6(1):col_idx_6(2))), 
xlabel('OG Cutout'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
ylabel('Retina Layer 3'), 
subplot(2,3,5),
imshow(im_ilastik_retina(row_idx_6(1):row_idx_6(2),col_idx_6(1):col_idx_6(2))), 
xlabel('Ilastik ProbMap'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
subplot(2,3,6),
imagesc(im_train_6_TL), 
xlabel('GT Labeling'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])
yyaxis right
ylabel('f1: .8625'), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[])


%%
im_test = im_ilastik_cortex(row_idx_2(1):...
                            row_idx_2(2),...
                            col_idx_2(1):...
                            col_idx_2(2));
im_train =                 im_train_2_AW;
Params1 =                    Params_2_AW;

b=1;

CC_1 = bwconncomp(im_test);     
s_1  = regionprops(CC_1, 'centroid');
C0_prev = cat(1, s_1.Centroid);

CC_2 = bwconncomp(im_train);     
s_2  = regionprops(CC_2, 'centroid');
C1_prev = cat(1, s_2.Centroid);

C1 = pad(C1_prev, Params1.sphere_sz, size(im_test,1), size(im_test,2));
C0 = pad(C0_prev, Params1.sphere_sz, size(im_train,1), size(im_train,2));
thresh = Params1.sphere_sz;
[~,TP,FP,FN,~] = centroiderror_missrates(C0',C1',thresh);
[f1_mat_1, ~, ~] = f1score(TP,FP,FN,b);
f1max_1 = max(f1_mat_1(:))                            




%% Checking differences between two annotations

[f1max_chunck_2_sphere_sz_0, f1max_chunck_2_sphere_sz_1, centroid_count_2_AW, centroid_count_2_JP] = generate_f1_score(im_train_2_AW,im_train_2_JP,Params_2_AW.sphere_sz,Params_2_JP.sphere_sz);
[f1max_chunck_3_sphere_sz_0, f1max_chunck_3_sphere_sz_1, centroid_count_3_AW, centroid_count_3_JP] = generate_f1_score(im_train_3_AW,im_train_3_JP,Params_3_AW.sphere_sz,Params_3_JP.sphere_sz);
[f1max_chunck_4_sphere_sz_0, f1max_chunck_4_sphere_sz_1, centroid_count_4_AW, centroid_count_4_JP] = generate_f1_score(im_train_4_AW,im_train_4_JP,Params_4_AW.sphere_sz,Params_4_JP.sphere_sz);

%% Check the padding of the second set
[f1max_chunck_2_padded_sphere_sz_0, f1max_chunck_2_padded_sphere_sz_1, centroid_count_2_AW_padded, centroid_count_2_JP_padded] = generate_f1_score(im_train_2_AW,im_train_2_JP,Params_2_AW.sphere_sz,Params_2_JP.sphere_sz,0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% now run cell detection on entire image w/ selected hyperparameters
%%
Params = Params_1_JP;
image = large_image;
if o ~= 0
    [CellMapErode] = gmm(image, Params.numsamp, Params.numcomp, Params.erode_size);
else
    CellMapErode = image;
end
im2 = ones(size(CellMapErode,1),size(CellMapErode,2));

% make image fully binary
for i=1:size(image,1)
    for j=1:size(image,2)
        if (CellMapErode(i,j) > .7)
            im2(i,j) = 1;
        else
            im2(i,j) = 0;            
        end
    end 
end

num_of_area_to_remove = 2;
figure, 
subplot(1,num_of_area_to_remove+1,1),
imshow(CellMapErode);
biggest_areas = [];
for i=1:num_of_area_to_remove
    CC=bwconncomp(im2);
    numPixels = cellfun(@numel,CC.PixelIdxList);
    [biggest,idx] = max(numPixels);
    biggest_areas = [biggest_areas biggest];
    im2(CC.PixelIdxList{idx}) = 0;
    CellMapErode(CC.PixelIdxList{idx}) = 0;
    subplot(1,num_of_area_to_remove+1,i+1),
    imshow(CellMapErode) 
end

%%

%% zero pad around the image

[h_CellMapErode, w_CellMapErode] = size(CellMapErode);

round_num = 1000.;

hh = round_num*(ceil(h_CellMapErode/round_num));
ww = round_num*(ceil(w_CellMapErode/round_num));

% pad around the matrix
CellMapErode_padded = zeros(hh, ww);
CellMapErode_padded(1:h_CellMapErode, 1:w_CellMapErode) = CellMapErode;


%% run long test on cell detection
tic;
maxnumcells = 200000;
cores = 4;
num_of_blocks = 100;
%[Centroids,Nmap] = OMP_ProbMap2D(im2,Params.p_threshold,Params.p_residual,Params.sphere_sz,Params.dilate_sz,maxnumcells);
[Centroids_best,Nmap_chuncks,BlockPos] = OMP_ProbMap2D_parfor(CellMapErode_padded,Params.p_threshold,Params.p_residual,Params.sphere_sz,Params.dilate_sz,maxnumcells,cores,num_of_blocks,1); 

% recombine
Nmap0 = combine_celldetect_blocks(Centroids_best,BlockPos,size(CellMapErode));
% unpad the matrix
Nmap_full = Nmap0(1:h_CellMapErode, 1:w_CellMapErode);
toc;


%% graph

figure,
subplot(1,4,1), imshow(image), title('Original Image')
subplot(1,4,2), imshow(CellMapErode), title(sprintf('Prob Map, F1 score: %f, Erode: %i ', Params.f1max, Params.erode_size))
subplot(1,4,3), imshow(Nmap_full), title(sprintf('Nmap, cells: %d', nnz(Nmap_full)))
subplot(1,4,4), imshow(image),
ylim([0 size(Nmap_full,1)])
xlim([0 size(Nmap_full,2)])
stats = [];
diameter = 2;
for i=1:size(Nmap_full,1)
    for j=1:size(Nmap_full,2)
        if Nmap_full(i,j) == 1
           stats = [stats; j i diameter]; 
        end
    end
end
viscircles(stats(:,1:2) , stats(:,3) ); %overlaying the predicted cells
title(sprintf('Overlaid Predictions on Original Image w/ cell diameter: %i', diameter))

%% save data

d = datetime('today');
DateNumber = datenum(d);
formatIn = 'mm_dd_yyyy';
str = datestr(DateNumber,formatIn);
file_name = sprintf('%s_01.mat', str)
save(file_name);



%EOF
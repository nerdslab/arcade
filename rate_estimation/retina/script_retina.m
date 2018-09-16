% script_retina

%% init

im_retina = imread('2743section3-1 rd10P18.jpg');
im_retina2 = padarray(im_retina,[hyp hyp],255,'both');


im_r = im_retina(:,:,1);
im_g = im_retina(:,:,2);
im_b = im_retina(:,:,3);

im2 = im_g+(255-im_g(1,end));
im3 = padarray(im2,[hyp hyp],255,'both');


%% estimate the surface

[h, w] = size(im2);
m = 0.09615384615;
b = 375;
x = 1:5:w;
y = m*x + b;

%graph line estimating surface
figure,
imshow(im_retina), axis on
hold on,
scatter(x,y,'r');

points = [];
for i = 1:length(x)
    points = [points; x(i) y(i) m -(1/m) (90 - atand(-(1/m)))];
end

% I have all of the points for the patches in order now :)


%% cell detection


%% load in retina annos

im_retina_ilastik = imread('Nmap_retina.tiff');

%ground_truth_5_TL = load_nii('retina_y_630_779_x_650_799_TL_anno.nii');
ground_truth_5_TL = load_nii('retina_y_900_1050_x_650_800_TL_anno.nii.gz');
im_train_5_TL = im2double(ground_truth_5_TL.img);
%im_train_5_TL = rot90(flipud(im_train_5_TL),-1);
col_idx_5 = [900 1050]; 
row_idx_5 = [650 800];

%ground_truth_6_TL = load_nii('retina_y_800_899_x_800_899_TL_anno.nii');
ground_truth_6_TL = load_nii('retina_y_400_550_x_790_940_TL_anno.nii.gz');
im_train_6_TL = im2double(ground_truth_6_TL.img);
%im_train_6_TL = rot90(flipud(im_train_6_TL),-1);
col_idx_6 = [400 550]; 
row_idx_6 = [790 940];

%%
im2;

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

%% params for retina layer 1/2

p_threshold = [0.75:0.1:0.85];
p_residual = [0.15:0.1:0.25];
sphere_sz = [19:21];
dilate_sz = 9:11;
max_numcells = 100;
NumIter = prod([length(p_threshold),length(p_residual),length(sphere_sz),length(dilate_sz)]);


%% retina validation layer 1/2
im_test_retina_5 = im2double(im_retina(row_idx_5(1):row_idx_5(2),col_idx_5(1):col_idx_5(2)));
[Params_5_TL,f1_mat_5_TL] = hyperparam_celldetect(im_test_retina_5,im_train_5_TL,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells);
Params_5_TL

%% params for retina layer 3

p_threshold = [0.2:0.05:0.35];
p_residual = [0.15];
sphere_sz = [7:2:13];
dilate_sz = 3:5;
numsamp = 5e5;
numcomp = 2;
erode_sz = [0:2];
max_numcells = 300;
NumIter = prod([length(p_threshold),length(p_residual),length(sphere_sz),length(dilate_sz)]);


%% retina validation layer 3

im_test_retina_6 = im2double(im_retina(row_idx_6(1):row_idx_6(2),col_idx_6(1):col_idx_6(2)));
[Params_6_TL,f1_mat_6_TL] = hyperparam_celldetect(im_test_retina_6,im_train_6_TL,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells);
Params_6_TL

%%

[all_f1_scores_5_TL, check_5_TL, max_num_5_TL] = plot_f1_scores(Params_5_TL,f1_mat_5_TL,p_threshold,p_residual,sphere_sz,dilate_sz);
[all_f1_scores_6_TL, check_6_TL, max_num_6_TL] = plot_f1_scores(Params_6_TL,f1_mat_6_TL,p_threshold,p_residual,sphere_sz,dilate_sz);

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


%% calculate for all of the cells 
%im_retina_ilastik = imread('Nmap_retina.tiff');

figure,
imshow(im_retina_ilastik), axis on
hold on,
scatter(x,y,'r');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
%top right rate estimation

hyp = 561;
patch_size = 60;

pointss = points;
for i = 1:size(points, 1)
    a = points(i,1) + hyp;
    b = points(i,2) + hyp;
    pointss(i,1) = a;
    pointss(i,2) = b;
end

%point = pointss(20,:);


im_retina_ilastik;


im_padded_retina = padarray(im_retina,[hyp hyp],1,'both');
im_padded_prob = padarray(im_retina_ilastik,[hyp hyp],0,'both');

radius_overlaid = 6;
ds = 3; %downsample rows to bin cell counts
threshold_for_transitions = .002;
space_btw_next_trans = 80;
disflag = 0;
maxIter = 100;%
lambda_start = 55;  
lambda_step = 5e-1;
K = 10;


rate_est_ind_all = zeros(size(pointss,1), (hyp/ds)-1);
xest_indep_all = zeros(size(pointss,1), (hyp/ds)-1);
all_cell_counts_all = zeros(size(pointss,1), (hyp/ds)-1);
parfor q = 1:size(pointss,1)
    point = pointss(q,:);
    [point, end_point, region] = defineregions(im_padded_retina, point, patch_size, hyp,1);
    [patch_mx, ~] = generatepatch(im_padded_retina, region, point, patch_size, hyp,1);
    [patch_mx_probmap, ~] = generatepatch(im_padded_prob, region, point, patch_size, hyp,1);
    patch_mx_probmap_rotate = imrotate(patch_mx_probmap,90);
    CC = patch_mx_probmap_rotate;
    BW = bwconncomp(CC);
    s = regionprops(BW,'centroid');
    centroids = cat(1, s.Centroid);
    radii = ones(size(centroids,1),1).*radius_overlaid;

    %step3
    [cell_counts] = cellcount(patch_mx_probmap);
    [downsampled_mx] = downsamp(cell_counts, ds);
    all_cell_counts = downsampled_mx;
    N = size(all_cell_counts,1); % discretization levels (should be bigger than nblk)
    regfactor = 4e-1; % for independent case
    dbasis = cumsum(eye(N),1);

    A1 = dbasis;
    b1 = sum(A1,1)';
    all_cell_counts_all(q,:) = all_cell_counts;


    xest_indep = solve_poisson_ksparse(all_cell_counts,A1,b1,K,'indep',maxIter,lambda_start,lambda_step,'cells');
    z = zeros(size(xest_indep));
    xest_indep(50:end,1:end-50) = z(50:end,1:end-50);
    rate_est_ind = A1 * xest_indep;
    xest_indep_all(q,:) = xest_indep';
    rate_est_ind_all(q,:) = rate_est_ind';
    disp([newline, newline, 'Finished patch: ', num2str(q), '/',num2str(size(pointss,1)),newline, newline])

end
%% graph
figure,
subplot(4,1,1),
imshow(imrotate(patch_mx(:,:,2),90)); %axis equal
viscircles(centroids, radii, 'LineWidth', 1);
s = "Overlaid with detected cells";
xlabel(s),set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);

subplot(4,1,2),
plot(rate_est_ind,'g'),
xlim([0 hyp/ds]), 
s = "Estimated density rate - poisson";
xlabel(s), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]),
box off,

subplot(4,1,3),
plot(xest_indep,'g'),
xlim([0 hyp/ds]), 
s = "Estimated transitions";
xlabel(s), axis on, %set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]),
box off;


subplot(4,1,4),
th = .5;
xest_indep_locations = abs(xest_indep)>.001;
%transition_points = [];
h = imshow(patch_mx(:,:,1));
[~,~,transition_points,~] = peakdet(xest_indep_locations, th, 'threshold', 30);
%{
prev_trans = 0;
for i = 1:length(xest_indep_locations)
    if xest_indep_locations(i) == 1
        if prev_trans == 0
            transition_points = [transition_points i*ds];
            prev_trans = 1;
        elseif i*ds > (prev_trans + space_btw_next_trans)
            transition_points = [transition_points i*ds];
            prev_trans = i*ds;
        end

    end
end
%}
for j = 1:length(transition_points)
    hold on,
    hline = refline([0 transition_points(j)*ds]);
    hline.Color = 'r';
    set(hline,'LineWidth',2);
end
ylabel('Transitions Overlaid - poisson'),set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
camroll(90);

%% graph all
figure, 
subplot(4,1,1),
for i = 1:size(rate_est_ind_all,1)
    plot(rate_est_ind_all(i,:)), hold on,
    
end
xlim([0 size(rate_est_ind_all,2)]),
subplot(4,1,2),
for i = 1:size(xest_indep_all,1)
    plot(abs(xest_indep_all(i,:))), hold on,
    
end
xlim([0 size(xest_indep_all,2)]),


%% single overlay
dir = 1;
x_all = [];
y_all = [];
transition_points_intensity = [];



for w = 1:size(xest_indep_all, 1)
    point = pointss(w,:);
    xest_indep_locations = abs(xest_indep_all(w,:))>threshold_for_transitions;
    transition_points = [];


    prev_trans = 0;
    for i = 1:length(xest_indep_locations)
        if xest_indep_locations(i) == 1
            if prev_trans == 0
                transition_points = [transition_points i*ds];
                transition_points_intensity = [transition_points_intensity abs(rate_est_ind_all(w,i))];
                prev_trans = 1;
            elseif i*ds > (prev_trans + space_btw_next_trans)
                transition_points = [transition_points i*ds];
                transition_points_intensity = [transition_points_intensity abs(rate_est_ind_all(w,i))];
                prev_trans = i*ds;
            end

        end
    end

    for i = 1:length(transition_points)
        switch(dir)
            case 1
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 5);
                x_all = [x_all x1];
                y_all = [y_all y1];
            case 2
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 6);
                x_all = [x_all x1];
                y_all = [y_all y1]; 
            case 3
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 7);
                x_all = [x_all x1];
                y_all = [y_all y1];      
            case 4
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 8);
                x_all = [x_all x1];
                y_all = [y_all y1]; 
        end
    end
end

%
figure, imshow(im_padded_retina), hold on,
c = transition_points_intensity;
%c = (c./max(c));
scatter(x_all, y_all,40,c,'filled')
xlim([hyp size(im_padded_retina, 2)-hyp]);
ylim([hyp size(im_padded_retina, 1)-hyp]);
axis off;

%%
Y = [rate_est_ind_all];
%figure, imagesc(Y(20:end-20,:)')
%set(gca, 'XDir','reverse')

figure, imagesc(corr(Y(20:end-20,:)'));


%%


%[patch_mx_retina_prob, point_retina_prob, end_point_retina_prob] = extracting_patches(x+hyp, pointss, im_padded_prob, patch_size, hyp, 1);

[x_all_top_right, y_all_top_right] = generateallpoints(patch_mx_retina_prob, patch_mx_retina_prob , point_retina_prob, end_point_retina_prob, 1);
%%

figure, imshow(im_padded_retina(hyp:end-hyp,hyp:end-hyp,:)),
for i = 1:length(x_all_top_right)
    hold on, plot(x_all_top_right(i)-hyp, y_all_top_right(i)-hyp,'r.','MarkerSize',21),
end

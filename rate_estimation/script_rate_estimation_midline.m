%% Doing the rate estimation on the full image - combining all of the things

%% need to load in the data

load('patch_extraction_09_16_2018.mat');
load('05_09_2018_02');

%% init

% regular patches
patch_mx_top_right;    %Q1
patch_mx_top_left;     %Q2
patch_mx_bottom_left;  %Q3
patch_mx_bottom_right; %Q4


%prob map patches
patch_mx_top_right_prob;
patch_mx_top_left_prob;
patch_mx_bottom_left_prob;
patch_mx_bottom_right_prob;

%prob map patches
patch_mx_top_right_atlas;
patch_mx_top_left_atlas;
patch_mx_bottom_left_atlas;
patch_mx_bottom_right_atlas;

%%

figure, 
subplot(1,2,1), imshow(patch_mx_top_left(:,:,399)),
subplot(1,2,2), imagesc(patch_mx_top_left_prob(:,:,399));

%%
%p1 = 90:234;
%p2 = 235:399;
p1 = 134:234;
p2 = 235:334;
figure,
imshow(im2), hold on,
px = point_top_left(:,1,p1);
py = point_top_left(:,2,p1);
ex = end_point_top_left(:,1,p1);
ey = end_point_top_left(:,2,p1);
for i = 1:length(p1)
    if i == 1
        pp1 = plot(px(i),py(i),'r*'); hold on,
        pp3 = plot(ex(i),ey(i),'r*'); hold on
    else
        plot(px(i),py(i),'r*'), hold on,
        plot(ex(i),ey(i),'r*'), hold on,
    end
end

px = point_top_left(:,1,p2);
py = point_top_left(:,2,p2);
ex = end_point_top_left(:,1,p2);
ey = end_point_top_left(:,2,p2);
for i = 1:length(p2)
    if i == 1
        pp2 = plot(px(i),py(i),'b*'); hold on,
        pp4 = plot(ex(i),ey(i),'b*'); hold on,
    else
        plot(px(i),py(i),'b*'), hold on,
        plot(ex(i),ey(i),'b*'), hold on,        
    end
end
legend([pp1 pp2],{'SSp','SSs'})

%% hardcoded

%hardcoded values
%x_point_of_interests = 47:123; % I believe the figure 3 patch was 1600,1650,1850,1851. However, none of these are annotated for ground truth by Judy. We choise 1400 initiall because it was more symetric on the overview figure. I will see if I can find the correct patch and ask Judy if she could annotate it to see if it is mostly correct. Or even look at Allen's Brain Atlas.
x_point_of_interests = 1;%134:264; 
%x_point_of_interests = 105;
radius_overlaid = 7;
ds = 3; %downsample rows to bin cell counts
threshold_for_transitions = .01;
space_btw_next_trans = 30;
disflag = 0;
maxIter = 100;%
lambda_start = 5;  
lambda_step = 5e-2;
K = 10;
sigma = 18;

%
rate_est_ind_all = zeros(length(x_point_of_interests), (hyp/ds)-1);
xest_indep_all = zeros(length(x_point_of_interests), (hyp/ds)-1);
all_cell_counts_all = zeros(length(x_point_of_interests), (hyp/ds)-1);
pixel_counts_all = zeros(length(x_point_of_interests), (hyp/ds)-1);
for q = 1:length(x_point_of_interests)
    x_point_of_interest = x_point_of_interests(q);
    %step2
    patch_mx = patch_mx_top_left(:,:,x_point_of_interest);
    patch_mx_probmap = patch_mx_top_left_prob(:,:,x_point_of_interest);
    %patch_mx_atlas = patch_mx_top_right_atlas(:,:,x_point_of_interest);
    point = point_top_left(:,:,x_point_of_interest);
    end_point = end_point_top_left(:,:,x_point_of_interest);

    patch_mx_probmap_rotate = imrotate(patch_mx_probmap,90);
    CC = patch_mx_probmap_rotate;
    BW = bwconncomp(CC);
    s = regionprops(BW,'centroid');
    centroids = cat(1, s.Centroid);
    radii = ones(size(centroids,1),1).*radius_overlaid;

    %step3
    [cell_counts] = cellcount(patch_mx_probmap);
    [downsampled_mx] = downsamp(cell_counts, ds);
    %[pixel_counts] = collapsepixels(patch_mx, sigma);
    %[downsampled_mx] = downsamp(pixel_counts, ds);
    
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
    pixel_counts_all(q,:) = downsampled_mx';
    disp([newline, newline, 'Finished patch: ', num2str(q), '/',num2str(length(x_point_of_interests)),newline, newline])

end


% graph
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
%{
subplot(4,1,3),
imshow(imrotate(patch_mx,90)); %axis equal
viscircles(centroids, radii, 'LineWidth', 1);




subplot(4,1,4),
%imshow(imrotate(patch_mx,90)); %axis equal
xest_indep_locations = abs(xest_indep)>threshold_for_transitions;
transition_points = [];
h = imshow(patch_mx);

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
for j = 1:length(transition_points)
    hold on,
    hline = refline([0 transition_points(j)]);
    hline.Color = 'r';
    set(hline,'LineWidth',2);
end
camroll(90); % !!! COMMENT THIS LINE OUT IF YOU WANT TO SAVE INDIVIDUAL!!!
%}

%% 1
rate_est_ind_all_SSp = rate_est_ind_all(p1-min(p1)+1,:);
xest_indep_all_SSp = xest_indep_all(p1-min(p1)+1,:);
all_cell_counts_all_SSp = all_cell_counts_all(p1-min(p1)+1,:);

%% 2
rate_est_ind_all_SSs = rate_est_ind_all(p2-min(p1)+1,:);
xest_indep_all_SSs = xest_indep_all(p2-min(p1)+1,:);
all_cell_counts_all_SSs = all_cell_counts_all(p2-min(p1)+1,:);

%%
rate_est_ind_all_1_1 = zeros(size(rate_est_ind_all_1,1), size(rate_est_ind_all_3,2));
rate_est_ind_all_2_1 = zeros(size(rate_est_ind_all_2,1), size(rate_est_ind_all_3,2));

for i = 1:size(rate_est_ind_all_1,1)
    for j = 1:size(rate_est_ind_all_1,2)
        rate_est_ind_all_1_1(i,j) = rate_est_ind_all_1(i,j);       
    end   
end
for i = 1:size(rate_est_ind_all_2,1)
    for j = 1:size(rate_est_ind_all_2,2)
        rate_est_ind_all_2_1(i,j) = rate_est_ind_all_2(i,j);       
    end   
end


figure,
subplot(3,1,1),
for i = 1:size(rate_est_ind_all_3,1)
    plot(rate_est_ind_all_3(i,:)), hold on,
    
end
subplot(3,1,2),
for i = 1:size(rate_est_ind_all_1_1,1)
    plot(rate_est_ind_all_1_1(i,:)), hold on,
    
end
subplot(3,1,3),
for i = 1:size(rate_est_ind_all_2_1,1)
    plot(rate_est_ind_all_2_1(i,:)), hold on,
    
end

r = [rate_est_ind_all_1_1; rate_est_ind_all_2_1; rate_est_ind_all_3];

%%
Y = [r];
figure, imagesc(Y')
set(gca, 'XDir','reverse')

figure, imagesc(corr(Y));

%%
save('rates_cells_6_27_2018_01.mat', 'rate_est_ind_all_SSp', 'rate_est_ind_all_SSs', 'xest_indep_all_SSp','xest_indep_all_SSs', 'all_cell_counts_all_SSp','all_cell_counts_all_SSs');

%% SSp
figure, 
subplot(2,1,1),
for i = 1:size(rate_est_ind_all_SSp,1)
    plot(rate_est_ind_all_SSp(i,:)), hold on,
    ylim([0 .9]), hold on,
end
subplot(2,1,2),
for i = 1:size(xest_indep_all_SSp,1)
    plot(xest_indep_all_SSp(i,:)), hold on,
    ylim([-.3 .6]), hold on,
end
xlabel('SSp Region');

%% SSs
figure, 
subplot(2,1,1),
for i = 1:size(rate_est_ind_all_SSs,1)
    plot(rate_est_ind_all_SSs(i,:)), hold on,
    ylim([0 .9]), hold on,
end
subplot(2,1,2),
for i = 1:size(xest_indep_all_SSs,1)
    plot(xest_indep_all_SSs(i,:)), hold on,
    ylim([-.3 .6]), hold on,
end
xlabel('SSs Region');


%% single overlay
dir = 1;
x_all_SSp = [];
y_all_SSp = [];
transition_points_intensity = [];



for w = 1:size(xest_indep_all, 1)
    point = point_top_left_prob(:,:,min(x_point_of_interests)+w);
    end_point = end_point_top_left_prob(:,:,min(x_point_of_interests)+w);
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
                x_all_SSp = [x_all_SSp x1];
                y_all_SSp = [y_all_SSp y1];
            case 2
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 6);
                x_all_SSp = [x_all_SSp x1];
                y_all_SSp = [y_all_SSp y1]; 
            case 3
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 7);
                x_all_SSp = [x_all_SSp x1];
                y_all_SSp = [y_all_SSp y1];      
            case 4
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 8);
                x_all_SSp = [x_all_SSp x1];
                y_all_SSp = [y_all_SSp y1]; 
        end
    end
end


figure, imshow(im8), hold on,
c = transition_points_intensity;
%c = (c./max(c));
scatter(x_all_SSp, y_all_SSp,40,c,'filled')

%%

x_all_SSp_1 = x_all_SSp;
y_all_SSp_1 = y_all_SSp;
transition_points_intensity_1 = transition_points_intensity;
rate_est_ind_all_1 = rate_est_ind_all;
xest_indep_all_1 = xest_indep_all;

%%
t = [transition_points_intensity_1 transition_points_intensity_2 transition_points_intensity_3];
t = t./max(t);
x = [x_all_SSp_1 x_all_SSp_2-51 x_all_SSp_3-111];
y = [y_all_SSp_1 y_all_SSp_2-51 y_all_SSp_3-111];


figure, imshow(im8), hold on,
scatter(x, y,60,t,'filled','MarkerEdgeColor', 'k')


%%

figure, imshow(im8), hold on,
scatter(x_all_SSp_1, y_all_SSp_1,40,transition_points_intensity_1,'filled','MarkerEdgeColor', 'k')
scatter(x_all_SSp_2-51, y_all_SSp_2-51,40,transition_points_intensity_2,'filled','MarkerEdgeColor', 'k')
scatter(x_all_SSp_3-111, y_all_SSp_3-111,40,transition_points_intensity_3,'filled','MarkerEdgeColor', 'k')


%% double overlay
dir = 1;
x_all_SSp = [];
y_all_SSp = [];
x_all_SSs = [];
y_all_SSs = [];

for w = 1:size(xest_indep_all_SSs, 1)
    point = point_top_left_prob(:,:,min(p2)+w);
    end_point = end_point_top_left_prob(:,:,min(p2)+w);
 xest_indep_locations = abs(xest_indep_all_SSs(w,:))>threshold_for_transitions;
    transition_points = [];

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

    for i = 1:length(transition_points)
        switch(dir)
            case 1
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 5);
                x_all_SSs = [x_all_SSs x1];
                y_all_SSs = [y_all_SSs y1];
            case 2
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 6);
                x_all_SSs = [x_all_SSs x1];
                y_all_SSs = [y_all_SSs y1]; 
            case 3
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 7);
                x_all_SSs = [x_all_SSs x1];
                y_all_SSs = [y_all_SSs y1];      
            case 4
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 8);
                x_all_SSs = [x_all_SSs x1];
                y_all_SSs = [y_all_SSs y1]; 
        end
    end
end

for w = 1:size(xest_indep_all_SSp, 1)
    point = point_top_left_prob(:,:,min(p1)+w);
    end_point = end_point_top_left_prob(:,:,min(p1)+w);
 xest_indep_locations = abs(xest_indep_all_SSp(w,:))>threshold_for_transitions;
    transition_points = [];

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

    for i = 1:length(transition_points)
        switch(dir)
            case 1
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 5);
                x_all_SSp = [x_all_SSp x1];
                y_all_SSp = [y_all_SSp y1];
            case 2
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 6);
                x_all_SSp = [x_all_SSp x1];
                y_all_SSp = [y_all_SSp y1]; 
            case 3
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 7);
                x_all_SSp = [x_all_SSp x1];
                y_all_SSp = [y_all_SSp y1];      
            case 4
                [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 8);
                x_all_SSp = [x_all_SSp x1];
                y_all_SSp = [y_all_SSp y1]; 
        end
    end
end

figure, imshow(im2),

for i = 1:length(x_all_SSs)
    hold on, plot(x_all_SSs(i), y_all_SSs(i),'r.'), hold on,
end
for i = 1:length(x_all_SSp)
    hold on, plot(x_all_SSp(i), y_all_SSp(i),'b.'), hold on,
end

%%%%%%%%%%%
%%%%%%%%%%%
%%%%%%%%%%%
%%

figure,
% patch, a la carte
subplot(6,3,1:3),
imshow(imrotate(patch_mx,90)); %axis equal
s = "PIA  ~~~         Patch " + num2str(x_point_of_interest) + "      ~~~  LAYER 6";
xlabel(s),set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);


% patch overlaid with cells 
%figure,
subplot(6,3,4:6),
imshow(imrotate(patch_mx,90)); %axis equal
viscircles(centroids, radii, 'LineWidth', 1);
s = "Overlaid with detected cells";
xlabel(s),set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);



% rate estimation
%figure,
subplot(6,3,7:9),
plot(rate_est_ind,'g'),
xlim([0 hyp/ds]), 
s = "Estimated rate of cell density";
xlabel(s), 
%set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]),
box off, axis on,


% rate estimation of transitions
%figure,
subplot(6,3,10:12),
plot(xest_indep,'g'),
xlim([0 hyp/ds]), 
s = "Estimated transitions";
xlabel(s), set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]),
box off;


% estimated transitions overlaid on original image
%figure,
subplot(6,3,13:15),
xest_indep_locations = abs(xest_indep)>threshold_for_transitions;
transition_points = [];
h = imshow(patch_mx(:,:,1));

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
for j = 1:length(transition_points)
    hold on,
    hline = refline([0 transition_points(j)]);
    hline.Color = 'r';
    set(hline,'LineWidth',2);
end

%{
for i = 1:length(xest_indep_locations)
    hold on,
    if xest_indep_locations(i) == 1
        transition_points = [transition_points i*ds];
        transition_points = [transition_points i*ds];
        hline = refline([0 i*ds]);
        hline.Color = 'r';
        set(hline,'LineWidth',2);    
    end
end
%}

ylabel('Estimated Transitions Overlaid'),set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);
camroll(90); % !!! COMMENT THIS LINE OUT IF YOU WANT TO SAVE INDIVIDUAL!!!

subplot(6,3,16:18),
imshow(imrotate(patch_mx_atlas,90)); %axis equal
s = "PIA  ~~~         Patch " + num2str(x_point_of_interest) + "      ~~~  LAYER 6";
xlabel(s),set(gca,'xtick',[],'xticklabel',[],'ytick',[],'yticklabel',[]);



%% more now...

figure,
imshow(im2),
hold on, plot(point(1,1), point(1,2),'r*')
hold on, plot(end_point(1,1),end_point(1,2),'g*'),
dir = 1;

for i = 1:length(transition_points)
    switch(dir)
        case 1
            [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 5);
            end_point = [x1,y1];      
        case 2
            [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 6);
            end_point = [x1,y1]; 
        case 3
            [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 7);
            end_point = [x1,y1];      
        case 4
            [x1,y1,~,~] = generatecoordinate(point(1), point(2), point(4), transition_points(i)*2, 8);
            end_point = [x1,y1]; 
    end
    
    hold on, plot(x1, y1,'m*'),    
end




%% graph graph
% start 1:45
% end   
figure, imshow(im_atlas),


% Q1
[x_all_top_right, y_all_top_right] = generateallpoints(patch_mx_top_right(:,:,960:999), patch_mx_top_right_prob(:,:,960:999), point_top_right(:,:,960:999), end_point_top_right(:,:,960:999), 1);

%for i = 1:size(patch_mx_top_right,3)
%    hold on, plot(point_top_right(1,1,i), point_top_right(1,2,i),'r*'),
%    hold on, plot(end_point_top_right(1,1,i),end_point_top_right(1,2,i),'g*'),
%end
for i = 1:length(x_all_top_right)
    hold on, plot(x_all_top_right(i), y_all_top_right(i),'m.'),
end

%{
% Q2

[x_all_top_left, y_all_top_left] = generateallpoints(patch_mx_top_left, patch_mx_top_left_prob , point_top_left, end_point_top_left, 2);

%for i = 1:size(patch_mx_top_left,3)
%    hold on, plot(point_top_left(1,1,i), point_top_left(1,2,i),'r*'),
%    hold on, plot(end_point_top_left(1,1,i),end_point_top_left(1,2,i),'g*'),
%end
for i = 1:length(x_all_top_left)
    hold on, plot(x_all_top_left(i), y_all_top_left(i),'m*'),
end

% Q3
[x_all_bottom_left, y_all_bottom_left] = generateallpoints(patch_mx_bottom_left, patch_mx_bottom_left_prob , point_bottom_left, end_point_bottom_left, 3);

%for i = 1:size(patch_mx_bottom_left,3)
%    hold on, plot(point_bottom_left(1,1,i), point_bottom_left(1,2,i),'r*'),
%    hold on, plot(end_point_bottom_left(1,1,i),end_point_bottom_left(1,2,i),'g*'),
%end
for i = 1:length(x_all_bottom_left)
    hold on, plot(x_all_bottom_left(i), y_all_bottom_left(i),'m*'),
end

%}
%{
% Q4
[x_all_bottom_right, y_all_bottom_right] = generateallpoints(patch_mx_bottom_right, patch_mx_bottom_right_prob , point_bottom_right, end_point_bottom_right, 4);

%for i = 1:size(patch_mx_bottom_right,3)
%    hold on, plot(point_bottom_right(1,1,i), point_bottom_right(1,2,i),'r*'),
%    hold on, plot(end_point_bottom_right(1,1,i),end_point_bottom_right(1,2,i),'g*'),
%end
for i = 1:length(x_all_bottom_right)
    hold on, plot(x_all_bottom_right(i), y_all_bottom_right(i),'m.'),
end
%}
%EOF

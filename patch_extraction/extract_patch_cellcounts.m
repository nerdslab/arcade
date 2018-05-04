function [all_cell_counts] = extract_patch_cellcounts(im0,Nmap0,patch_width,patch_length,ndsamp,stepsz,thresh,parflag)

hyp = patch_length;
pool_sz = 4; %works for standard comp with i7 and higher

Mask = findbrainboundary(im0,thresh);
[Gx, Gy] = imgradientxy(Mask,'prewitt');

boundary = (abs(Gx) + abs(Gy));

%padding image array to account for boundary issues
boundary = padarray(boundary,patch_length,0);  %1
boundary = padarray(boundary',patch_length,0); %2
boundary = boundary';                          %3


im1 = padarray(im0,patch_length,255); %1
number_of_im1s = size(im1, 3);
%for some reason, this does not process all of the images
for i=1:number_of_im1s
    im2(:,:,i) = padarray(im1(:,:,i)',patch_length,255); %2
end 

number_of_im2s = size(im2, 3);
for i=1:number_of_im2s
    im3(:,:,i) = im2(:,:,i)'; %3
end


Nmap = padarray(Nmap0,patch_length,0); %1
Nmap = padarray(Nmap',patch_length,0); %2
Nmap = Nmap';                          %3



[edge_dir_row, edge_dir_col, edge_dir_val] = find(boundary);
outline = [edge_dir_col, edge_dir_row, edge_dir_val];
outline_of_brain = [];

for k = min(outline(:,1)):max(outline(:,1))
    l = find(outline(:,1) == k, 1, 'first');
    outline_of_brain = [outline_of_brain; outline(l,1:2)];
end

p = polyfit(outline_of_brain(:,1), outline_of_brain(:,2), 12);
[outline_of_brain_with_slopes] = generateslopes(p, outline_of_brain);

%{
figure, imshow(im3(:,:,1));
axis on,
x1 = linspace(min(outline_of_brain(:,1)), max(outline_of_brain(:,1)));
y1 = polyval(p,x1);
hold on, scatter(outline_of_brain_with_slopes(:,1), outline_of_brain_with_slopes(:,2))
hold on, plot(x1, y1);
%}


%%

% init::arbitary patch size to start
which_idx = (min(outline_of_brain_with_slopes(:,1))+ceil(patch_width/2)):...
            (stepsz):...
            (max(outline_of_brain_with_slopes(:,1))-ceil(patch_width/2));

all_cell_counts = zeros(floor((hyp+1)/ndsamp),length(which_idx));

% this is for iterative processing 
if parflag~=1
    for m = 1:length(which_idx)
        x_point_of_interest = which_idx(m);
        point = ...
            outline_of_brain_with_slopes(outline_of_brain_with_slopes(:,1) ...
            == x_point_of_interest, :);

        [point, ~,region] = defineregions(im3, point, patch_width, hyp);             
        [patch_mx] = generatepatch(Nmap, region, point, patch_width, hyp);
        [cell_counts] = cellcount(patch_mx);
        [downsampled_mx] = downsamp(cell_counts, ndsamp);
        all_cell_counts(:,m) = downsampled_mx;
        display(['Iteration = ', int2str(m)])
    end
    
    
% when you actually want to create a pool and whatnot  
else
    p = gcp('nocreate');
    if isempty(p)
        parpool(pool_sz)
    end
    parfor m = 1:length(which_idx)    
        x_point_of_interest = which_idx(m);
        point = ...
            outline_of_brain_with_slopes(outline_of_brain_with_slopes(:,1) ...
            == x_point_of_interest, :);

        [point, ~,region] = defineregions(im3, point, patch_width, hyp);             
        [patch_mx] = generatepatch(Nmap, region, point, patch_width, hyp);
        [cell_counts] = cellcount(patch_mx);
        [downsampled_mx] = downsamp(cell_counts, ndsamp);
        all_cell_counts(:,m) = downsampled_mx;
        display(['Iteration = ', int2str(m)])
    end

end


end
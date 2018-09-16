%%%%%%%%%%%%%%%%%%%%%%
% OMP_ProbMap.m = function to detect cells and return their centroids
%%%
% Input
%%%
% Prob = Nr x Nc x Nz matrix which contains the probability of each voxel being a cell body. (i.e., the (r,c,z) position of Prob contains the probability that the (r,c,z) voxel of an image cube lies within a cell body.)
% ptr = threshold between (0,1) to apply to probability map (only consider voxels for which Prob(r,c,z) > ptr)
% presid = stopping criterion is a value between (0,1) (minimum normalized correlation between template and probability map) (Example = 0.47)
% startsz = initial size of spherical template (to use in sweep)
% dilatesz = size to increase mask around each detected cell (zero out sphere of radius startsz+dilatesz around each centroid)
% kmax = maximum number of cells (alternative stopping criterion)
%%%
% Output
%%%
% Centroids = D x 4 matrix, where D = number of detected cells. 
%             The (x,y,z) coordinate of each cell are contained in columns 1-3. 
%             The fourth column contains the correlation (ptest) between the template 
%             and probability map and thus represents our "confidence" in the estimate. 
%             The algorithm terminates when ptest<=presid.
% Nmap = Nr x Nc x Nz matrix containing labeled detected cells (1,...,D)
%%%%%%%%%%%%%%%%%%%%%%

function [Centroids,Nmap,BlockPos] = OMP_ProbMap2D_parfor(Prob,ptr,presid,startsz,dilatesz,kmax,numblocks,overlapsz,dispflag)

if nargin<9
    dispflag=1;
end

% threshold probability map
Prob = Prob.*(Prob>ptr);

% create dictionary of spherical templates
box_radius = ceil(max(startsz)/2) + 1;
Dict = create_synth_dict_2D(startsz,box_radius);
Ddilate = create_synth_dict_2D(startsz+dilatesz,box_radius);
Lbox = round(length(Dict)^(1/2));


[sz1, sz2] = size(Prob);
S1 = ceil(sz1/sqrt(numblocks));
S2 = ceil(sz2/sqrt(numblocks));

% split up image into non-overlapping blocks
count=1;
for i=1:sqrt(numblocks)
    for j=1:sqrt(numblocks)
        BlockPos{count}.rowidx = max(1, (i-1)*S1 +1 - overlapsz): min(i*S1 + overlapsz,sz1);
        BlockPos{count}.colidx = max(1, (j-1)*S2 +1 - overlapsz): min(sz2,j*S2 + overlapsz);
        IM{count} = Prob(max(1, (i-1)*S1 +1 - overlapsz): min(i*S1 + overlapsz,sz1), max(1, (j-1)*S2 +1 - overlapsz): min(sz2,j*S2 + overlapsz));
        count = count+1;
    end
end

p = gcp('nocreate');
if isempty(p)
    parpool(numblocks)
end

Centroids = cell(numblocks,1);
Nmap = cell(numblocks,1);
parfor i = 1:numblocks        
    [Centroids{i}, Nmap{i}] = greedy_celldetect(IM{i},Dict,Ddilate,kmax,Lbox,presid,dispflag);
end

end






function [f1max_sphere_sz_0, f1max_sphere_sz_1, centroid_count_0, centroid_count_1] = generate_f1_score(improb0,improb1,Params0_sphere_sz,Params1_sphere_sz,padflag)
%GENERATE_F1_SCORE Summary of this function goes here
%   Detailed explanation goes here

if nargin<5
    padflag=1;
end

b=1;
CC_0 = bwconncomp(improb0);     
s_0  = regionprops(CC_0, 'centroid');
C0 = cat(1, s_0.Centroid);


CC_1 = bwconncomp(improb1);     
s_1  = regionprops(CC_1, 'centroid');
C1 = cat(1, s_1.Centroid);

if padflag == 0
    %zero padd the cells around the edge, max cell count pixels around the edge
    max_sphere_sz = max(Params0_sphere_sz,Params1_sphere_sz);
    C0_new = [];
    for i = 1:size(C0,1)
        curr_row = C0(i,:);
        if curr_row(1) > max_sphere_sz && curr_row(1) < size(improb0,1) - max_sphere_sz &&...
                curr_row(2) > max_sphere_sz && curr_row(2) < size(improb0,2) - max_sphere_sz
                C0_new = [C0_new; curr_row;];
        end
    end
    C0 = C0_new;

    C1_new = [];
    for i = 1:size(C1,1)
        curr_row = C1(i,:);
        if curr_row(1) > max_sphere_sz && curr_row(1) < size(improb1,1) - max_sphere_sz &&...
                curr_row(2) > max_sphere_sz && curr_row(2) < size(improb1,2) - max_sphere_sz
                C1_new = [C1_new; curr_row;];
        end
    end
    C1 = C1_new;
end

thresh = Params0_sphere_sz;
[~,TP,FP,FN,~] = centroiderror_missrates(C0',C1',thresh);
f1_mat = f1score(TP,FP,FN,b);
[~,idx] = max(f1_mat(:));
f1max_sphere_sz_0 = f1_mat(idx);

thresh = Params1_sphere_sz;
[~,TP,FP,FN,~] = centroiderror_missrates(C0',C1',thresh);
f1_mat = f1score(TP,FP,FN,b);
[~,idx] = max(f1_mat(:));
f1max_sphere_sz_1 = f1_mat(idx);

centroid_count_0 = size(C0, 1);
centroid_count_1 = size(C1, 1);

end


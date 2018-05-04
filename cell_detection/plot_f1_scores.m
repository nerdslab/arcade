function [all_f1_scores, check, max_num] = plot_f1_scores(Params,f1_mat,p_threshold,p_residual,sphere_sz,dilate_sz,numsamp,numcomp,erode_sz)
%PLOT_F1_SCORES Summary of this function goes here
%   Detailed explanation goes here
all_f1_scores = [];
I = length(p_threshold);
J = length(p_residual);
K = length(sphere_sz);
L = length(dilate_sz);
M = length(numsamp);
N = length(numcomp);
O = length(erode_sz);
a = 1;
max_num = [];
check = 0;

for m=1:M
    for n = 1:N       
        for o = 1:O
            for i=1:I
                for j = 1:J        
                    for k = 1:K
                        for l = 1:L
                            all_f1_scores = [all_f1_scores; a f1_mat(i,j,k,l,m,n,o);];
                            if Params.f1max == f1_mat(i,j,k,l,m,n,o)
                                max_num = [max_num a];
                                check = check + 1;
                            end
                            a = a + 1;                       
                        end
                    end
                end
            end
        end
    end   
end

end


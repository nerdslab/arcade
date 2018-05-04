function [Params,f1_mat] = hyperparam_celldetect(image,im_train,row_idx,col_idx,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells,numsamp,numcomp,erode_sz)

b=1;
CC = bwconncomp(im_train);     
s  = regionprops(CC, 'centroid');
C0_prev = cat(1, s.Centroid);


I = length(p_threshold);
J = length(p_residual);
K = length(sphere_sz);
L = length(dilate_sz);
M = length(numsamp);
N = length(numcomp);
O = length(erode_sz);

NumIter = prod([I,J,K,L,M,N,O]);

iter=0;
f1_mat = zeros(I,J,K,L,M,N,O);

% x-ray data test
%im_test = image;

for m=1:M
    for n = 1:N       
        for o = 1:O
            [CellMapErode] = gmm(image, numsamp(m), numcomp(n), erode_sz(o));                
            im_test = CellMapErode(row_idx(1):row_idx(2),col_idx(1):col_idx(2));
            for i=1:I
                for j = 1:J        
                    for k = 1:K
                        for l = 1:L
                            [Centroids,~] = OMP_ProbMap2D(im_test,p_threshold(i),p_residual(j),sphere_sz(k),dilate_sz(l),max_numcells,0);
                            C1_prev = Centroids(:, 1:2); %estimated cells
                            C1 = pad(C1_prev, sphere_sz(k), size(im_test,1), size(im_test,2));
                            C0 = pad(C0_prev, sphere_sz(k), size(im_train,1), size(im_train,2));
                            thresh = sphere_sz(k);
                            [~,TP,FP,FN,~] = centroiderror_missrates(C0',C1',thresh);
                            [f1_mat(i,j,k,l,m,n,o), ~, ~] = f1score(TP,FP,FN,b);
                            iter=iter+1;
                            display(['Iterations remaining = ', int2str(NumIter-iter), ' f1: ', num2str(f1_mat(i,j,k,l,m,n,o)), ' erode_sz: ', num2str(erode_sz(o))])

                        end
                    end
                end
            end
        end
    end
end


[~,idx] = max(f1_mat(:));
[I_max,J_max,K_max,L_max,M_max,N_max,O_max] = ind2sub(size(f1_mat), idx);

Params.p_threshold = p_threshold(I_max);
Params.p_residual = p_residual(J_max);
Params.sphere_sz = sphere_sz(K_max);
Params.dilate_sz = dilate_sz(L_max);
Params.numsamp = numsamp(M_max);
Params.numcomp = numcomp(N_max);
Params.erode_size = erode_sz(O_max);

Params.f1max = f1_mat(idx);

%[CellMapErode] = gmm(image, Params.numsamp, Params.numcomp, Params.erode_size);
%[Centroids_best,Nmap_best] = OMP_ProbMap2D(CellMapErode,Params.p_threshold,Params.p_residual,Params.sphere_sz,Params.dilate_sz,max_numcells,1);

end

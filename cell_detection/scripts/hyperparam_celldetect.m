function [Params,f1_mat] = hyperparam_celldetect(image,im_train,p_threshold,p_residual,sphere_sz,dilate_sz,max_numcells)

b=1;
CC = bwconncomp(im_train);     
s  = regionprops(CC, 'centroid');
C0 = cat(1, s.Centroid);

I = length(p_threshold);
J = length(p_residual);
K = length(sphere_sz);
L = length(dilate_sz);


NumIter = prod([I,J,K,L]);

iter=0;
f1_mat = zeros(I,J,K,L);

% x-ray data test
im_test = image;

for i=1:I
    for j = 1:J        
        for k = 1:K
            for l = 1:L
                [Centroids,~] = OMP_ProbMap2D(im_test,p_threshold(i),p_residual(j),sphere_sz(k),dilate_sz(l),max_numcells,0);
                C1 = Centroids(:, 1:2); %estimated cells
                thresh = sphere_sz(k);
                [~,TP,FP,FN,~] = centroiderror_missrates(C0',C1',thresh);
                [f1_mat(i,j,k,l), ~, ~] = f1score(TP,FP,FN,b);
                iter=iter+1;
                display(['Iterations remaining = ', int2str(NumIter-iter)])

             end
         end
     end
end


[~,idx] = max(f1_mat(:));
[I_max,J_max,K_max,L_max] = ind2sub(size(f1_mat), idx);

Params.p_threshold = p_threshold(I_max);
Params.p_residual = p_residual(J_max);
Params.sphere_sz = sphere_sz(K_max);
Params.dilate_sz = dilate_sz(L_max);

Params.f1max = f1_mat(idx);

end

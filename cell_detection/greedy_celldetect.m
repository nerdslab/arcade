function [Centroids, Nmap] = greedy_celldetect(Prob,Dict,Ddilate,kmax,Lbox,presid,dispflag)

if nargin<7
    dispflag=1;
end

Nmap = zeros(size(Prob));
newid = 1;
newtest = Prob;
Centroids = [];

% run greedy search step for at most kmax steps (# cells <= kmax)
for ktot = 1:kmax
    tic,
    val = zeros(size(Dict,2),1);
    id = zeros(size(Dict,2),1);
    
    for j = 1:size(Dict,2)
       convout = conv2(newtest,reshape(Dict(:,j),Lbox,Lbox),'same');
       [val(j),id(j)] = max(convout(:)); % positive coefficients only
    end
    
    % find position in image with max correlation
    [~,which_atom] = max(val); 
    which_loc = id(which_atom); 
  
    X2 = compute2dvec(Dict(:,which_atom),which_loc,Lbox,size(newtest));
    xid = find(X2); 

    X3 = compute2dvec(Ddilate,which_loc,Lbox,size(newtest));
    
    %newid = newid+1; % bug - increment newid twice!
    newtest = newtest.*(X3==0);
    ptest = val./sum(Dict);
    
    if ptest<presid
        return
    end
    Nmap(xid) = newid;
    newid = newid+1;

    [rr,cc,zz] = ind2sub(size(newtest),which_loc);
    newC = [cc, rr, zz];

    Centroids = [Centroids; [newC,ptest]];

    if dispflag==1
        display(['Iter remaining = ', int2str(kmax-ktot), ...
             ' Correlation = ', num2str(ptest,3)])
    end
    
end

end
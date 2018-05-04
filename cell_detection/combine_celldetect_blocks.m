function Nmap_out = combine_celldetect_blocks(Centroids,BlockPos,SZ)

Nmap0 = zeros(SZ(1),SZ(2));
numblocks = length(Centroids);

for i=1:numblocks 
    C0 = Centroids{i};
    C0(:,2) = C0(:,2) + BlockPos{i}.rowidx(1) - 1;
    C0(:,1) = C0(:,1) + BlockPos{i}.colidx(1) - 1;
    
    for j=1:size(C0,1)
        Nmap0(C0(j,2)-1:C0(j,2)+1,C0(j,1)-1:C0(j,1)+1) = Nmap0(C0(j,2)-1:C0(j,2)+1,C0(j,1)-1:C0(j,1)+1) + ones(3);
    end
end

CC = bwconncomp(Nmap0);
s  = regionprops(CC, 'centroid');

Nmap_out = zeros(SZ(1),SZ(2));
for i=1:length(s)
    Nmap_out(round(s(i).Centroid(2)),round(s(i).Centroid(1))) = 1;
end

end
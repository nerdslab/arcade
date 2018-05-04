function Centroids = find_centroids(im)

CC = bwconncomp(im~=0);
s = regionprops(CC,'centroid');
Centroids = zeros(2,length(s));
for i =1:length(s)
    Centroids(:,i) = [s(i).Centroid(1), s(i).Centroid(2)];
end

end
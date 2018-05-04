function Mask = findbrainboundary(im,thresh)
% assumes Nissl with white background

if nargin<2
    thresh=240;
elseif isempty(thresh)
    thresh = 240;
end

im2 = imfill(mean(im,3)<thresh,'holes');
out = bwconncomp(im2);

sizecc = zeros(length(out.PixelIdxList),1);
for i=1:length(out.PixelIdxList)
   sizecc(i) = length(out.PixelIdxList{i}); 
end

[~,whichcc] = max(sizecc);

maskim = zeros(size(im2));
maskim(out.PixelIdxList{whichcc})=1;
Mask = bwconvhull(maskim);

end


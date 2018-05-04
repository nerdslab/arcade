function [CellMapErode] = gmm(image, numsamp, numcomp, erode_size)
%GMM Summary of this function goes here
%   Detailed explanation goes here


%% simple - pixel gmm
%ProbMap = gmmposterior_im(IM,numcomp,numsamp,numfreq);
if size(image, 3) == 3
    IM = rgb2gray(im2double(image)); % V1 image
elseif size(image, 3) == 1
    IM = image;
else
    error('The input image test is not in the correct format');
end
whichsamp = randi(numel(IM),numsamp,1);
traind = IM(whichsamp);
gm = fitgmdist(traind,numcomp);
[~,whichCell] = min(gm.mu); 
Probx = posterior(gm,IM(:));
CellMap = reshape(Probx(:,whichCell),size(IM));
if isequal(erode_size,0) == 0
    CellMapErode = imerode(CellMap,strel('sphere',erode_size));
else
    CellMapErode = CellMap;
end
%figure, imshow(CellMapErode)

end


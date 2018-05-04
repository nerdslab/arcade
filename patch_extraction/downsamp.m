function [downsampled_mx] = downsamp(mx, n)
%DOWNSAMPLE Summary of this function goes here
%   Detailed explanation goes here


downsampled_mx = [];

s = size(mx,1);

for i = 1:n:s-n
    k = sum(mx(i,1):mx(i+n,1));
    downsampled_mx = [downsampled_mx; k];
end

end


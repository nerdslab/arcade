function [outputArray] = randIntervlasInts(varArray,lengthArray)
%RANDINTERVALS Summary of this function goes here
%   Detailed explanation goes here

intermArray = randperm(max(varArray));
k = find(intermArray>=min(varArray),lengthArray);
outputArray = intermArray(k);
outputArray = sort(outputArray);
end


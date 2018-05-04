function [outputArray] = randIntervals(varArray,lengthArray)
%RANDINTERVALS Summary of this function goes here
%   Detailed explanation goes here

outputArray = sort((max(varArray)-min(varArray)).*rand(floor(lengthArray),1) + min(varArray))';

end


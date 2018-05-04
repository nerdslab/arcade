function [array_of_length] = getIters(array_of_length,MaxIter)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

IntermIter = prod(array_of_length);
counter = 1;
while MaxIter > IntermIter
    temp = array_of_length;
    array_of_length(counter) = array_of_length(counter)+1;
    IntermIter = prod(array_of_length);
    if IntermIter > MaxIter
        array_of_length = temp;
        break
    end
    counter = counter + 1;
end
end


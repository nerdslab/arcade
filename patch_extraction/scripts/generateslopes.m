function [outline_of_brain_with_slopes] = generateslopes(p, outline_of_brain, xx)
%GENERATENORMAL Summary of this function goes here
%   Detailed explanation goes here


outline_of_brain_with_slopes = [];
for i = 1:length(xx)-1
    x0= xx(i);
    y0= polyval(p,x0);
    x1= xx(i+1);
    y1= polyval(p,x1);
    
    slope_of_tang = ((y1-y0)/(x1-x0));
    slope_of_norm = -1/slope_of_tang;
    
    a = 90 - atand(slope_of_norm);
    
    if (i == 1)
        outline_of_brain_with_slopes = ...
            [x0 y0 slope_of_tang slope_of_norm a; ...
             x1 y1 slope_of_tang slope_of_norm a];
    else
        outline_of_brain_with_slopes = ...
            [outline_of_brain_with_slopes; ...
            x1 y1 slope_of_tang slope_of_norm a];
        
    end
    
end

end


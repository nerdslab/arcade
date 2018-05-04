function [x1,y1] = generatecoordinate(x0, y0, slope_of_tang, patch_width, d)

p_2 = patch_width/2;

if strcmp(d, 'left')   
    p_2 = (-p_2);    
end

ylen  = p_2*sind(atand(slope_of_tang));
xlen  = p_2*sind(90 - atand(slope_of_tang));
y1    = ylen + y0; 
x1    = xlen + x0;
       
end
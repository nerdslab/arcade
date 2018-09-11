function [x1,y1,x2,y2] = generatecoordinate(x0, y0, slope_of_tang, hyp, dir)


x1 = 0;
y1 = 0;
x2 = 0;
y2 = 0;

p_2 = hyp/2;

switch(dir)
    case 1
        p_2;
        ylen  = p_2*sind(atand(slope_of_tang));
        xlen  = p_2*sind(90 - atand(slope_of_tang));
        y1    = ylen + y0; 
        x1    = xlen + x0;
        y2    = -ylen + y0; 
        x2    = -xlen + x0;
        
    case 2
        p_2;
        ylen  = p_2*sind(atand(slope_of_tang));
        xlen  = p_2*sind(90 - atand(slope_of_tang));
        y1    = ylen + y0; 
        x1    = xlen + x0;
        y2    = -ylen + y0; 
        x2    = -xlen + x0;
        
    case 3
        p_2 = (-p_2);
        ylen  = p_2*sind(atand(slope_of_tang));
        xlen  = p_2*sind(90 - atand(slope_of_tang));
        y1    = -ylen + y0; 
        x1    = -xlen + x0;
        y2    = ylen + y0; 
        x2    = xlen + x0;
        
        
    case 4
        p_2 = (-p_2);
        ylen  = p_2*sind(atand(slope_of_tang));
        xlen  = p_2*sind(90 - atand(slope_of_tang));
        y1    = ylen + y0; 
        x1    = xlen + x0;
        y2    = -ylen + y0; 
        x2    = -xlen + x0;        

        
    case 5
        if slope_of_tang >0
            p_2;
        else
            p_2 = (-p_2);
        end
            ylen  = p_2*sind(atand(slope_of_tang));
            xlen  = p_2*sind(90 - atand(slope_of_tang));
            y1    = ylen + y0; 
            x1    = xlen + x0;
        
        
   case 6
        if slope_of_tang <0
            p_2 = (-p_2);
        else
            p_2;
        end
        ylen  = p_2*sind(atand(slope_of_tang));
        xlen  = p_2*sind(90 - atand(slope_of_tang));
        y1    = ylen + y0; 
        x1    = xlen + x0;
        
    case 7
        if slope_of_tang <0
            p_2;
        else
            p_2 = (-p_2);
        end
            ylen  = p_2*sind(atand(slope_of_tang));
            xlen  = p_2*sind(90 - atand(slope_of_tang));
            y1    = ylen + y0; 
            x1    = xlen + x0;
        
        
  case 8
        if slope_of_tang >0
            p_2 = (-p_2);
        else
            p_2;
        end
        ylen  = p_2*sind(atand(slope_of_tang));
        xlen  = p_2*sind(90 - atand(slope_of_tang));
        y1    = ylen + y0; 
        x1    = xlen + x0;
        
    otherwise
        warning('Unexpected region, please be aware.')
         
end

       
end
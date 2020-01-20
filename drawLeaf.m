% create single leaf texture

% INPUTS:


function coords = drawLeaf(x,y)

% ----------------------------------------------------------------- %

% GET LINE CO-ORDINATES

% start co-ordinate matrix with x-values
coords = [x(1,1):x(1,3)];

% work out y-values
for side = 1:2 % top and bottom of leaf
    
    yPoints = [];
    
    for point = 2:3 % two parts of line
        
        xPlot = x(side,point-1):x(side,point);
        n = x(side,point) - x(side,point-1);
        if point == 2
            n = n+1;
        end
        
        for i = 1:n
            mew(i) = ((xPlot(i)) - x(side,point-1)) / (x(side,point) - x(side,point-1));
            mew2(i) = (1-cos(mew(i)*pi))/2;
            yPoints(i) = (y(side,point-1)*(1-mew2(i))+y(side,point)*mew2(i));
        end
        
        if point == 2
            yPlot = [yPoints];
        else
            yPlot = [yPlot,yPoints];
            coords(side+1,:) = yPlot;
        end
        
    end
    
    
    
end

coords = round(coords);

% ----------------------------------------------------------------- %

% MAKE LEAF TEXTURE OUT OF LINES



end

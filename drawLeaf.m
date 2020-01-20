% function to create single leaf texture matrix

% INPUTS:
%   lLum = luminance of leaf
%   lWidth = width of leaf
%   lHeights = 1*2 matrix with height of upper and lower parts of leaf
%   lPeaks = 1*2 matrix with location on x axis of upper and lower peaks of leaf

% OUTPUTS:
%   leafMat = luminance matrix describing single leaf

% ----------------------------------------------------------------- %

function leafMat = drawLeaf(lLum,lWidth,lHeights,lPeaks)

x = [1,lPeaks(1),lWidth;1,lPeaks(2),lWidth];
y = [1,lHeights(1),1;1,lHeights(2),1];

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

texMatUp = zeros(lHeights(1),lWidth);
texMatDown = zeros(lHeights(2),lWidth);
for i = 1:lWidth
    texMatUp(1:coords(2,i),i) = lLum;
    texMatDown(1:coords(2,i),i) = lLum;
end
texMatDown = flip(texMatDown,1);

leafMat = [texMatDown;texMatUp]; % WHY IS 0,0 NOT IN THE BOTTOM LEFT?????????? FUCKING CATHODES

end

% function to create single leaf texture matrix

% TO DO:
%   SORT ASYMMETRIC PEAKS + HEIGHTS
%   BLEND BETTER WITH NEW BACKGROUNDS

% INPUTS:
%   lType = type of leaf shape, determined by lines used to draw it
%   lLum = luminance of leaf
%   lAngle = rotation angle of leaf (degrees)
%   lWidth = width of leaf
%   lHeights = 1*2 matrix with height of upper and lower parts of leaf
%   lPeaks = 1*2 matrix with location on x axis of upper and lower peaks of leaf

% OUTPUTS:
%   leafMat = luminance matrix describing single leaf

% ----------------------------------------------------------------- %

function leafMat = drawLeaf(lType,lLum,lAngle,lWidth,lHeights,lPeaks)

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
        
        switch lType % just two different lines to shape leaves
            case 1
                for i = 1:n
                    mew(i) = ((xPlot(i)) - x(side,point-1)) / (x(side,point) - x(side,point-1));
                    if point == 2 % lolololol bodge bodge bodge
                        mew2(i) = 1 - (1 - mew(i))*(1 - mew(i));
                    elseif point == 3
                        mew2(i) = (mew(i))*(mew(i));
                    end
                    mew2(i) = min(max(mew2(i), 0), 1);
                    yPoints(i) = (y(side,point-1)*(1-mew2(i))+y(side,point)*mew2(i));
                end
            case 2
                for i = 1:n
                    mew(i) = ((xPlot(i)) - x(side,point-1)) / (x(side,point) - x(side,point-1));
                    mew2(i) = (1-cos(mew(i)*pi))/2;
                    yPoints(i) = (y(side,point-1)*(1-mew2(i))+y(side,point)*mew2(i));
                end
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

% create matrix of pixel luminances using co-ordinates
texMatUp = zeros(lHeights(1),lWidth);
texMatDown = zeros(lHeights(2),lWidth);
for i = 1:lWidth
    texMatUp(1:coords(2,i),i) = lLum;
    texMatDown(1:coords(2,i),i) = lLum;
end
texMatDown = flip(texMatDown,1);
leafMat = [texMatDown;texMatUp]; % WHY IS 0,0 NOT IN THE BOTTOM LEFT?????????? FUCKING CATHODES

% rotate leaf matrix
leafMat = imrotate(leafMat,lAngle,'bilinear');
for i = 1:numel(leafMat) % convert back to all same luminance (makes edges more jaggedy, but removes edge artifacts after pasting)
    if leafMat(i) > 0
        leafMat(i) = lLum;
    end
end

end

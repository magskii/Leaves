% create single leaf texture

function drawLeaf(x,y) = leafTex

for point = 2:3
    
    xPlot = x(point-1):x(point);
    n = x(point) - x(point-1);
    if point == 2
        n = n+1;
    end
    
    for i = 1:n
        mew(i) = ((xPlot(i)) - x(point-1)) / (x(point) - x(point-1));
        mew2(i) = (1-cos(mew(i)*pi))/2;
        yPoints(i) = (y(point-1)*(1-mew2(i))+y(point)*mew2(i));
    end
    
    if point == 2
        yPlot = [yPoints];
    else
        yPlot = [yPlot,yPoints];
    end
    
end

xPlot = [x(1):x(3)];




end

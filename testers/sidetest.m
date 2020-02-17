compSide = 1;
height = 1000;
width = 1000;
halfWidth = width/2;
halfHeight = height/2;
edgeBuffer = 10;

switch compSide
    case 1 % left
        midLine = edgeBuffer + halfWidth;
        WcompRange = [edgeBuffer, midline];
        WsimpRange = [midline, width+edgeBuffer];
        HcompRange = [edgeBuffer,height+edgeBuffer];
        HsimpRange = [edgeBuffer,height+edgeBuffer];
    case 2 % right
        midLine = edgeBuffer + halfWidth;
        WcompRange = [midline, width+edgeBuffer];
        WsimpRange = [edgeBuffer, midline];
        HcompRange = [edgeBuffer,height+edgeBuffer];
        HsimpRange = [edgeBuffer,height+edgeBuffer];
    case 3 % top
        midLine = edgeBuffer + halfHeight;
        HcompRange = [edgeBuffer, midline];
        HsimpRange = [midline, height+edgeBuffer];
        WcompRange = [edgeBuffer,width+edgeBuffer];
        WsimpRange = [edgeBuffer,width+edgeBuffer];
    case 4 % bottom
        midLine = edgeBuffer + halfHeight;
        HcompRange = [midline, height+edgeBuffer];
        HsimpRange = [edgeBuffer, midline];
        WcompRange = [edgeBuffer,width+edgeBuffer];
        WsimpRange = [edgeBuffer,width+edgeBuffer];
end

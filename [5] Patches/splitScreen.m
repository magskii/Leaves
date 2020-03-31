% function to define halves of screen, top and bottom

function [ver,hor] = splitScreen(buffer,width,height)

if ~exist('buffer','var')
    buffer = 0;
end

halfWidth = width/2;
halfHeight = height/2;
verMid = buffer + halfWidth;
horMid = buffer + halfHeight;

ver = [buffer,verMid,width+buffer;];
hor = [buffer,horMid,height+buffer];

end
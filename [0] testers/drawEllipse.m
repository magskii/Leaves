% funnction to draw an ellipse

% CURRENTLY BREAKS IF ODD NUMBERS IN HEIGHT OR WIDTH, NEED TO FIX

% INPUTS:
% height = y length of ellipse
% width = x length of ellipse
% luminance = luminance value of ellipse
% angle = angle of rotation

% OUTPUTS:
% baseLum = the background luminance of ellipseMat
% ellipseMat = pixel matrix of an ellipse
% NB: to paste in the ellipse, just specify not pasting baseLum values

function [baseLum,ellipseMat] = drawEllipse(height,width,luminance,angle)

format long g

% ----------------------------------------------------------------- %

% GET CO-ORDINATES OF ARC

coords = zeros(width+1,2);
radY = height/2;
radX = width/2;
center = 0+radX;
for i = 1:width+1
    x = center-radX-1+i;
    y = sqrt(((radY)^2)*(1-((((x-center)^2))/(radX^2))));
    coords(i,:) = [x,y];
end
coords = round(coords);

% ----------------------------------------------------------------- %

% MAKE ELLIPSE TEXTURE MATRIX

%create pixel matrix
if luminance == 0; % if ellipse luminance is 0
    baseLum = 1;
    ellipseMat = ones(radY,width+1); % set background as 1
else % otherwise set background as 0
    baseLum = 0;
    ellipseMat = zeros(radY,width+1);
end
for i = 1:width+1
    if coords(i,2) == 0;
        ellipseMat(1,i) = luminance;
    else
        ellipseMat(1:coords(i,2),i) = luminance;
    end
end
ellipseMat = [flip(ellipseMat,1);ellipseMat];

% rotate ellipse
ellipseMat = imrotate(ellipseMat,angle,'bilinear');
for i = 1:numel(ellipseMat) % convert back to all same luminance (makes edges more jaggedy, but removes edge artifacts after pasting)
    if ellipseMat(i) ~= baseLum
        ellipseMat(i) = luminance;
    end
end

end

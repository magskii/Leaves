% funnction to draw an ellipse

% INPUTS:
% heightR = y radius of ellipse
% widthR = x radius of ellipse
% lum = luminance value

% OUTPUTS:
% ellipseMat = pixel matrix of an ellipse
% 1s indicate you should draw, 0s leave blank

function [baseLum,ellipseMat] = drawEllipse(radY,radX,luminance,angle)

format long g

% ----------------------------------------------------------------- %

% GET CO-ORDINATES OF ARC
radX = round(radX);
radY = round(radY);
widthR = (radX*2)+1; % +1 for centre
heightR = (radY*2)+1; % +1 for centre
coords = zeros(widthR,2);
center = radX+1; % +1 for centre
for i = 1:widthR
    x = center-radX-1+i;
    y = sqrt(((radY)^2)*(1-((((x-center)^2))/(radX^2))));
    coords(i,:) = [x,y];
end
coords = round(coords);

% ----------------------------------------------------------------- %

% MAKE ELLIPSE TEXTURE MATRIX

%create pixel matrix
if luminance == 0 % if ellipse luminance is 0
    baseLum = 1;
    ellipseMat = ones(radY,widthR); % set background as 1
else % otherwise set background as 0
    baseLum = 0;
    ellipseMat = zeros(radY,widthR);
end
for i = 1:widthR
    if coords(i,2) == 0
        ellipseMat(1,i) = luminance;
    else
        ellipseMat(1:coords(i,2),i) = luminance;
    end
end
ellipseMatPlus = [zeros(1,size(ellipseMat,2))+luminance;ellipseMat];
ellipseMat = [flip(ellipseMat,1);ellipseMatPlus];

% rotate ellipse
ellipseMat = imrotate(ellipseMat,angle,'bilinear');
% for i = 1:numel(ellipseMat) % remove edge artifacts
%     if ellipseMat(i) ~= baseLum
%         ellipseMat(i) = luminance;
%     end
% end

end

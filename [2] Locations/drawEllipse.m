% funnction to draw an ellipse

% INPUTS:
% height = y length of ellipse
% width = x length of ellipse
% lum = luminance value

% OUTPUTS:
% ellipseMat = pixel matrix of an ellipse
% 1s indicate you should draw, 0s leave blank

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
% for i = 1:numel(ellipseMat) % remove edge artifacts
%     if ellipseMat(i) ~= baseLum
%         ellipseMat(i) = luminance;
%     end
% end

end

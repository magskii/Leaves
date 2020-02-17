% funnction to draw an ellipse

% INPUTS:

center = [1000,2000];
height = 100;
width = 300;
angle = 45;

% OUTPUTS:


% NB: all co-ordinates must be positive, as designed to draw in pixels

format long g

% ----------------------------------------------------------------- %

% GET CO-ORDINATES OF ARC

coords = zeros(width+1,2);

radY = height/2;
radX = width/2;

for i = 1:width+1
    
    x = center(1)-radX-1+i;
    y = sqrt(((radY-center(2))^2)*(1-((((x-center(1))^2))/(radX^2))));
    
    coords(i,:) = [x,y];
    
end

coords = round(coords)
plot(coords);
% ----------------------------------------------------------------- %

% MAKE ELLIPSE MATRIX AND ROTATE

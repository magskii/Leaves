% funnction to draw an ellipse

% INPUTS:
% height = y length of ellipse
% width = x length of ellipse
% lum = luminance value

% OUTPUTS:
% ellipseMat = pixel matrix of an ellipse
% 1s indicate you should draw, 0s leave blank

%function ellipseMat = drawEllipse(height,width,luminance,angle)

height = 400;
width = 300;
luminance = 128;
angle = 45;

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
ellipseMat = zeros(radY,width+1); % not a possible specified luminance
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
%     if ellipseMat(i) ~= 666
%         ellipseMat(i) = lum;
%     end
% end

%end





backLum = 0;
Screen('Preference', 'SkipSyncTests', 1); % don't care about timing, so skipping sync tests is fine for now
screenMax = max(Screen('Screens')); % set screen to be external display if applicable
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible'); % can't remember what this does...
PsychImaging('AddTask', 'General', 'UseRetinaResolution'); % use entire display pixel capactiy
[w,rect] = PsychImaging('OpenWindow', screenMax,backLum);
[xCenter,yCenter]=RectCenter(rect); % screen center co-ordinates
[width, height] = RectSize(rect); % window size for easy referral


targetTexture = Screen('MakeTexture',w,ellipseMat);
Screen('DrawTexture',w,targetTexture);



Screen('Flip',w,[],1);

KbWait;
Priority(0);
sca;
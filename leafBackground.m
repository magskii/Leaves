% draw backgrounds containing multiple leaves


clear all;

% ----------------------------------------------------------------- %

nLeaves = 1;
lumMin = 55;
lumMax = 200;
minSize = 100;
maxSize = 300;

% ----------------------------------------------------------------- %

% screen set-up
Screen('Preference', 'SkipSyncTests', 1); % don't care about timing, so skipping sync tests is fine for now
screenMax = max(Screen('Screens')); % set screen to be external display if applicable
% set up for alpha blending - allows overlapping gabors and removes square edges
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible');
PsychImaging('AddTask', 'General', 'UseRetinaResolution'); % also use entire display pixel capactiy
% more screen set-up
[w,rect] = PsychImaging('OpenWindow', screenMax, 128);
[xCenter,yCenter]=RectCenter(rect); % screen center co-ordinates
[width, height] = RectSize(rect); % window size for easy referral

% ----------------------------------------------------------------- %

try
    
    lum = 128;
    width = 300;
    apex = 140;
    height = 150;
    
    x = [1,apex,width;1,apex,width];
    y = [1,height,1;1,-height,1];
    
    coords = drawLeaf(x,y);
    
    texMatTop = zeros(height,width);
    texMatBottom = zeros(height,width);
    
    for i = 1:width
        
        texMatTop(coords(2,i):size(texMatTop,1),i) = lum;
        
    end
    
    leafTop = Screen('MakeTexture',w,texMatTop);
    Screen('DrawTexture',w,leafTop);
    
    Screen('Flip',w,[],1);
    
    KbWait;
    % close psychtoolbox
    Priority(0);
    sca;
    
catch e
    
    fprintf(1,'There was an error! The message was:\n%s',e.message);
    
    % close psychtoolbox
    Priority(0);
    sca;
    
end


% ----------------------------------------------------------------- %


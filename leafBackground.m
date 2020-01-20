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
[w,rect] = PsychImaging('OpenWindow', screenMax, 0);
[xCenter,yCenter]=RectCenter(rect); % screen center co-ordinates
[lWidth, height] = RectSize(rect); % window size for easy referral

% ----------------------------------------------------------------- %

try
    
    % define random leaf paramaters within ranges
    lLum = 128;
    lWidth = 250;
    lHeights = [75,75];
    lPeaks = [100,100];

    
    coords = drawLeaf(lLum,lWidth,lHeights,lPeaks);
    
    texMatUp = zeros(lHeights(1),lWidth);
    texMatDown = zeros(lHeights(2),lWidth);
    
    for i = 1:lWidth
        
        texMatUp(1:coords(2,i),i) = lLum;
        texMatDown(1:coords(2,i),i) = lLum;
        
    end
    
    texMatDown = flip(texMatDown,1);
    texMat = [texMatDown;texMatUp]; % WHY IS 0,0 NOT IN THE BOTTOM LEFT?????????? FUCKING CATHODES
    
    leafTexture = Screen('MakeTexture',w,texMat);
    Screen('DrawTexture',w,leafTexture,[],[],45);
    
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


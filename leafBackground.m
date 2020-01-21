% draw backgrounds containing multiple leaves


clear all;

% ----------------------------------------------------------------- %

nLeaves = 1;
lumMin = 55;
lumMax = 200;
minWidth = 100;
maxWidth = 300;

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
    % NEED TO RANDOMISE!!
    % define random leaf paramaters within ranges
    lLum = 128;
    lWidth = 250;
    lHeights = [75,75];
    lPeaks = [100,100];

    leafMat = drawLeaf(lLum,lWidth,lHeights,lPeaks);
    
    % NEED TO PICK OUT LEAF LUM AND DRAW ON BACKGROUND
    % RANDOMISE LOCATION AND ROTATION - make texture then pull texture?
    
    leafTexture = Screen('MakeTexture',w,leafMat);
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


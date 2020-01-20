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
    
    for i = 1:nLeaves
        
        % new leaf parameter
        lLum = randi([lumMin,lumMax],1);
        lWidth = randi([minSize,maxSize],1);
        lHeight = randi([minSize,maxSize],1);
        lLoc = [randi([0-maxSize,width],1),randi([0-maxSize,height],1)];
        lRect = [lLoc(1),lLoc(2),lLoc(1)+lWidth,lLoc(2)+lHeight];
        
        Screen('FillOval',w,lLum,lRect);
        
    end
    
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


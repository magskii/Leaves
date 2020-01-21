% draw backgrounds containing multiple leaves

clear all;

% ----------------------------------------------------------------- %

backLum = 128;


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
[w,rect] = PsychImaging('OpenWindow', screenMax,backLum);
[xCenter,yCenter]=RectCenter(rect); % screen center co-ordinates
[width, height] = RectSize(rect); % window size for easy referral

% ----------------------------------------------------------------- %

try
    
    % create blank mean-luminance display matrix
    display = zeros(height,width) + backLum;
    
    for i = 1:nLeaves
        
        % NEED TO RANDOMISE!!
        % define random leaf paramaters within ranges
        lLum = 255;
        lAngle = 45;
        lWidth = 250;
        lHeights = [75,75];
        lPeaks = [100,100];
        
        % draw leaf based on parameters
        leafMat = drawLeaf(lLum,lAngle,lWidth,lHeights,lPeaks);
        
        % paste leaf onto display
        for pixCol = 1:size(leafMat,1)
            for pixRow = 1:size(leafMat,2)
                if leafMat(pixCol,pixRow) > 0
                    display(pixCol,pixRow) = leafMat(pixCol,pixRow);
                end
            end
        end
        
    end
    
    % throw image onto screen
    dispTexture = Screen('MakeTexture',w,display);
    Screen('DrawTexture',w,dispTexture);
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

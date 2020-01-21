
% draw backgrounds containing multiple leaves

% SORT ASYMMETRIC PEAKS + HEIGHTS

clear all;

% ----------------------------------------------------------------- %

% screen set-up
backLum = 128;
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

nLeaves = 1;
lumRange = [55,200];
angleRange = [1,360];
widthRange = [100,300];
heightRange = [20,150];

try
    
    % create blank mean-luminance display matrix
    display = zeros(height,width) + backLum;
    
    for i = 1:nLeaves
        
        % define random leaf paramaters within ranges
        lLum = randi([lumRange(1),lumRange(2)],1);
        lAngle = randi([angleRange(1),angleRange(2)],1);
        lWidth = randi([widthRange(1),widthRange(2)],1);
        peakMax = round(lWidth/2)-10;
        lPeaks = randi([10,peakMax],[1,2]);
        lHeights = randi([heightRange(1),heightRange(2)],[1,2]);
        
        % draw leaf based on parameters
        leafMat = drawLeaf(lLum,lAngle,lWidth,lHeights,lPeaks);
        
        % choose random location to paste
        % randloc = 
        
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
    Priority(0);
    sca;
    
catch e
    
    fprintf(1,'There was an error! The message was:\n%s',e.message);
    
    % close psychtoolbox
    Priority(0);
    sca;
    
end


% draw backgrounds containing multiple leaves

% SORT ASYMMETRIC PEAKS + HEIGHTS

clear all;

% ----------------------------------------------------------------- %

% screen set-up
backLum = 0;
Screen('Preference', 'SkipSyncTests', 1); % don't care about timing, so skipping sync tests is fine for now
screenMax = max(Screen('Screens')); % set screen to be external display if applicable
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible'); % can't remember what this does...
PsychImaging('AddTask', 'General', 'UseRetinaResolution'); % use entire display pixel capactiy
[w,rect] = PsychImaging('OpenWindow', screenMax,backLum);
[xCenter,yCenter]=RectCenter(rect); % screen center co-ordinates
[width, height] = RectSize(rect); % window size for easy referral

% ----------------------------------------------------------------- %

% TARGET SPECS

targLum = 128; %round(lumRange(1)+((lumRange(2)-lumRange(1))/2)); % mid-leaf luminance
targAngle = 45; %randi([1,360],1);
targWidth = 250; %round(widthRange(1)+((widthRange(2)-widthRange(1))/2)); % mid-leaf width
targHeight = 180; %round(heightRange(1)+((heightRange(2)-heightRange(1))/2)); % mid-leaf height

% ----------------------------------------------------------------- %

% LEAF COMPLEXITY SPECS

% general
compType = 3; % type        1 = luminance, 2 = size, 3 = size, etc.
compLevel = 1; % level      1 = low, 2 = med, 3 = high;

% define low level for each complexity factor:
% 1 = luminance
lumDiff = 30; % max luminance deviation from mean (target) lum
lumRange = [targLum-lumDiff,targLum+lumDiff];
% 2 = size (defined by width)
sizeDiff = 50; % max width deviation (pixels) from mean (target) width
widthRange = [targWidth-sizeDiff,targWidth+sizeDiff];
% 3 = angle
angleDiff = 20; % max angle deviation (degs) from target angle
angleRange = [targAngle-angleDiff,targAngle+angleDiff];
% 4 = number
nLeaves = 1000;
% 5 = shape
shapeDiff = 0;


% NEEDS MOVING?
peakDistance = 0.25;
HCD = gcd(targWidth,targHeight); % for leaf ratios
leafShapeRatio = [round(targWidth/HCD),round(targHeight/HCD)]; %fixed width and height



% switch out factor which is varied for this trial, unless it's a control
if compLevel ~=1
    switch compType
        case 1 % luminance
            switch compLevel
                case 2
                    lumDiff = 60;
                    lumRange = [targLum-lumDiff,targLum+lumDiff];
                case 3
                    lumDiff = 90;
                    lumRange = [targLum-lumDiff,targLum+lumDiff];
            end
        case 2 % size
            switch compLevel
                case 2
                    sizeDiff = 100;
                    widthRange = [targWidth-sizeDiff,targWidth+sizeDiff];
                case 3
                    sizeDiff = 150;
                    widthRange = [targWidth-sizeDiff,targWidth+sizeDiff];
            end
        case 3 % angle
            switch compLevel
                case 2
                    angleDiff = 120;
                    angleRange = [targAngle-angleDiff,targAngle+angleDiff];
                case 3
                    angleDiff = 180;
                    angleRange = [targAngle-angleDiff,targAngle+angleDiff];
            end
        case 4 % number
            switch compLevel
                case 2
                    nLeaves = 2000;
                case 3
                    nLeaves = 3000;
            end
        case 5
            switch compLevel
                case 2
                case 3
            end
    end
end

% bodge to fix drawEllipse odd number problem, can remove when fixed
if mod(targHeight,2)
    targHeight = targHeight+1;
end
if mod(targWidth,2)
    targWidth = targWidth+2;
end

% ----------------------------------------------------------------- %

% COMPLEXITY LOCATION SPECS:

SOP = 0; % location, i.e. 'side or patch'      0 = whole screen, 1 = sides, 2 = patches
switch SOP
    case 0
        % may or may not need this...
    case 1 % define side perameters
        compSide = 1; % which side is complex       1 = left, 2 = right, 3 = top, 4 = bottom
        targSide = 0; % which side does the target appear on       0 = simple side, 1 = complex side
        switch compType
            case 1
                numDiff = 0.8; % percentage of leaves displayed on complex side (to nearest leaf...)
            case 2
                % luminance ranges (high and low)
            case 3
                % size ranges (high and low)
        end
    case 2 % define patch parameters
        nPatch = 2; % number of patches
        sPatch = 500; % patch circumference (pix)
        % add distribution
end

% ----------------------------------------------------------------- %

% DERIVED VARIABLES - boring, make into separate function for clarity?

% define size of buffer so leaves can go a bit over edge of screen
edgeBuffer = widthRange(2);

% go through specs and define properly - could be done above, but manipulation would become confusing
switch SOP
    case 0 % whole screen
        
        % define width and height ranges for target location generation
        locWidthR = [edgeBuffer,width+edgeBuffer];
        locHeightR = [edgeBuffer,height+edgeBuffer];
        
        % generate target location
        targHeightRange = [locHeightR(1)+round((targHeight/2)),locHeightR(2)-round((targHeight/2))];
        targWidthRange = [locWidthR(1)+round((targWidth/2)),locWidthR(2)-round((targWidth/2))];
        targLoc = [randi([targHeightRange],1),randi([targWidthRange],1)];
        targRect = [0,0,targWidth,targHeight];
        targRect = CenterRectOnPoint(targRect,targLoc(1),targLoc(2));
        
    case 1 % need to define according to section of screen
        
        % start by defining left/right/up/down
        halfWidth = width/2;
        halfHeight = height/2;
        switch compSide
            case 1 % left
                midline = edgeBuffer + halfWidth;
                wCompRange = [edgeBuffer, midline];
                wSimpRange = [midline, width+edgeBuffer];
                hCompRange = [edgeBuffer,height+edgeBuffer];
                hSimpRange = [edgeBuffer,height+edgeBuffer];
            case 2 % right
                midline = edgeBuffer + halfWidth;
                wCompRange = [midline, width+edgeBuffer];
                wSimpRange = [edgeBuffer, midline];
                hCompRange = [edgeBuffer,height+edgeBuffer];
                hSimpRange = [edgeBuffer,height+edgeBuffer];
            case 3 % top
                midline = edgeBuffer + halfHeight;
                hCompRange = [edgeBuffer, midline];
                hSimpRange = [midline, height+edgeBuffer];
                wCompRange = [edgeBuffer,width+edgeBuffer];
                wSimpRange = [edgeBuffer,width+edgeBuffer];
            case 4 % bottom
                midline = edgeBuffer + halfHeight;
                hCompRange = [midline, height+edgeBuffer];
                hSimpRange = [edgeBuffer, midline];
                wCompRange = [edgeBuffer,width+edgeBuffer];
                wSimpRange = [edgeBuffer,width+edgeBuffer];
        end
        
        % then sort target location
        switch targSide
            case 0 % simple side
                targHeightRange = [hSimpRange(1)+round((targHeight/2)),hSimpRange(2)-round((targHeight/2))];
                targWidthRange = [wSimpRange(1)+round((targWidth/2)),wSimpRange(2)-round((targWidth/2))];
            case 1 % complex side
                targHeightRange = [hCompRange(1)+round((targHeight/2)),hCompRange(2)-round((targHeight/2))];
                targWidthRange = [wCompRange(1)+round((targWidth/2)),wCompRange(2)-round((targWidth/2))];
        end
        targLoc = [randi([targHeightRange],1),randi([targWidthRange],1)];
        targRect = [0,0,targWidth,targHeight];
        targRect = CenterRectOnPoint(targRect,targLoc(1),targLoc(2));
        
        % then sort complexity things
        switch compType
            case 1 % number
                compNum = round(nLeaves*numDiff);
                simpNum = nLeaves-compNum;
                drawingSide = Shuffle([zeros(1,simpNum),ones(1,compNum)]); % zeros are simple, ones are complex
            case 2
                
            case 3
                
        end
    case 2 % define according to patches of screen
        
end


% ----------------------------------------------------------------- %

% DRAW LEAVES AND TARGET

try
    
    % create blank mean-luminance display matrix (plus a bit off edge of screen)
    display = zeros(height+(edgeBuffer*2),width+(edgeBuffer*2)) + backLum;
    
    for i = 1:nLeaves
        
        % define random leaf paramaters within ranges
        lLum = randi([lumRange(1),lumRange(2)],1);
        lAngle = randi([angleRange(1),angleRange(2)],1);
        lWidth = randi([widthRange(1),widthRange(2)],1);
        % fix height and peak to maintain shape ratio
        lHeight = round((lWidth/leafShapeRatio(1))*leafShapeRatio(2));
        lHeights = [round(lHeight/2),round(lHeight/2)];
        lPeak = round(lWidth*peakDistance);
        lPeaks = [lPeak,lPeak];
        
        % draw leaf based on parameters
        leafMat = drawLeaf(lLum,lAngle,lWidth,lHeights,lPeaks);
        
        % choose random leaf location within pre-defined area (e.g. specific side)
        switch SOP
            case 0
                leafLoc = [randi([locHeightR],1),randi([locWidthR],1)];
            case 1
                switch drawingSide(i)
                    case 0 % draw on simple side
                        leafLoc = [randi([hSimpRange],1),randi([wSimpRange],1)];
                    case 1 % complex
                        leafLoc = [randi([hCompRange],1),randi([wCompRange],1)];
                end
            case 2
                
        end
        leafRect = [0,0,size(leafMat)];
        leafRect = CenterRectOnPoint(leafRect,leafLoc(1),leafLoc(2));
        
        % paste leaf onto display
        for pixCol = 1:size(leafMat,1)
            for pixRow = 1:size(leafMat,2)
                if leafMat(pixCol,pixRow) > 0
                    display(pixCol+leafRect(1),pixRow+leafRect(2)) = leafMat(pixCol,pixRow);
                end
            end
        end
        
    end
    
    %FOR TESTING ONLY!!
    %targLum = 1;
    
    % draw and paste in target
    [baseLum,targMat] = drawEllipse(targHeight,targWidth,targLum,targAngle);
    for pixCol = 1:size(targMat,1)
        for pixRow = 1:size(targMat,2)
            if targMat(pixCol,pixRow) == targLum
                display(pixCol+targRect(1),pixRow+targRect(2)) = targMat(pixCol,pixRow);
            end
        end
    end
    
    % throw all onto screen
    dispTexture = Screen('MakeTexture',w,display);
    Screen('DrawTexture',w,dispTexture);
    Screen('Flip',w);
    
    KbWait;
    Priority(0);
    sca;
    
catch e
    
    fprintf(1,'There was an error! The message was:\n%s',e.message);
    
    % close psychtoolbox
    Priority(0);
    sca;
    
end

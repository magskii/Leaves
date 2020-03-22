
% draw backgrounds containing multiple leaves

% SORT ASYMMETRIC PEAKS + HEIGHTS

clear all;

% ----------------------------------------------------------------- %

%GENERAL SET UP

% screen and psychtoolbox
backLum = 0;
Screen('Preference', 'SkipSyncTests', 1); % don't care about timing, so skipping sync tests is fine for now
screenMax = max(Screen('Screens')); % set screen to be external display if applicable
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible'); % can't remember what this does...
PsychImaging('AddTask', 'General', 'UseRetinaResolution'); % use entire display pixel capactiy
[w,rect] = PsychImaging('OpenWindow', screenMax,backLum);
[xCenter,yCenter]=RectCenter(rect); % screen center co-ordinates
[width, height] = RectSize(rect); % window size for easy referral

% load stuff
load indexes

% ----------------------------------------------------------------- %

% EXPERIMENT TYPE
% set complexity factor levels:
compMat = [low,low,low,low]; % [lum,size,angle,num]
% complexity location:      
SOP = 0; % 0 = whole screen, 1 = sides, 2 = patches
if SOP ~= 0 % define general side/patch things
    switch SOP
        case 1 % define screen sides
            compSide = left; % which side is complex       1 = left, 2 = right, 3 = top, 4 = bottom
            targSide = simple; % which side does the target appear on       0 = simple side, 1 = complex side
        case 2 % define patch perameters
            nPats = 1; % number of patches
            sPats = 100; % radius of patches
            targOnPat = 0; % whether target is on a complex patch, logical
    end
end

% ----------------------------------------------------------------- %

% TARGET AND LEAF SPECS

% target
targLum = 128; %round(lumRange(1)+((lumRange(2)-lumRange(1))/2)); % mid-leaf luminance
targAngle = 45; %randi([1,360],1);
targWidth = 80; %round(widthRange(1)+((widthRange(2)-widthRange(1))/2)); % mid-leaf width
targHeight = 60; %round(heightRange(1)+((heightRange(2)-heightRange(1))/2)); % mid-leaf height

% leaf shape
lType = 1;
peakDistance = 0.25;

% leaf complexity
lum = [30,60,90]; % max luminance deviation from mean (target) lum
siz = [50,100,150]; % max width deviation (pixels) from mean (target) width
ang = [20,120,180]; % max angle deviation (degs) from target angle
num = [10,20,30]; % total number of leaves on screen

% ----------------------------------------------------------------- %

% DERIVED SPECS

% leaf:
HCD = gcd(targWidth,targHeight); % for leaf ratios
leafShapeRatio = [round(targWidth/HCD),round(targHeight/HCD)]; %fixed width and height

% target:
% bodge to fix drawEllipse odd number problem, can remove when fixed
if mod(targHeight,2)
    targHeight = targHeight+1;
end
if mod(targWidth,2)
    targWidth = targWidth+2;
end



for trial = 1:(size(compMat,1))
    
    % current trial specs
    trialSpecs = [lum(compMat(trial,lInd)),siz(compMat(trial,sInd)),ang(compMat(trial,aInd)),num(compMat(trial,nInd))];
    
    % leaf specs for this trial
    lRange = [targLum-trialSpecs(lInd),targLum+trialSpecs(lInd)];
    sRange = [targWidth-trialSpecs(sInd),targWidth+trialSpecs(sInd)];
    aRange = [targAngle-trialSpecs(aInd),targAngle+trialSpecs(aInd)];
    nRange = trialSpecs(nInd);
    if SOP ~= 0 % set simple leaf specs
        SlumRange = [targLum-lum(low),targLum+lum(low)];
        SwidthRange = [targWidth-siz(low),targWidth+siz(low)];
        SangleRange = [targAngle-ang(low),targAngle+ang(low)];
        SnLeaves = num(low);
    end
    
    % location stuff
    % define size of buffer so leaves can go a bit over edge of screen:
    edgeBuffer = sRange(2);
    % define location properly:
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
            case left
                midline = edgeBuffer + halfWidth;
                wCompRange = [edgeBuffer, midline];
                wSimpRange = [midline, width+edgeBuffer];
                hCompRange = [edgeBuffer,height+edgeBuffer];
                hSimpRange = [edgeBuffer,height+edgeBuffer];
            case right
                midline = edgeBuffer + halfWidth;
                wCompRange = [midline, width+edgeBuffer];
                wSimpRange = [edgeBuffer, midline];
                hCompRange = [edgeBuffer,height+edgeBuffer];
                hSimpRange = [edgeBuffer,height+edgeBuffer];
            case top
                midline = edgeBuffer + halfHeight;
                hCompRange = [edgeBuffer, midline];
                hSimpRange = [midline, height+edgeBuffer];
                wCompRange = [edgeBuffer,width+edgeBuffer];
                wSimpRange = [edgeBuffer,width+edgeBuffer];
            case bottom
                midline = edgeBuffer + halfHeight;
                hCompRange = [midline, height+edgeBuffer];
                hSimpRange = [edgeBuffer, midline];
                wCompRange = [edgeBuffer,width+edgeBuffer];
                wSimpRange = [edgeBuffer,width+edgeBuffer];
        end
        
        % then sort target location
        switch targSide
            case simple
                targHeightRange = [hSimpRange(1)+round((targHeight/2)),hSimpRange(2)-round((targHeight/2))];
                targWidthRange = [wSimpRange(1)+round((targWidth/2)),wSimpRange(2)-round((targWidth/2))];
            case complex
                targHeightRange = [hCompRange(1)+round((targHeight/2)),hCompRange(2)-round((targHeight/2))];
                targWidthRange = [wCompRange(1)+round((targWidth/2)),wCompRange(2)-round((targWidth/2))];
        end
        targLoc = [randi([targHeightRange],1),randi([targWidthRange],1)];
        targRect = [0,0,targWidth,targHeight];
        targRect = CenterRectOnPoint(targRect,targLoc(1),targLoc(2));
        
        
        
        
        % WTF IS THIS NEXT STUFF?
        
        % then sort complexity things
        switch compType
            case 1 % number
                compNum = round(nRange*numDiff);
                simpNum = nRange-compNum;
                drawingSide = Shuffle([zeros(1,simpNum),ones(1,compNum)]); % zeros are simple, ones are complex
            case 2
                
            case 3
                
        end
    case 2 % define according to patches of screen
        
end
     
    switch SOP
        case 0 % define whole screen parameters
            
        case 1 % define side parameters
            % complex side
            
            % simple side
            
            
            
            switch compType
                case 1
                    numDiff = 0.8; % percentage of leaves displayed on complex side (to nearest leaf...)
                case 2
                    % luminance ranges (high and low)
                case 3
                    % size ranges (high and low)
            end
        case 2
    end
    

    
    
    
    
    
    % ----------------------------------------------------------------- %
    
    % DRAW LEAVES AND TARGET
    
    try
        
        % create blank mean-luminance display matrix (plus a bit off edge of screen)
        display = zeros(height+(edgeBuffer*2),width+(edgeBuffer*2)) + backLum;
        
        for i = 1:nRange
            
            % define random leaf paramaters within ranges
            lLum = randi([lRange(1),lRange(2)],1);
            lAngle = randi([aRange(1),aRange(2)],1);
            lWidth = randi([sRange(1),sRange(2)],1);
            % fix height and peak to maintain shape ratio
            lHeight = round((lWidth/leafShapeRatio(1))*leafShapeRatio(2));
            lHeights = [round(lHeight/2),round(lHeight/2)];
            lPeak = round(lWidth*peakDistance);
            lPeaks = [lPeak,lPeak];
            
            % draw leaf based on parameters
            leafMat = drawLeaf(lType,lLum,lAngle,lWidth,lHeights,lPeaks);
            
            % choose random leaf location within pre-defined area (e.g. specific side)
            switch SOP
                case 0
                    leafLoc = [randi([locHeightR],1),randi([locWidthR],1)];
                case 1
                    switch drawingSide(i)
                        case simple % draw on simple side
                            leafLoc = [randi([hSimpRange],1),randi([wSimpRange],1)];
                        case complex % complex
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
        
        imwrite(display,'lineTest.jpg');
        
        % throw all onto screen
        dispTexture = Screen('MakeTexture',w,display);
        Screen('DrawTexture',w,dispTexture);
        Screen('Flip',w);
        
        KbWait;
        
    catch e
        
        fprintf(1,'There was an error! The message was:\n%s',e.message);
        
        % close psychtoolbox
        Priority(0);
        sca;
        
    end
    
end

Priority(0);
sca;
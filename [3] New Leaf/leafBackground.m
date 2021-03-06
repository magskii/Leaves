% draws backgrounds containing multiple leaves
% ellipse-shaped target on top

clear all;

% ----------------------------------------------------------------- %

%GENERAL SET UP

% screen and psychtoolbox
backLum = 110;
Screen('Preference', 'SkipSyncTests', 1); % don't care about timing, so skipping sync tests is fine for now
screenMax = max(Screen('Screens')); % set screen to be external display if applicable
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible'); % can't remember what this does...
PsychImaging('AddTask', 'General', 'UseRetinaResolution'); % use entire display pixel capactiy
[w,rect] = PsychImaging('OpenWindow', screenMax,backLum);
[xCenter,yCenter]=RectCenter(rect); % screen center co-ordinates
[width, height] = RectSize(rect); % window size for easy referral

% load stuff
load indices

% ----------------------------------------------------------------- %

% EXPERIMENT TYPE
% matrices for complexity and location:
compMat = [low,low,high,low]; % [lum,size,angle,num]
locMat = [side,right,simple,0];

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
HCD = gcd(targWidth,targHeight); % for leaf ratios
leafShapeRatio = [round(targWidth/HCD),round(targHeight/HCD)]; %fixed width and height

% leaf complexity values
lum = [30,60,90]; % max luminance deviation from mean (target) lum
siz = [10,20,30]; % max width deviation (pixels) from mean (target) width
ang = [20,100,180]; % max angle deviation (degs) from target angle
num = 500; % low complexity number of leaves
num = [num,num*2,num*3]; % number range for complex side

% ----------------------------------------------------------------- %

% bodge to fix drawEllipse odd number problem, can remove when fixed
if mod(targHeight,2)
    targHeight = targHeight+1;
end
if mod(targWidth,2)
    targWidth = targWidth+2;
end

% ----------------------------------------------------------------- %

% START IMAGE GENERATION

for trial = 1:(size(compMat,1))
    
    % current trial complexity specs
    trialLum = lum(compMat(trial,lInd));
    trialSiz = siz(compMat(trial,sInd));
    trialAng = ang(compMat(trial,aInd));
    trialNum = num(compMat(trial,nInd));
    SOP = locMat(trial,1);
    % experimental leaf specs for this trial
    lRange = [targLum-trialLum,targLum+trialLum];
    sRange = [targWidth-trialSiz,targWidth+trialSiz];
    aRange = [targAngle-trialAng,targAngle+trialAng];
    totLeaves = trialNum;
    if SOP ~= 0 % define general side/patch things if necessary
        % low complexity specs
        SlRange = [targLum-lum(low),targLum+lum(low)];
        SsRange = [targWidth-siz(low),targWidth+siz(low)];
        SaRange = [targAngle-ang(low),targAngle+ang(low)];
        SnLeaves = num(low);
        switch SOP
            case 1
                compSide = locMat(trial,2); % which side is complex       1 = left, 2 = right, 3 = top, 4 = bottom
                targSide = locMat(trial,3); % which side does the target appear on       0 = simple side, 1 = complex side
            case 2
                nPats = locMat(trial,2); % number of patches
                sPats = locMat(trial,3); % radius of patches
                targOnPat = locMat(trial,4); % whether target is on a complex patch, logical
        end
    end
    
    % location stuff
    % define size of buffer so leaves can go a bit over edge of screen:
    edgeBuffer = sRange(2);
    % define target location properly:
    [splitWidth,splitHeight] = splitScreen(edgeBuffer,width,height);
    switch SOP
        case 0 % anywhere on screen
            % define width and height ranges for target location generation
            locWidthR = [splitWidth(1),splitWidth(3)];
            locHeightR = [splitHeight(1),splitHeight(3)];
            % generate target location
            targHeightRange = [locHeightR(1)+round((targHeight/2)),locHeightR(2)-round((targHeight/2))];
            targWidthRange = [locWidthR(1)+round((targWidth/2)),locWidthR(2)-round((targWidth/2))];
            targLoc = [randi(targHeightRange,1),randi(targWidthRange,1)];
            targRect = [0,0,targWidth,targHeight];
            targRect = CenterRectOnPoint(targRect,targLoc(1),targLoc(2));
        case 1 % on certain half of screen
            switch compSide % which side has complex leaf litter
                case left
                    wCompRange = splitWidth(1:2);
                    wSimpRange = splitWidth(2:3);
                    hCompRange = [splitHeight(1),splitHeight(3)];
                    hSimpRange = [splitHeight(1),splitHeight(3)];
                case right
                    wCompRange = splitWidth(2:3);
                    wSimpRange = splitWidth(1:2);
                    hCompRange = [splitHeight(1),splitHeight(3)];
                    hSimpRange = [splitHeight(1),splitHeight(3)];
                case top
                    hCompRange = splitHeight(1:2);
                    hSimpRange = splitHeight(2:3);
                    wCompRange = [splitWidth(1),splitWidth(3)];
                    wSimpRange = [splitWidth(1),splitWidth(3)];
                case bottom
                    hCompRange = splitHeight(2:3);
                    hSimpRange = splitHeight(1:2);
                    wCompRange = [splitWidth(1),splitWidth(3)];
                    wSimpRange = [splitWidth(1),splitWidth(3)];
            end
            % then choose which side target is located on
            switch targSide
                case simple
                    targHeightRange = [hSimpRange(1)+round((targHeight/2)),hSimpRange(2)-round((targHeight/2))];
                    targWidthRange = [wSimpRange(1)+round((targWidth/2)),wSimpRange(2)-round((targWidth/2))];
                case complex
                    targHeightRange = [hCompRange(1)+round((targHeight/2)),hCompRange(2)-round((targHeight/2))];
                    targWidthRange = [wCompRange(1)+round((targWidth/2)),wCompRange(2)-round((targWidth/2))];
            end
            targLoc = [randi(targHeightRange,1),randi(targWidthRange,1)];
            targRect = [0,0,targWidth,targHeight];
            targRect = CenterRectOnPoint(targRect,targLoc(1),targLoc(2));
            % define drawing side for leaves
                drawingSide = Shuffle([zeros(1,SnLeaves),ones(1,totLeaves)]);
                totLeaves = totLeaves + SnLeaves;
        case 2 % define according to patches of screen
            
    end
    
    % ----------------------------------------------------------------- %
    
    % DRAW LEAVES AND TARGET
    
    try
        % create blank mean-luminance display matrix (plus a bit off edge of screen)
        display = zeros(height+(edgeBuffer*2),width+(edgeBuffer*2)) + backLum;
        for i = 1:totLeaves
            % define leaf location and specs
            switch SOP
                case 0
                    %location
                    leafLoc = [randi(locHeightR,1),randi(locWidthR,1)];
                    % define leaf paramaters within ranges
                    lLum = randi([lRange(1),lRange(2)],1);
                    lAngle = randi([aRange(1),aRange(2)],1);
                    lWidth = randi([sRange(1),sRange(2)],1);
                    % fix height and peak to maintain shape ratio
                    lHeight = round((lWidth/leafShapeRatio(1))*leafShapeRatio(2));
                    lHeights = [round(lHeight/2),round(lHeight/2)];
                    lPeak = round(lWidth*peakDistance);
                    lPeaks = [lPeak,lPeak];
                case 1
                    switch drawingSide(i)
                        case simple % draw on simple side
                            leafLoc = [randi(hSimpRange,1),randi(wSimpRange,1)];
                            % define leaf paramaters within SIMPLE ranges
                            lLum = randi([SlRange(1),SlRange(2)],1);
                            lAngle = randi([SaRange(1),SaRange(2)],1);
                            lWidth = randi([SsRange(1),SsRange(2)],1);
                            % fix height and peak to maintain shape ratio
                            lHeight = round((lWidth/leafShapeRatio(1))*leafShapeRatio(2));
                            lHeights = [round(lHeight/2),round(lHeight/2)];
                            lPeak = round(lWidth*peakDistance);
                            lPeaks = [lPeak,lPeak];
                        case complex % complex
                            leafLoc = [randi(hCompRange,1),randi(wCompRange,1)];
                            % define leaf paramaters within ranges
                            lLum = randi([lRange(1),lRange(2)],1);
                            lAngle = randi([aRange(1),aRange(2)],1);
                            lWidth = randi([sRange(1),sRange(2)],1);
                            % fix height and peak to maintain shape ratio
                            lHeight = round((lWidth/leafShapeRatio(1))*leafShapeRatio(2));
                            lHeights = [round(lHeight/2),round(lHeight/2)];
                            lPeak = round(lWidth*peakDistance);
                            lPeaks = [lPeak,lPeak];
                    end
                case 2
                    
            end
            % draw leaf based on parameters
            leafMat = drawLeaf(lType,lLum,lAngle,lWidth,lHeights,lPeaks);
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
        % write image
        image = uint8(display);
        image = image(edgeBuffer:edgeBuffer+height,edgeBuffer:edgeBuffer+width);
        imwrite(image,'test.jpg');
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
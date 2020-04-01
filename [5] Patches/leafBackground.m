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
compMat = [high,low,low,low]; % [lum,size,angle,num]
locMat = [patch,complex,1,200,0];

% if locMat(1) = whole
%   (2) = N/A
%   (3) = N/A
%   (4) = N/A
% if locMat(1) = side
%   (2) = complex side
%   (3) = side target is on
%   (4) = N/A
%   (5) = N/A
% if locMat(1) = patch
%   (2) = patch complexity
%   (3) = number of patches
%   (4) = radius of patches
%   (5) = target on patch logical

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
num = 2000; % low complexity number of leaves
num = [num,num*2,num*3]; % number range for complex side

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
                patchComp = locMat(trial,2);
                nPats = locMat(trial,3); % number of patches
                patRad = locMat(trial,4); % radius of patches
                targOnPat = locMat(trial,5); % whether target is on a complex patch, logical
        end
    end
    
    % location stuff
    % define size of buffer so leaves can go a bit over edge of screen:
    edgeBuffer = sRange(2);
    % define target location properly:
    [splitWidth,splitHeight] = splitScreen(edgeBuffer,width,height);
    switch SOP
        case whole
            % define width and height ranges for target location generation
            locWidthR = [splitWidth(1),splitWidth(3)];
            locHeightR = [splitHeight(1),splitHeight(3)];
            % generate target location
            targHeightRange = [locHeightR(1)+round((targHeight/2)),locHeightR(2)-round((targHeight/2))];
            targWidthRange = [locWidthR(1)+round((targWidth/2)),locWidthR(2)-round((targWidth/2))];
            targLoc = [randi(targHeightRange,1),randi(targWidthRange,1)];
            targRect = [0,0,targWidth,targHeight];
            targRect = CenterRectOnPoint(targRect,targLoc(1),targLoc(2));
        case side
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
            % generate target location
            targLoc = [randi(targHeightRange,1),randi(targWidthRange,1)];
            targRect = [0,0,targWidth,targHeight];
            targRect = CenterRectOnPoint(targRect,targLoc(1),targLoc(2));
            % define drawing side for leaves
            drawingSide = Shuffle([zeros(1,SnLeaves),ones(1,totLeaves)]);
            totLeaves = totLeaves + SnLeaves;
        case patch
            % define width and height ranges for patch and target location generation
            locWidthR = [splitWidth(1),splitWidth(3)];
            locHeightR = [splitHeight(1),splitHeight(3)];
            % get patch location
            patchHeightRange = [locHeightR(1)+round(patRad),locHeightR(2)-round(patRad)];
            patchWidthRange = [locWidthR(1)+round(patRad),locWidthR(2)-round(patRad)];
            patchLoc = [randi(patchHeightRange,1),randi(patchWidthRange,1)];
            patchRect = [0,0,patRad*2,patRad*2];
            patchRect = CenterRectOnPoint(patchRect,patchLoc(1),patchLoc(2));
            % generate pixel indicies within patch and outside of patch
            switch targOnPat
                case 0
                    patLog = 0;
                    patDisp = ones(height,width);
                    sideBuffer = ones(height,edgeBuffer);
                    topBuffer = ones(edgeBuffer,width+(edgeBuffer*2));
                case 1
                    patLog = 1;
                    patDisp = zeros(height,width);
                    sideBuffer = zeros(height,edgeBuffer);
                    topBuffer = zeros(edgeBuffer,width+(edgeBuffer*2));
            end
            [outLog,patchMat] = drawEllipse(patRad,patRad,patLog,0);
            patDisp(patchRect(1):patchRect(3),patchRect(2):patchRect(4)) = patchMat;
            patDisp = [sideBuffer,patDisp,sideBuffer];
            patDisp = [topBuffer;patDisp;topBuffer];
            % put target in random location on or off patch
            [rows,cols,vals] = find(patDisp==1); % get all co-ordinates where patDisp = 1
            targLocInd = randi(size(rows,1),1); % choose random centre co-ordinate
            targLoc = [rows(targLocInd),cols(targLocInd)];
            targRect = [0,0,targWidth,targHeight];
            targRect = CenterRectOnPoint(targRect,targLoc(1),targLoc(2));
            % invert matrix if needed for drawing leaves, so complex parts are 1s and simple parts are 0s
            switch patchComp
                case simple % simple patches
                    if targOnPat == 1 % target on complex side, so patch made up of 1s
                        % invert patch matrix
                        newPatDisp = ones(size(patDisp));
                        newPatDisp(find(patDisp)) = 0;
                        patDisp = newPatDisp;
                    end
                case 1 % complex patches
                    if targOnPat == 0 % target on simple side, so patch made up of 0s
                        % invert patch matrix
                        newPatDisp = zeros(size(patDisp));
                        newPatDisp(find(~patDisp)) = 1;
                        patDisp = newPatDisp;
                    end
            end
    end
    
    % ----------------------------------------------------------------- %
    
    % DRAW LEAVES AND TARGET
    
    try
        % create blank mean-luminance display matrix (plus a bit off edge of screen)
        display = zeros(height+(edgeBuffer*2),width+(edgeBuffer*2)) + backLum;
        for i = 1:totLeaves
            % define leaf location and specs
            switch SOP
                case whole
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
                case side
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
                case patch
                    % random leaf location
                    leafLoc = [randi(locHeightR,1),randi(locWidthR,1)];
                    % compare to patDisp to see if simple or complex
                    switch patDisp(leafLoc(1),leafLoc(2))
                        case simple
                            % define leaf paramaters within ranges
                            lLum = randi([SlRange(1),SlRange(2)],1);
                            lAngle = randi([SaRange(1),SaRange(2)],1);
                            lWidth = randi([SsRange(1),SsRange(2)],1);
                            % fix height and peak to maintain shape ratio
                            lHeight = round((lWidth/leafShapeRatio(1))*leafShapeRatio(2));
                            lHeights = [round(lHeight/2),round(lHeight/2)];
                            lPeak = round(lWidth*peakDistance);
                            lPeaks = [lPeak,lPeak];
                        case complex
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
        [baseLum,targMat] = drawEllipse(targHeight/2,targWidth/2,targLum,targAngle);
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
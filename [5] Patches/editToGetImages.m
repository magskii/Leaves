% draws backgrounds containing multiple leaves
% ellipse-shaped target on top

clear all;

% ----------------------------------------------------------------- %

%GENERAL SET UP

% screen and psychtoolbox
backLum = 210;
Screen('Preference', 'SkipSyncTests', 1); % don't care about timing, so skipping sync tests is fine for now
screenMax = max(Screen('Screens')); % set screen to be external display if applicable
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible'); % can't remember what this does...
PsychImaging('AddTask', 'General', 'UseRetinaResolution'); % use entire display pixel capactiy
[w,rect] = PsychImaging('OpenWindow', screenMax,backLum);
[xCenter,yCenter]=RectCenter(rect); % screen center co-ordinates
[width, height] = RectSize(rect); % window size for easy referral

% ----------------------------------------------------------------- %

% TARGET AND LEAF SPECS

% target
targLum = 100; %round(lumRange(1)+((lumRange(2)-lumRange(1))/2)); % mid-leaf luminance
targAngle = 45; %randi([1,360],1);
targWidth = 80; %round(widthRange(1)+((widthRange(2)-widthRange(1))/2)); % mid-leaf width
targHeight = 60; %round(heightRange(1)+((heightRange(2)-heightRange(1))/2)); % mid-leaf height

% leaf shape
lType = 1;
peakDistance = 0.25;
HCD = gcd(targWidth,targHeight); % for leaf ratios
leafShapeRatio = [round(targWidth/HCD),round(targHeight/HCD)]; %fixed width and height

% leaf complexity values
numRange = [10:10:1000];
angRange = [5:5:90];
lumRange = [10:5:100];
minLum = 5; % minimum difference between leaf luminance and target luminance - so you can always see the target
trialSiz = 10; % how much size varies by

% ----------------------------------------------------------------- %

% START IMAGE GENERATION
for rep = 1
    for compType = 1:3
        % fix other two specs at aribtrary low-ish level
        switch compType
            case 1 % changing number
                trialLum = lumRange(4)
                trialAng = angRange(4)
                rangeLength = length(numRange)
            case 2 % changing luminance
                trialAng = angRange(4)
                trialNum = numRange(25)
                rangeLength = length(lumRange)
            case 3 %changing angle
                trialLum = lumRange(4)
                trialNum = numRange(25)
                rangeLength = length(angRange)
        end
        
        for trial = 1:rangeLength
            % current trial complexity specs
            switch compType
                case 1 % changing number
                    trialNum = numRange(trial)
                case 2 % changing luminance
                    trialLum = lumRange(trial)
                case 3 %changing angle
                    trialAng = angRange(trial)
            end
            
            % possible ranges of leaf specs for this trial
            lRange = [targLum-trialLum:targLum-minLum,targLum+minLum:targLum+trialLum]
            aRange = [targAngle-trialAng:targAngle+trialAng,targAngle+180-trialAng:targAngle+180+trialAng];
            %aRange = [targAngle-trialAng,targAngle+trialAng];
            sRange = [targWidth-trialSiz,targWidth+trialSiz];
            
            % location stuff
            % define size of buffer so leaves can go a bit over edge of screen:
            edgeBuffer = sRange(2);
            % define target location properly:
            [splitWidth,splitHeight] = splitScreen(edgeBuffer,width,height);
            
            % define width and height ranges for target location generation
            locWidthR = [splitWidth(1),splitWidth(3)];
            locHeightR = [splitHeight(1),splitHeight(3)];
            % generate target location
            targHeightRange = [locHeightR(1)+round((targHeight/2)),locHeightR(2)-round((targHeight/2))];
            targWidthRange = [locWidthR(1)+round((targWidth/2)),locWidthR(2)-round((targWidth/2))];
            targLoc = [randi(targHeightRange,1),randi(targWidthRange,1)];
            targRect = [0,0,targWidth,targHeight];
            targRect = CenterRectOnPoint(targRect,targLoc(1),targLoc(2));
            
            
            % ----------------------------------------------------------------- %
            
            % DRAW LEAVES AND TARGET
            
            try
                % create blank mean-luminance display matrix (plus a bit off edge of screen)
                display = zeros(height+(edgeBuffer*2),width+(edgeBuffer*2)) + backLum;
                for i = 1:trialNum
                    % define leaf location and specs
                    %location
                    leafLoc = [randi(locHeightR,1),randi(locWidthR,1)];
                    % define leaf paramaters within ranges
                    lWidth = randi([sRange(1),sRange(2)],1);
                    selectAng = randi([length(aRange)],1);
                    lAngle = aRange(selectAng);
                    selectLum = randi([length(lRange)],1);
                    lLum = lRange(selectLum);
                    
                    % fix height and peak to maintain shape ratio
                    lHeight = round((lWidth/leafShapeRatio(1))*leafShapeRatio(2));
                    lHeights = [round(lHeight/2),round(lHeight/2)];
                    lPeak = round(lWidth*peakDistance);
                    lPeaks = [lPeak,lPeak];
                    
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
                image = cur2lin(image);
                imName = ['rep',num2str(rep),'_varying',num2str(compType),'_num',num2str(trialNum),'_lum',num2str(trialLum),'_ang',num2str(trialAng)];
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
    end
end


Priority(0);
sca;
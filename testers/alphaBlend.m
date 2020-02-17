% PsychDefaultSetup(2); 
% Screen('Preference', 'SkipSyncTests', 1);
% screenNum = max(Screen('Screens')); % set screen 
% Screen('Preference', 'VisualDebugLevel', 3);
% [w, rect] = Screen('OpenWindow', screenNum, [100 100 100], [0 0 400 400]);

clear all;

backLum = 255;
Screen('Preference', 'SkipSyncTests', 1); % don't care about timing, so skipping sync tests is fine for now
screenMax = max(Screen('Screens')); % set screen to be external display if applicable
PsychImaging('PrepareConfiguration');
PsychImaging('AddTask', 'General', 'FloatingPoint32BitIfPossible'); % can't remember what this does...
PsychImaging('AddTask', 'General', 'UseRetinaResolution'); % use entire display pixel capactiy
[w,rect] = PsychImaging('OpenWindow', screenMax,backLum,[0 0 1000 1000]);
[xCenter,yCenter]=RectCenter(rect); % screen center co-ordinates
[width, height] = RectSize(rect); % window size for easy referral

Screen('BlendFunction', w, 'GL_SRC_ALPHA', 'GL_ONE_MINUS_SRC_ALPHA');

[img, ~, alpha] = imread('testCross.png');

texture1 = Screen('MakeTexture', w, img);
img(:, :, 4) = alpha;
texture2 = Screen('MakeTexture', w, img);

Screen('DrawTexture', w, texture2);
Screen('Flip', w);

% test ellipse drawing
clear all;

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


height = 400;
width = 300;
lum = 128;
angle = 45;

target = drawEllipse(height,width,lum,angle);


targetTexture = Screen('MakeTexture',w,target);
Screen('DrawTexture',w,targetTexture);



Screen('Flip',w,[],1);

KbWait;
Priority(0);
sca;
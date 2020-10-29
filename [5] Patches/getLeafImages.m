% run leaves forever
% program calls leafBackground function to generate as many leaf
% backgrounds as specified


nReps = 10

% rolling specs
luminance = [1:127]
angle = [1:180]
number = [0:10:4000]

%static specs
statLum = 30
statAng = 20
statNum = 1000;



lumMat = [0:255];

lumMat(2,:) = cur2lin(curLum);

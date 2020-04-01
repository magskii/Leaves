% test draw ellipse for patch generation

clear all;

height = 1000;
width = 2000;
edgeBuffer = 100;
patRad = 5;
targOnPat = 1;


% define target location properly:
[splitWidth,splitHeight] = splitScreen(edgeBuffer,width,height);

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

[rows,cols,vals] = find(patDisp==1); % get all co-ordinates where patDisp = 1
targLocInd = randi(size(rows,1),1);
targLoc = [rows(targLocInd),cols(targLocInd)];


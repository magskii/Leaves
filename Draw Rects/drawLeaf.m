% function to create single leaf texture matrix

% TO DO:
%   SORT ASYMMETRIC PEAKS + HEIGHTS
%   BLEND BETTER WITH NEW BACKGROUNDS

% INPUTS:
%   lType = type of leaf shape, determined by lines used to draw it
%   lLum = luminance of leaf
%   lAngle = rotation angle of leaf (degrees)
%   lWidth = width of leaf
%   lHeights = 1*2 matrix with height of upper and lower parts of leaf
%   lPeaks = 1*2 matrix with location on x axis of upper and lower peaks of leaf

% OUTPUTS:
%   leafMat = luminance matrix describing single leaf

% ----------------------------------------------------------------- %

function leafMat = drawLeaf(lLum,lAngle,lWidth,lHeight)


% ----------------------------------------------------------------- %

% MAKE LEAF TEXTURE OUT OF LINES

% create matrix of pixel luminances using co-ordinates
texMat = zeros(lHeight,lWidth);
texMat = texMat + lLum;

% rotate leaf matrix
leafMat = imrotate(texMat,lAngle,'bilinear');
for i = 1:numel(leafMat) % convert back to all same luminance (makes edges more jaggedy, but removes edge artifacts after pasting)
    if leafMat(i) > 0
        leafMat(i) = lLum;
    end
end

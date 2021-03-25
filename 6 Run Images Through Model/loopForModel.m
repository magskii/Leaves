% loop for images

% create output matrix
% cols: complexity type, number, luminance, angle, side, repetition, SE, clutter value
% rows: trials, i.e. total images = (num+lum+ang)*sides*reps
%       so (100+19+18)*2*250 = 68500
% ONLY DEFINE THE FOLLOWING THE FIRST TIME YOU RUN!!
% outMat = zeros(68500,8);

% load in outMat to as far as you've gotten
load outMat

% set which set of repetitions you're analysing
start = 1;
finish = 2;
% set the trial you're starting at according to start point
trial = (137*(start-1))+1;

% set fixed metrics
numFix = 250;
lumFix = 25;
angFix = 20;

% get image names and analyse
for rep = start:finish
    for compType = 1:3
        switch compType
            case 1 % changing number
                lum = lumFix;
                ang = angFix;
                for num = 10:10:1000
                    for side = 1:2
                        % set file name
                        imName = ['varying',num2str(compType),'_num',num2str(num),'_lum',num2str(lum),'_ang',num2str(ang),'_side',num2str(side),'_rep',num2str(rep),'.png']
                        % get clutter metrics
                        [clutter_scalar_fc, clutter_map_fc] = getClutter_FC(imName);
                        clutter_scalar_fc;
                        clutter_se = getClutter_SE(imName);
                        % add to output matrix
                        outMat(trial,:) = [compType,num,lum,ang,side,rep,clutter_se,clutter_scalar_fc];
                        trial = trial + 1 % leave open so can see it's not gotten stuck
                    end
                end
            case 2 % changing luminance
                ang = angFix;
                num = numFix;
                for lum = 10:5:100
                    for side = 1:2
                        imName = ['varying',num2str(compType),'_num',num2str(num),'_lum',num2str(lum),'_ang',num2str(ang),'_side',num2str(side),'_rep',num2str(rep),'.png']
                        % get clutter metrics
                        [clutter_scalar_fc, clutter_map_fc] = getClutter_FC(imName);
                        clutter_scalar_fc;
                        clutter_se = getClutter_SE(imName);
                        % add to output matrix
                        outMat(trial,:) = [compType,num,lum,ang,side,rep,clutter_se,clutter_scalar_fc];
                        trial = trial + 1 % leave open so can see it's not gotten stuck
                    end
                end
            case 3 %changing angle
                lum = lumFix;
                num = numFix;
                for ang = 5:5:90
                    for side = 1:2
                        imName = ['varying',num2str(compType),'_num',num2str(num),'_lum',num2str(lum),'_ang',num2str(ang),'_side',num2str(side),'_rep',num2str(rep),'.png']
                        % get clutter metrics
                        [clutter_scalar_fc, clutter_map_fc] = getClutter_FC(imName);
                        clutter_scalar_fc;
                        clutter_se = getClutter_SE(imName);
                        % add to output matrix
                        outMat(trial,:) = [compType,num,lum,ang,side,rep,clutter_se,clutter_scalar_fc];
                        trial = trial + 1 % leave open so can see it's not gotten stuck
                    end
                end
        end
    end
end







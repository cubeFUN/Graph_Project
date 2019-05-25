function [ Tps, Fps, AUC ] = DrawROC( scores, labels, paint,prefix,k ) 
scores=scores.';labels=labels.'; 

prefixFile = './output/t-test-new/';
filepath = strcat(prefixFile,prefix,'/Feature#',num2str(k));

%% Sort Labels and Scores by Scores  
sl = [scores; labels];  
[d1, d2] = sort(sl(1,:));  
   
sorted_sl = sl(:,d2);  
s_scores = sorted_sl(1,:);  
s_labels = round(sorted_sl(2,:));  
%% Constants  
counts = histc(s_labels, unique(s_labels));  
   
Tps = zeros(1, size(s_labels,2) + 1);  
Fps = zeros(1,  size(s_labels,2) + 1);  
AUC = 0;

negCount = counts(1);  
posCount = counts(2);  
   
%% Shift threshold to find the ROC  
Tps(1)=1;
Fps(1)=1;
for thresIdx = 2:size(s_scores,2)+1 
   
    % for each Threshold Index  
    tpCount = 0;  
    fpCount = 0;  
   
    for i = 1:size(s_scores,2)
   
        if (i >= thresIdx)           % We think it is positive  
            if (s_labels(i) == 1)   % Right!  
                tpCount = tpCount + 1;  
            else                    % Wrong!  
                fpCount = fpCount + 1;  
            end  
        end  
    end  
   
    Tps(thresIdx) = tpCount/posCount;  
    Fps(thresIdx) = fpCount/negCount;  
    AUC=AUC+(Tps(thresIdx)+ Tps(thresIdx-1))*( Fps(thresIdx-1)- Fps(thresIdx))/2;
    AUC
end  

if ~paint 
    return;
end
%% Draw the Curve  
   
tt = strcat(prefix,'---','Feature#',num2str(k),'---','AUC=',num2str(AUC));

% Sort [Tps;Fps]  
x = Fps;  
y = Tps;  
   
% Interplotion to draw spline line  
count = 100;  
dist = (x(1) - x(size(x,2)))/100;  
xx = [x(1):-dist:x(size(x,2))];  
   
% In order to get the interpolations, we remove all the unique numbers  
[d1 d2] = unique(x);  
uni_x = x(1,d2);  
uni_y = y(1,d2);  
yy = spline(uni_x,uni_y,xx);  
   
% No value should exceed 1  
yy = min(yy, 1);  
h = figure(1)   
plot(x,y,'x',xx,yy);  
title(tt);
xlabel('False Positive Rate');
ylabel('True Positive Rate')
fileScatter=[filepath,'.png'];
saveas(h,fileScatter);
end


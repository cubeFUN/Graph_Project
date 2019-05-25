function [ threshold ] = computeSurvivalCurve( scores,labels,livingTime )
scores=scores.';labels=labels.';livingTime=livingTime.';
%% Sort Labels and Scores by Scores  
sl = [scores; labels; livingTime];  
% 根据第一大的特征排序
[d1, d2] = sort(sl(1,:));  
   
sorted_sl = sl(:,d2);  
s_scores = sorted_sl(1,:);  
s_labels = round(sorted_sl(2,:));  
s_livingTime=sorted_sl(3,:);
%% Constants  
counts = histc(s_labels, unique(s_labels));  

negCount = counts(1);  
posCount = counts(2);  

threshold=0;
TR_max=-1;TPR_max=-1;TNR_max=-1;thresIdx_max=-1;

% 遍历每个特征，即遍历所有的阈值
% 求一个阈值使得TR最大
for thresIdx = 1:size(s_scores,2)+1 
   
    % for each Threshold Index  
    tpCount = 0;  % true positive 
    tnCount = 0;  % true negative
   
    for i = 1:size(s_scores,2)
   
        if (i >= thresIdx)           % We think it is positive  在这个阈值设定下
            if (s_labels(i) == 1)    % Right!  
                tpCount = tpCount + 1;  
            end
        else
           if (s_labels(i) == 0)   % Right!  
                tnCount = tnCount + 1;  
           end
        end
        
    end  
   
    TPR = tpCount/posCount;  
    TNR = tnCount/negCount;  
    TR=TPR+TNR;
    if TR>TR_max
        TR_max=TR;TPR_max=TPR;TNR_max=TNR;thresIdx_max=thresIdx;
        threshold=s_scores(thresIdx);
    end
end  

len=length(s_livingTime);
% 把case根据当前阈值分成positive和negative 两个部分X1和X2
X1=[s_livingTime(1,1:thresIdx_max-1);1-s_labels(1,1:thresIdx_max-1)].';
% 把缺少数据case的living time用max time代替
max_time=max(s_livingTime(:));
X1(isnan(X1(:,1)),1)=max_time;
X2=[s_livingTime(1,thresIdx_max:len);1-s_labels(1,thresIdx_max:len)].';
X2(isnan(X2(:,1)),1)=max_time;
% 画图，两种case经过一段时间后的生存率
logrank(X1,X2);
%fprintf('%f,%f,%f,%f,%d\n',threshold,TR_max,TPR_max,TNR_max,thresIdx_max);
end


function [ mat ] = cell2matrix( cell )
%UNTITLED 此处显示有关此函数的摘要
%   此处显示详细说明
    in = dataset.graphWithROIs;
    caseNum = length(in);
    %caseNum = 30;
    % 首先找到矩阵的最大数目
    max = 0;
    for i = 1:caseNum
        if(length(in{i,1})>max)
            max = length(in{i,1});
        end
    end
    
    % 创建矩阵这里
    mat = NaN(max,max,caseNum);
    for i=1:caseNum
        cursize = length(in{i,1});
        for j=1:cursize
            for k=1:cursize
                mat(j,k,i) = in{i,1}(j,k);
            end
        end
    end
end

%% 直接对graph/image- WithROIs 每个case的值取平均

load imageWithROIs.mat
load graphWithROIs.mat


caseNum = length(imageWithROIs);
addInfo = zeros(caseNum, 5);
%caseNum = 30;
% 首先找到矩阵的最大数目
for i = 1:caseNum
    addInfo(i,1:3) = mean(imageWithROIs{i,1}(:,1:3));
    addInfo(i,4) = mean(imageWithROIs{i,1}(:,4));
    addInfo(i,5) = mean(imageWithROIs{i,1}(:,4));
end

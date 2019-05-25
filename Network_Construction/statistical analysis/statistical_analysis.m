function [statAnalysisResults]=statistical_analysis(features,labels,prefix)
%statistical analysis
%negative mean, positive mean, t-test resutls, AUC
prefixFile = './output/t-test-new/'
filepath = strcat(prefixFile,prefix,'/');
mkdir(filepath);

features = features(~isnan(labels),:);
labels = labels(~isnan(labels));

[nCases,nFeatures]=size(features);
idx_positive=find(labels==1);
idx_negative=find(labels==0);

% 初始化输出结果
statAnalysisResults=zeros(nFeatures,5);
for k=1:nFeatures
    % filename = strcat('Feature#',num2str(k));
    feature_pos=features(idx_positive,k);
    feature_neg=features(idx_negative,k);
    % 第一列表示正样本的平均值
    statAnalysisResults(k,1)=mean(feature_pos);
    % 第二列表示负样本的平均值
    statAnalysisResults(k,2)=mean(feature_neg);
    % 用于比较两组数据是否来自同一分布（可以用于比较两组数据的区分度）
    % 假设了数据的正态性，并反应两组数据的方差在统计上是否有显著差异
    % 第三列：  H=0，则表明零假设在5%的置信度下不被拒绝，即x，y在统计上可看做来自同一分布的数据；
    %           H=1，表明零假设被拒绝，即x，y在统计上认为是来自不同分布的数据，即有区分度。
    % 第四列：  P值。即观察到零假设情况下的可能性。一般太小就可以拒绝零假设。
    [statAnalysisResults(k,3),statAnalysisResults(k,4)]=ttest2(feature_pos,feature_neg);
    [~,~,AUC]=DrawROC(features(:,k),labels,true,prefix,k);
    
    % 第五列： AUC越高，模型的区分能力越好
    statAnalysisResults(k,5)=AUC;
end

end

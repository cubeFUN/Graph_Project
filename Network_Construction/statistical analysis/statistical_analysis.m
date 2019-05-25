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

% ��ʼ��������
statAnalysisResults=zeros(nFeatures,5);
for k=1:nFeatures
    % filename = strcat('Feature#',num2str(k));
    feature_pos=features(idx_positive,k);
    feature_neg=features(idx_negative,k);
    % ��һ�б�ʾ��������ƽ��ֵ
    statAnalysisResults(k,1)=mean(feature_pos);
    % �ڶ��б�ʾ��������ƽ��ֵ
    statAnalysisResults(k,2)=mean(feature_neg);
    % ���ڱȽ����������Ƿ�����ͬһ�ֲ����������ڱȽ��������ݵ����ֶȣ�
    % ���������ݵ���̬�ԣ�����Ӧ�������ݵķ�����ͳ�����Ƿ�����������
    % �����У�  H=0��������������5%�����Ŷ��²����ܾ�����x��y��ͳ���Ͽɿ�������ͬһ�ֲ������ݣ�
    %           H=1����������豻�ܾ�����x��y��ͳ������Ϊ�����Բ�ͬ�ֲ������ݣ��������ֶȡ�
    % �����У�  Pֵ�����۲쵽���������µĿ����ԡ�һ��̫С�Ϳ��Ծܾ�����衣
    [statAnalysisResults(k,3),statAnalysisResults(k,4)]=ttest2(feature_pos,feature_neg);
    [~,~,AUC]=DrawROC(features(:,k),labels,true,prefix,k);
    
    % �����У� AUCԽ�ߣ�ģ�͵���������Խ��
    statAnalysisResults(k,5)=AUC;
end

end

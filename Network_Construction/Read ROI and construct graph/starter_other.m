%function [xyzStep, SUVpara, labels_death, labels_locoregional, labels_distant, livingTime]=starter_other(rootPath, nPetROIs)
function [xyzStep, SUVpara, Recurrence_Label, Histology_label, Survival_Label,...
Lymphovascular_invasion_label,AJCC_label,PN_stage_Recurrence_Label,...
PM_stage_Recurrence_Label,PT_stage_Recurrence_Label,labels_KRAS_mutation,...
labels_ALK_translocation,labels_histopathological_grade_2,labels_histopathological_grade_3] = starter_other(rootPath, nPetROIs);
%load dicom info
% rootPath = './code_data/TCIA_lung/015/roi_pet/';
% 需要把当前有的所有case的ROI读取进来 整理到roi_pet.csv里面去

nPetROIs = 57;
rootPath = 'C:/Users/37908/Documents/MATLAB/Graph_Based_Analysis/DataNew/';
%[addInfo,addInfoTxt,addInfoRaw]=xlsread([rootPath,'roi_pet.csv']);

nSize=size(addInfo,1);
% if nSize~=213
%     fprintf('Error: should be 213 cases in this dataset');
% end

xStepPETIdx=1;yStepPETIdx=2;zStepPETIdx=3;
SUVIdx=4;
xyzStep=zeros(nSize,3);
SUVpara=zeros(nSize,1);
weightAvg=0;doseAvg=0;
for k=1:nSize
    xyzStep(k,1)=addInfo(k,xStepPETIdx);
    xyzStep(k,2)=addInfo(k,yStepPETIdx);
    xyzStep(k,3)=addInfo(k,zStepPETIdx);
end

%processing data sheet
%death 这里是把label和feature对应起来

filePathLabel=[rootPath,'label_New.xlsx'];
[~,~,labelDataRaw]=xlsread(filePathLabel);
nlabels=size(labelDataRaw,1);
if (nlabels-1~=nPetROIs)
    fprintf('Error:Features and labels mismatch!\n');
end
% 这里的ID表示在xls表格中的第几列写了这个label！！！需要整理一下数据了看来w
Recurrence_Label = zeros(nlabels-1,1);
Histology_label = zeros(nlabels-1,1);
Survival_Label = zeros(nlabels-1,1);
Lymphovascular_invasion_label = zeros(nlabels-1,1);
AJCC_label = zeros(nlabels-1,1);
PN_stage_Recurrence_Label = zeros(nlabels-1,1);
PM_stage_Recurrence_Label = zeros(nlabels-1,1);
PT_stage_Recurrence_Label = zeros(nlabels-1,1);


currentID=2;
for i=2:nlabels
    Recurrence_Label(i-1,1)=labelDataRaw{i,currentID};
end

currentID=3;
for i=2:nlabels
    Histology_label(i-1,1)=labelDataRaw{i,currentID};
end

currentID=4;
for i=2:nlabels
    Survival_Label(i-1,1)=labelDataRaw{i,currentID};
end

currentID=5;
for i=2:nlabels
    Lymphovascular_invasion_label(i-1,1)=labelDataRaw{i,currentID};
end

currentID=6;
for i=2:nlabels
    AJCC_label(i-1,1)=labelDataRaw{i,currentID};
end

currentID=7;
for i=2:nlabels
    PN_stage_Recurrence_Label(i-1,1)=labelDataRaw{i,currentID};
end

currentID=8;
for i=2:nlabels
    PM_stage_Recurrence_Label(i-1,1)=labelDataRaw{i,currentID};
end

currentID=9;
for i=2:nlabels
    PT_stage_Recurrence_Label(i-1,1)=labelDataRaw{i,currentID};
end

dataset.Recurrence_Label = Recurrence_Label;
dataset.Histology_label = Histology_label;
dataset.Survival_Label = Survival_Label;
dataset.Lymphovascular_invasion_label = Lymphovascular_invasion_label;
dataset.AJCC_label = AJCC_label;
dataset.PN_stage_Recurrence_Label = PN_stage_Recurrence_Label;
dataset.PM_stage_Recurrence_Label = PM_stage_Recurrence_Label;
dataset.PT_stage_Recurrence_Label = PT_stage_Recurrence_Label;

load ./DataNew/graphWithROIs.mat
load ./DataNew/imageWithROIs.mat
load ./DataNew/SUVpara.mat
load ./DataNew/xyzStep.mat

dataset.graphWithROIs = graphWithROIs;
dataset.imageWithROIs = imageWithROIs;
dataset.SUVpara = SUVpara;
dataset.xyzStep = xyzStep;
end
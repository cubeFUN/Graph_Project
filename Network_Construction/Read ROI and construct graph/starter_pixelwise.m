function [dataset]=starter_pixelwise(rootPath)
%	read dataset from rootPath
rootPath = 'C:/Users/37908/Documents/MATLAB/Graph_Based_Analysis/DataNew/';
readinPath = strcat(rootPath, 'TCIA_lung/');
listing=dir(readinPath);
nFolds=length(listing);
nFiles = 133;
% 一共133组可以用的有label的数据

imageWithROIs=cell(nFiles,1);
graphWithROIs=cell(nFiles,1);
SUVpara = zeros(nFiles,1);
nPetROIs=0;
for k=3:nFolds
%for k = 32:32
   filePath_patientID=[readinPath,listing(k).name,'/roi_pet/'];
   if ~isequal(listing(k).name,'.') && ~isequal(listing(k).name,'..')...
           && ~isequal(listing(k).name(end),'l') && isdir(filePath_patientID)
       filePathDir_patientID=dir(filePath_patientID);
       %nROIs=size(filePathDir_patientID);
       nROIs = 1;
       % for kk=1:nROIs
       for kk=3
           if ~isequal(filePathDir_patientID(kk).name,'.') && ~isequal(filePathDir_patientID(kk).name,'..') ...
               && ~isequal(filePathDir_patientID(kk).name(end),'l')
               filePath_ROI=[filePath_patientID,'roi_pet.csv'];
               if exist(filePath_ROI,'file')
                   [addInfo,~,~]=xlsread(filePath_ROI);
                   nPetROIs=nPetROIs+1;
                   SUVpara(nPetROIs,1) = mean(addInfo(:,4));
                   imageWithROIs{nPetROIs,1}=fromN4mat23dmat(addInfo);
                   graphWithROIs{nPetROIs,1}=ROI2graph(imageWithROIs{nPetROIs,1});
                   fprintf('%s done\n',listing(k).name);
               else
                   fprintf('Error: Cannot find ROI at %s\n',filePath_ROI);
               end
           end
       end
   end
end

save imageWithROIs.mat imageWithROIs -v7.3
save graphWithROIs.mat graphWithROIs -v7.3
save SUVpara.mat SUVpara -v7.3
%%
[xyzStep, SUVpara, labels_recurrence, labels_histology, labels_survival,...
    labels_lymphovascular_invasion,labels_EGFR_mutation_status,labels_AJCC_label,...
    labels_histopathological_grade_1,labels_pleural_invasion,labels_KRAS_mutation,...
    labels_ALK_translocation,labels_histopathological_grade_2,labels_histopathological_grade_3]=starter_other(rootPath, nPetROIs);

dataset.graphWithROIs=graphWithROIs;        % {213x1 cell}
dataset.imageWithROIs=imageWithROIs;        % {213x1 cell}
dataset.xyzStep=xyzStep;                    % [213x3 double]
dataset.SUVpara=SUVpara;                    % [213x3 double]                   


dataset.labels_recurrence = labels_recurrence;
dataset.labels_histology = labels_histology;
dataset.labels_survival = labels_survival;
dataset.labels_lymphovascular_invasion = labels_lymphovascular_invasion;
dataset.labels_EGFR_mutation_status = labels_EGFR_mutation_status;
dataset.labels_AJCC_label = labels_AJCC_label;
dataset.labels_histopathological_grade_1 = labels_histopathological_grade_1;
dataset.labels_pleural_invasion = labels_pleural_invasion;
dataset.labels_KRAS_mutation = labels_KRAS_mutation;
dataset.labels_ALK_translocation = labels_ALK_translocation;
dataset.labels_histopathological_grade_2 = labels_histopathological_grade_2;
dataset.labels_histopathological_grade_3 = labels_histopathological_grade_3;

save ./mat/dataset.mat dataset -v7.3
end
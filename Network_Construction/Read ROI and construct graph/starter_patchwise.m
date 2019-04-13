function [dataset]=starter_patchwise(rootPath)
%	read dataset from rootPath
rootPathDir=dir(rootPath);
nFolds=size(rootPathDir,1);
imageWithROIs=cell(213,1);
graphWithROIs=cell(213,1);
nPetROIs=0;
for k=1:30
   filePath_patientID=[rootPath,rootPathDir(k).name,'/'];
   if ~isequal(rootPathDir(k).name,'.') && ~isequal(rootPathDir(k).name,'..') && isdir(filePath_patientID)
       filePathDir_patientID=dir(filePath_patientID);
       nROIs=size(filePathDir_patientID);
       for kk=1:nROIs
           if ~isequal(filePathDir_patientID(kk).name,'.') && ~isequal(filePathDir_patientID(kk).name,'..')
               filePath_image=[filePath_patientID,filePathDir_patientID(kk).name,'/PET_image.mat'];
               filePath_mask=[filePath_patientID,filePathDir_patientID(kk).name,'/PET_image_ROI_mask.mat'];
               if exist(filePath_image,'file') && exist(filePath_mask,'file')
                   image_PET=load(filePath_image);
                   mask_PET=load(filePath_mask);
                   boundingBox=computeBoundingBox(mask_PET.imageMask);
                   nPetROIs=nPetROIs+1;
                   graphWithROIs{nPetROIs,1}=ROI2graphCoef(image_PET.image,mask_PET.imageMask, boundingBox);
               else
                   fprintf('Error: Cannot find PET image at %s\n',filePath_image);
               end
               
               filePath_ROI=[filePath_patientID,filePathDir_patientID(kk).name,'/PET_image_ROI.mat'];
               if exist(filePath_ROI,'file')
                   data=load(filePath_ROI);
                   imageWithROIs{nPetROIs,1}=data.imageWithROI;
               else
                   fprintf('Error: Cannot find ROI at %s\n',filePath_ROI);
               end
               
           end
       end
   end
end

[xyzStep, SUVpara, labels_death, labels_locoregional, labels_distant, livingTime]=starter_other(rootPath, nPetROIs);

dataset.graphWithROIs=graphWithROIs;
dataset.imageWithROIs=imageWithROIs;
dataset.xyzStep=xyzStep;
dataset.SUVpara=SUVpara;
dataset.labels_death=labels_death;
dataset.labels_locoregional=labels_locoregional;
dataset.labels_distant=labels_distant;
dataset.livingTime=livingTime;
dataset.nPetROIs=nPetROIs;

end
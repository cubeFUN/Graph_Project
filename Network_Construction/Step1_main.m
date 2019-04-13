%%
clear;
addpath('../Read ROI and construct graph/');
addpath('../Compute graph-based features/');

%	read dataset from rootPath
rootPath = 'C:\Users\37908\Documents\MATLAB\Graph_Based_Analysis\data\Data_1108\radiogenomics_PET.mat';
load(rootPath);

nameArray = dataset.nameArray;
imageSUV = dataset.imageSUV;
nFiles = length(imageSUV);

imageWithROIs=cell(nFiles,1);
graphWithROIs=cell(nFiles,1);
name_array = cell(nFiles,1);
SUVpara = zeros(nFiles,1);
nPetROIs=0;

for k=1:nFiles
   % for kk=1:nROIs
	   image=imageSUV{k,1};
	   nPetROIs=nPetROIs+1;
	   cur_size = imageSUV{k,2};
	   node_size(nPetROIs,1) = cur_size;
	   name_array{nPetROIs} = nameArray{k};
	   
	   fprintf('current size is %d\n',cur_size);
	   imageWithROIs{nPetROIs,1}=image;
	   graphWithROIs{nPetROIs,1}=ROI2graphCorrelation(image);
	   fprintf('%d/%d done\n',nPetROIs,nFiles);		  
end

save imageWithROIs.mat imageWithROIs -v7.3
save graphWithROIs.mat graphWithROIs -v7.3
save SUVpara.mat SUVpara -v7.3
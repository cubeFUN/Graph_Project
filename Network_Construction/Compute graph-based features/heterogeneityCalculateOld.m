% -------------------------------------------------------------------------
% DESCRIPTION: 
% This program aims to calculate heterogeneity.
% Input: volume
% Output: heterogeneity
% -------------------------------------------------------------------------
% AUTHOR: Zhe Guo <guo.zion@gmail.com>
% -------------------------------------------------------------------------
% HISTORY: 
% - Creation: January 4th 2017
% - Revision: January 4th 2017
% - Version 1.0
% -------------------------------------------------------------------------
function [value] = heterogeneityCalculateOld(volume, xStep, yStep, zStep, dis)
%     volume = PetROI;
%     xStep = xyzStep(k,1);
%     yStep = xyzStep(k,2);
%     zStep = xyzStep(k,3);
%     dis = 2;

    dis = dis*sqrt(xStep^2+yStep^2+zStep^2);
    dis
	volumeDEM = size(volume);
    Index = find(volume(:) ~= 0);
	ROIVolume = zeros(volumeDEM);
	ROIVolume(Index) = 1;
    volumeAverage = sum(volume(:))/sum(ROIVolume(:));
    tempVolume = volume;
    tempVolume(tempVolume(:) == 0) = volumeAverage;
    tempVolume = tempVolume - volumeAverage;
    tempVolume = tempVolume .*tempVolume;
    variance = sum(tempVolume(:));

	weightSum = 0; 
	covarianceSum = 0;
	for i = 1:volumeDEM(1)
		for j = 1:volumeDEM(2)
			for k = 1:volumeDEM(3)
				pos = [i,j,k];
				if(ROIVolume(i,j,k)  == 1)
					distSpace = disSpaceCalculate(pos,dis,volumeDEM,xStep, yStep, zStep);
					weightVolume = ROIVolume .* distSpace;
					tempVolume = volume .* weightVolume;
					tempVolume(tempVolume == 0) = volumeAverage;
					tempVolume = tempVolume - volumeAverage;
					tempCovariance = (volume(i,j,k) -volumeAverage)*sum(tempVolume(:));
					covarianceSum = covarianceSum + tempCovariance;
					weightSum = weightSum + sum(weightVolume(:));
				end
			end
		end
    end
    
	value = covarianceSum*sum(ROIVolume(:))/(variance*weightSum);
end


%% disSpaceCalculate
% This function will return a same size volume with all pixels 
% within certain distance of certain position.
function [distSpace] = disSpaceCalculate(pos,dis,volumeDEM,xSlicer,ySlicer,zSlicer)

	%xSlicer = 1;
	%ySlicer = 1;
	%zSlicer = 1;

	distSpace = zeros(volumeDEM);

	%Calculate the possible X axis.
	lowBand = pos(1) - ceil(dis/xSlicer);
	if(lowBand <= 1) lowBand = 1; end;
	highBand = pos(1) + ceil(dis/xSlicer);
	if(highBand >= volumeDEM(1)) highBand = volumeDEM(1);end;
	xAxis = [lowBand,highBand];

	%Calculate the possible y axis.
	lowBand = pos(2) - ceil(dis/ySlicer);
	if(lowBand <= 1) lowBand = 1; end;
	highBand = pos(2) + ceil(dis/ySlicer);
	if(highBand >= volumeDEM(2)) highBand = volumeDEM(2);end;
	yAxis = [lowBand,highBand];

	%Calculate the possible z axis.
	lowBand = pos(3) - ceil(dis/zSlicer);
	if(lowBand <= 1) lowBand = 1; end;
	highBand = pos(3) + ceil(dis/zSlicer);
	if(highBand >= volumeDEM(3)) highBand = volumeDEM(3);end;
	zAxis = [lowBand,highBand];


	for i = xAxis(1):xAxis(2)
		for j = yAxis(1):yAxis(2)
			for k = zAxis(1):zAxis(2)
				distSpace(i,j,k) = sqrt((xSlicer*(i-pos(1)))^2+(ySlicer*(j-pos(2)))^2+(zSlicer*(k-pos(3)))^2);
			end
		end
    end
    
    tempIndex1 = find(distSpace(:) > 0);
    tempIndex2 = find(distSpace(:) < dis);
	%tempIndex2 = find(distSpace(:) <= dis);
    index = intersect(tempIndex1,tempIndex2);
	distSpace(index) = 1;
    %distSpace(distSpace > dis) = 0;
    distSpace(distSpace >= dis) = 0;

    distSpace = round(distSpace);
end
function [ ans ] = SUVmean(imageWithROI,weight,dose)
%calculate SUV mean
%   compute SUV mean
[width,height,depth]=size(imageWithROI);
sum=0;counter=0;
for i=1:width
    for j=1:height
        for k=1:depth
            if ~isnan(imageWithROI(i,j,k))
                sum=sum+imageWithROI(i,j,k)*weight/dose*1000;
                counter=counter+1;
            end
        end
    end
end
ans=sum/counter;
end


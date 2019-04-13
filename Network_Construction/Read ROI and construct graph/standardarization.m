function [ image_out ] = standardarization( image )
%   remapping image(-1,1) to (0,1)
%   useful for adajacent matrix of a graph
[width,height,depth]=size(image);
image_out=zeros(width,height,depth);
for i=1:width
    for j=1:height
        for k=1:depth
            image_out(i,j,k)=1-(image(i,j,k)+1)/2;
        end
    end
end

end


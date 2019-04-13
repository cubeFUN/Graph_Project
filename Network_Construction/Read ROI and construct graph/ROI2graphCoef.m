function [ graph ] = ROI2graphCoef(image,imageMask,boundingBox,interval,clampDistance)
%	generate graph from given ROI 
%   input: a ROI matrix where NaN indicates non-ROI region, 
%   output: a graph adjacent matrix 
%	Each node in the graph is a patch in the ROI. A patch is a 3x3x3 grid whose center is a pixel. 
%	A patch connects to other patches which can construct a fully connected graph. 
%	The weight of each edge is the coefficient between patches.
%	"Interval" indicates the interval between each patch(could be 1 or 2).
%	When the distance between patches are more than the "clamp distance", the coefficient between these patches will decrease to 0.

%	image:ROI matrix
%	imageMask:ROI matrix mask
%	boundingBox:ROI boundingBox
%	interval:patch interval
%	clampDistance:clamp distance
%	graph:adjacent matrix of a graph
if nargin<4
	interval=1;
	clampDistance=3;
elseif nargin<5
	clampDistance=3;
end
steps=[-1,1,1;0,1,1;1,1,1;-1,0,1;0,0,1;1,0,1;-1,-1,1;0,-1,1;1,-1,1;...
    -1,1,0;0,1,0;1,1,0;-1,0,0;0,0,0;1,0,0;-1,-1,0;0,-1,0;1,-1,0;...
    -1,1,-1;0,1,-1;1,1,-1;-1,0,-1;0,0,-1;1,0,-1;-1,-1,-1;0,-1,-1;1,-1,-1;];
[width,height,depth]=size(image);
patch=[];
patchPos=[];
for i=boundingBox(1,1):interval:boundingBox(1,2)
    for j=boundingBox(2,1):interval:boundingBox(2,2)
        for k=boundingBox(3,1):interval:boundingBox(3,2)
            if imageMask(i,j,k)==1
                vec=zeros(27,1);pos=[i,j,k];
                for t=1:27
                    vec(t,1)=image(i+steps(t,1),j+steps(t,2),k+steps(t,3));
                end
                patch=[patch,vec];
                patchPos=[patchPos;pos];
            end
        end
    end
end

graph=corrcoef(patch);
graph=standardarization(graph);

nPatch=size(patch,2);
for i=1:nPatch
    for j=1:nPatch
        len=norm(patchPos(i,:)-patchPos(j,:));
        if (len>clampDistance) 
            graph(i,j)=0;
            continue;
        end
        len=len+1;
        graph(i,j)=10*graph(i,j)/(len*len);
    end
end

end
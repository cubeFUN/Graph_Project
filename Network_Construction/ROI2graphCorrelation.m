function [ graphWithROIs ] = ROI2graphCorrelation(imageWithROI)
	%	generate graph from given ROI 
	%   input: a ROI matrix where NaN indicates non-ROI region, 
	%   output: a graph adjacent matrix 
	%	Each node in the graph is a pixel in the ROI, and the
	%   node connect to its adjacent 26 pixels, the weight of each edge is the intensity
	%   difference between adjacent pixels

	%	imageWithROI: ROI matrix
	%	graph:adjacent matrix of a graph
	% I = load('./DataNew/imageWithROIs.mat');
	seq = [-2,-1,0,1,2];
	mask = zeros(125,3);
	for i = 0:124
		a = rem(i,5) + 1;
		b = floor((i - floor(i / 25)*25)/5) + 1;
		c = floor(i/25) + 1;
		mask(i+1,:) = [seq(c),seq(b),seq(a)];
	end

    [width,height,depth]=size(imageWithROI);

    map=zeros(width,height,depth);
    nNodes=0;
    for i=1:width
        for j=1:height
            for k=1:depth
                if (~isnan(imageWithROI(i,j,k)) && (imageWithROI(i,j,k)~=0))
                    nNodes=nNodes+1;
                    map(i,j,k)=nNodes;
                end
            end
        end
	end
	
	valueNearby = ConstructNeighbor(imageWithROI,map);
	%disp(valueNearby)
    graphWithROIs=zeros(nNodes,nNodes);
    for i=1:width
        for j=1:height
            for k=1:depth
                if (map(i,j,k)~=0)
                    node0=map(i,j,k);
					value0=valueNearby{i,j,k};
					for ii=1:width
						for jj=1:height
							for kk=1:depth
								if (map(ii,jj,kk)>node0)
									node1=map(ii,jj,kk);
									value1=valueNearby{ii,jj,kk};
                                    %disp('value0')
									%disp(value0)
                                    %disp('value1')
									%disp(value1)
									correlation = ComputeNormalizedCorrelation(value0,value1);
									graphWithROIs(int16(node0),int16(node1)) = correlation;  
									graphWithROIs(int16(node1),int16(node0)) = correlation; 
								end
							end
						end
					end
                end
            end
		end
	end
end
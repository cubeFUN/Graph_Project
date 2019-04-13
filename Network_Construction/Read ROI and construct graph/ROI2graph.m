function [ graph ] = ROI2graph(imageWithROI)
%	generate graph from given ROI 
%   input: a ROI matrix where NaN indicates non-ROI region, 
%   output: a graph adjacent matrix 
%	Each node in the graph is a pixel in the ROI, and the
%   node connect to its adjacent 26 pixels, the weight of each edge is the intensity
%   difference between adjacent pixels

%	imageWithROI: ROI matrix
%	graph:adjacent matrix of a graph
mask=[-1,1,1;0,1,1;1,1,1;-1,0,1;0,0,1;1,0,1;-1,-1,1;0,-1,1;1,-1,1;...
    -1,1,0;0,1,0;1,1,0;-1,0,0;0,0,0;1,0,0;-1,-1,0;0,-1,0;1,-1,0;...
    -1,1,-1;0,1,-1;1,1,-1;-1,0,-1;0,0,-1;1,0,-1;-1,-1,-1;0,-1,-1;1,-1,-1;];

[width,height,depth]=size(imageWithROI);

map=zeros(width,height,depth);
nNodes=0;
for i=1:width
    for j=1:height
        for k=1:depth
            if (isnan(imageWithROI(i,j,k))==false)
                nNodes=nNodes+1;
                map(i,j,k)=nNodes;
            end
        end
    end
end

graph=zeros(nNodes,nNodes);
for i=1:width
    for j=1:height
        for k=1:depth
            if (map(i,j,k)~=0)
                node0=map(i,j,k);pixel0=imageWithROI(i,j,k);
                for t=1:27
                    % 遍历当前点的周围9+8+9=26个方向
                    ii=i+mask(t,1);jj=j+mask(t,2);kk=k+mask(t,3);
                    % 确保矩阵没有越界
                    if (ii>=1 && ii<=width && jj>=1 && jj<=height && kk>=1 && kk<=depth)
                        % 如果当前周围点有值
                        if (map(ii,jj,kk)~=0)
                            % nodel 周围点的序号
                            % pixel1 周围点的强度
                            % 减一下计算出差值 就是这个点和其周围点的偏差 bingo
                            node1=map(ii,jj,kk);pixel1=imageWithROI(ii,jj,kk);
                            % graph(i,j)是序号为i的pixel和序号为j的pixel之间的偏差的绝对值
                            % 所以这是个对称阵 主元都为0
                            graph(int16(node0),int16(node1))=abs(pixel0-pixel1);  
                        end
                    end
                end
            end
        end
    end
end
end



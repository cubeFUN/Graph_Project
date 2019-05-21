import numpy as np
from ConstructNeighbor import ConstructNeighbor
from ComputeNormalizedCorrelation import ComputeNormalizedCorrelation
import math

def ROI2graphCorrelation(imageWithROI):
    seq = [-2,-1,0,1,2]
    mask = np.zeros([125,3])
    for i in range(0, 125):
    	a = int(i % 5)
    	b = int(math.floor((i - math.floor(i / 25)*25)/5))
    	c = int(math.floor(i/25))
    	#mask(i+1,:) = [seq(c),seq(b),seq(a)]
        mask[i,0] = seq[c]
        mask[i,1] = seq[b]
        mask[i,2] = seq[a]
    #print(imageWithROI)
    width = imageWithROI.shape[0]
    height = imageWithROI.shape[1]
    depth = imageWithROI.shape[2]
    
    #print('w {} h {} d {}'.format(width, height, depth))
    map=np.zeros([width,height,depth])
    nNodes=0
    for i in range(1,width+1):
        for j in range(1, height+1):
            for k in range(1,depth+1):
                if (~np.isnan(imageWithROI[i-1,j-1,k-1]) and (not imageWithROI[i-1,j-1,k-1]==0)):
                    nNodes=nNodes+1
                    map[i-1,j-1,k-1]=nNodes
	
	valueNearby = ConstructNeighbor(imageWithROI,map)
    #print(valueNearby)
	
    graphWithROIs=np.zeros([nNodes,nNodes])
    for i in range(1,width+1):
        for j in range(1,height+1):
            for k in range(1,depth+1):
                if (not map[i-1,j-1,k-1]==0):
                    node0=map[i-1,j-1,k-1]
                    value0=valueNearby[i-1,j-1,k-1]
                    for ii in range(1,width+1):
                        for jj in range(1,height+1):
                            for kk in range(1,depth+1):
                                if (map[ii-1,jj-1,kk-1]>node0):
                                    node1=map[ii-1,jj-1,kk-1]
                                    value1=valueNearby[ii-1,jj-1,kk-1]
                                    #print('v0 {} v1 {}'.format(value0, value1))
                                    correlation = ComputeNormalizedCorrelation(value0,value1)
                                    #print('graphwithrois size'.format(graphWithROIs.shape))
                                    #int16->int >>> TODO check loss here
                                    graphWithROIs[int(node0-1),int(node1-1)]= correlation  
                                    graphWithROIs[int(node1-1),int(node0-1)] = correlation 


    return graphWithROIs

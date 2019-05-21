import numpy as np
import math

def ConstructNeighbor(imageWithROI, map):
    box_len = 3
    seq = [-1,0,1]
    
    mask = np.zeros((int(math.pow(box_len, 3)),3))
    for i in range(0, int(math.pow(box_len, 3))):
        a = i % box_len
        b = math.floor((i - math.floor(i / (math.pow(box_len, 2)))*(math.pow(box_len, 2)))/box_len)
        c = math.floor(i/(math.pow(box_len,2)))
        mask[i,0] = seq[int(c)]
        mask[i,1] = seq[int(b)]
        mask[i,2] = seq[int(a)]
    #print('mask shape {}'.format(mask.shape))
    width=imageWithROI.shape[0]
    height=imageWithROI.shape[1]
    depth=imageWithROI.shape[2]
    #print('w {} h {} d {} imageroi {}'.format(width, height, depth, imageWithROI.shape))
    valueNearby = np.empty([width, height, depth], dtype=object)

    for i in range(0,width):
        for j in range(0,height):
            for k in range(0,depth):
                #print('i {} j{} k {} imagewithroi'.format(i, j, k))
                if (~np.isnan(imageWithROI[i,j,k]) and (imageWithROI[i,j,k]!=0)):
                    cur_idx = map[i,j,k]
                    tmp = np.full([int(math.pow(box_len, 3)), 1], np.nan)
                    #print('mask .shape {}'.format(mask.shape[0]))
                    for nb_idx in range(0, mask.shape[0]):
                        #print('mask {}'.format(mask.shape))
                        ii = i+(mask[nb_idx,0])
                        jj = j+(mask[nb_idx,1])
                        kk = k+(mask[nb_idx,2])
                        #print('ii {} jj {} kk {}'.format(ii, jj, kk))
                        if (~(ii>=0 and ii<width and jj>=0 and jj<height and kk>=0 and kk<depth)):
                            continue
                        #print('tmp {} nbidx{} imagewithroi{}'.format(tmp.shape, nb_idx, imageWithROI.shape))
                        
                        tmp[nb_idx] = imageWithROI[int(ii),int(jj),int(kk)]
                    valueNearby[i,j,k] = tmp

    return valueNearby
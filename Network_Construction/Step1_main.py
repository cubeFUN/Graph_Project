import scipy.io as sio
import numpy as np
from ROI2graphCorrelation import ROI2graphCorrelation

if __name__ == '__main__':
    # read dataset from rootPath
    mat_contents = sio.loadmat('./lung data_latest version/radiogenomics_PET.mat')

    #print(mat_contents)
    nameArray = mat_contents['dataset'][0][0][0]
    #print(nameArray)
    imageSUV = mat_contents['dataset'][0][0][1]
    #print(imageSUV)
    #nFiles = len(imageSUV)
    nFiles = 10
    imageWithROIs = np.empty([nFiles, 1], dtype=object)
    graphWithROIs = np.empty([nFiles, 1], dtype=object)
    name_array = np.empty([nFiles, 1], dtype=object)
    #print(name_array)
    SUVpara = np.zeros([nFiles, 1])
    nPetROIs = 0

    for k in range(0, nFiles):
        image = imageSUV[k, 0]
        #print(image)
        cur_size = imageSUV[k, 1]
        #node_size(nPetROIs,1) = cur_size
        
        #print(nameArray[k])
        #print(name_array[nPetROIs])
        print('k {}'.format(k))
        name_array[nPetROIs] = np.asarray(nameArray[k])
        
        #print('current size is {}'.format(cur_size))
        imageWithROIs[nPetROIs,0] = np.asarray(image)
        graphWithROIs[nPetROIs,0] = ROI2graphCorrelation(np.asarray(image))
        #print('{}/{} done\n'.format(nPetROIs, nFiles))
        nPetROIs += 1
    
    #print('graph rois {} suv {}'.format(graphWithROIs, SUVpara))
    sio.savemat('imageWithROIs_p.mat', {'dataset':{'imageWithROIs': imageWithROIs}})
    sio.savemat('graphWithROIs_p.mat', {'dataset':{'graphWithROIs': graphWithROIs}})
    sio.savemat('SUVpara_p.mat', {'dataset':{'SUVpara': SUVpara}})

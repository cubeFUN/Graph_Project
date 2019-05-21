import math
import numpy as np
import pandas as pd
def ComputeNormalizedCorrelation(value0,value1):
    #print('value0 {}'.format(value0))
    #print('value1 {}'.format(value1))
    valid = ~pd.isnull(value0) & ~pd.isnull(value1)
    #print('valid {}'.format(valid))
    value0 = value0[valid]
    value1 = value1[valid]
    mean0 = value0.mean(axis=0)
    mean1 = value1.mean(axis=0)
    std0 = value0.std(axis=0)
    std1 = value1.std(axis=0)

    correlation = sum(np.multiply((value0 - mean0) , (value1 - mean1)))/(std0*std1)
    #print('sum {}'.format(sum(np.multiply((value0 - mean0) , (value1 - mean1)))))
    #print('value0 {} value1{}'.format(value0, value1))
    #print('std0 {} std1 {}'.format(std0, std1))
    #print('correlation {}'.format(correlation))
    
    return correlation
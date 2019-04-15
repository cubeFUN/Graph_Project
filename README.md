# Readme

4.13.2019 zhiling zhou 



## Network_Construction

### Step1_main.m

根据佳楠学姐整理的数据(lung data_latest version)构造无向有权的graph。生成imageWithROIs，SUVpara和graphWithROIs三个文件。最后一个是每个病人肿瘤的邻接矩阵，用于在step2里面提取特征。



### Step2_Computer_Features

根据邻接矩阵提取特征。需要下载[这个函数包](<http://strategic.mit.edu/downloads.php?page=matlab_networks>)。很多特征是基于这个文档提取的。计算速度根据肿瘤的大小差异会很大（注释掉的那些特征要算很久，12h+）。



## ANN_Classifier

里面提供了一个两层的神经网络的分类器，分成二分类和多分类两种。输入是之前提取出的特征，输出是分类结果。

XGBoost主要用于研究不同的特征对于分类结果的贡献大小，参数还没调得很好，如果要用的话需要继续调教。

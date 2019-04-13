"""

Do classifiction with three kind of features regardless of size of each case.

Output includes: ACCuracy, SENsitivity, SPEcificity, AUC

Python 3.6

Author: Zhiling Zhou

Date: 10th Sep, 2018

"""

import numpy as np
import pylab as pl

from array import array
import matplotlib.pyplot as plt
from imblearn.over_sampling import RandomOverSampler
from IPython import display
from keras.utils import np_utils
from keras.models import Sequential
from keras.layers import Dense, Activation, Dropout
from keras import callbacks
from keras.optimizers import RMSprop, SGD, Adadelta
from sklearn.model_selection import StratifiedKFold
from sklearn.metrics import confusion_matrix
from sklearn.metrics import roc_curve
from sklearn.metrics import auc
from scipy import io
from sklearn import metrics

root = './data'
label_name = 'label_3.txt'
feature_name = 'features.txt'

# set IF_SMOTE to 1 to do SMOTE to training and testing data respectively
IF_SMOTE = 1

feature_path = root+'/'+feature_name
label_path = root+'/'+label_name

featuresALL = np.loadtxt(feature_path)
labelALL = np.loadtxt(label_path)
label_num = labelALL.shape[1]

acc_mean = np.zeros((1, label_num))

for tt_label in [0]:#np.arange(label_num):

    label = labelALL[:, tt_label]
    features = featuresALL[~np.isnan(label), :]
    label = label[~np.isnan(label)]
    label = label[np.sum(np.isnan(features), axis=1) == 0]
    features = features[np.sum(np.isnan(features), axis=1) == 0, :]

    epoch_num = 2000
    labelNum = len(set(label))
    featureNum = features.shape[1]
    caseNum = features.shape[0]

    model = Sequential([
        Dense(64, input_dim=featureNum),
        Activation('relu'),
        Dropout(0.2),
        Dense(32),
        Activation('relu'),
        Dropout(0.2),
        Dense(8),
        Activation('relu'),
        Dropout(0.2),
        Dense(labelNum),
        Activation('softmax'),
    ])

    # optim = SGD(lr=1e-2, momentum=0.0, decay=1e-8, nesterov=False) #RMSprop(lr=1e-4, rho=0.9, decay=1e-6)
    optim = Adadelta(lr=1, epsilon=None, decay=0.0)

    # define holder of results
    split_num = 5
    count = 0
    accuracy = np.zeros(split_num)
    loss = np.zeros(split_num)
    aauc = np.zeros(split_num)
    skf = StratifiedKFold(n_splits=5, random_state=0, shuffle=True)
    for train_pick, test_pick in skf.split(features, label):
        X_all = features
        X_test = features[test_pick, :]
        X_train = features[train_pick, :]

        y_all = label
        y_test = label[test_pick]
        y_train = label[train_pick]

        if IF_SMOTE:
            ros = RandomOverSampler(random_state=0)
            X_train, y_train = ros.fit_sample(X_train, y_train)
            X_test, y_test = ros.fit_sample(X_test, y_test)

        # data pre-processing
        y_train = np_utils.to_categorical(y_train, num_classes=labelNum)
        y_test = np_utils.to_categorical(y_test, num_classes=labelNum)
        y_all = np_utils.to_categorical(y_all, num_classes=labelNum)

        # We add metrics to get more results you want to see
        model.compile(optimizer=optim,
                      loss='binary_crossentropy',
                      metrics=['accuracy'])

        print('Training ------------')
        # Another way to train the model
        train_size = len(X_train)
        model.fit(X_train, y_train,
                  epochs=epoch_num,
                  validation_split=0.2,
                  batch_size=train_size)

        print('\nTesting ------------')
        # Evaluate the model with the metrics we defined earlier

        loss[count], accuracy[count] = model.evaluate(X_test, y_test)

        print('test loss: ', loss[count])
        print('test accuracy: ', accuracy[count])
        count = count + 1
    acc_mean[0, tt_label] = accuracy.mean()

for tt_label in np.arange(label_num):
    print('Label ' + str(tt_label) + ': ' + str(split_num)+' fold accuracy is \t\t' + str(acc_mean[0, tt_label]))

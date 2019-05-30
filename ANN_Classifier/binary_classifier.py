"""

Do classifiction on binary labels.

Output includes: ACCuracy, SENsitivity, SPEcificity, AUC

Python 3.6

Author: Zhiling Zhou

Date: 15th Nov, 2018

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
label_name = 'label_c_v1.txt'
feature_name = 'feature_v4_recurrence.txt'

# set IF_SMOTE to 1 to do SMOTE to training and testing data respectively
IF_SMOTE = 1

feature_path = root+'/'+feature_name
label_path = root+'/'+label_name

featuresALL = np.loadtxt(feature_path)
labelALL = np.loadtxt(label_path)
label_num = 1#labelALL.shape[1]

acc_mean = np.zeros((1, label_num))
spe_mean = np.zeros((1, label_num))
sen_mean = np.zeros((1, label_num))
auc_mean = np.zeros((1, label_num))

for tt_label in [0, 0]:#np.arange(label_num):
    label = labelALL#[:, tt_label]
    features = featuresALL[~np.isnan(label), :]
    label = label[~np.isnan(label)]
    label = label[np.sum(np.isnan(features), axis=1) == 0]
    features = features[np.sum(np.isnan(features), axis=1) == 0, :]

    epoch_num = 1500
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

    # two optimizers
    #optim = SGD(lr=1e-2, momentum=0.0, decay=1e-8, nesterov=False) #RMSprop(lr=1e-4, rho=0.9, decay=1e-6)
    optim = Adadelta(lr=1, epsilon=None, decay=1e-06)  # 1e-2

    # define holder of results
    split_num = 5
    count = 0
    accuracy = np.zeros(split_num)
    loss = np.zeros(split_num)
    sen = np.zeros(split_num)
    spe = np.zeros(split_num)
    auc = np.zeros(split_num)

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

        predictions = model.predict(X_test)
        predictions = np.argmax(predictions, axis=-1)
        yy_test = np.argmax(y_test, axis=-1)
        fpr_keras, tpr_keras, thresholds_keras = roc_curve(yy_test, predictions)
        auc[count] = metrics.auc(fpr_keras, tpr_keras)
        y_test = np.argmax(y_test, axis=-1)

        c = confusion_matrix(y_test, predictions)
        if sum(y_test) == 0 or sum(y_test) == y_test.shape[0]:
            sen[count] = float('nan')
            spe[count] = float('nan')
        else:
            sen[count] = c[0, 0] / (c[0, 1] + c[0, 0])
            spe[count] = c[1, 1] / (c[1, 1] + c[1, 0])
        print('sensitivity', sen[count])
        print('specificity', spe[count])

        count = count + 1

    acc_mean[0, tt_label] = accuracy.mean()
    spe_mean[0, tt_label] = sen[~np.isnan(sen)].mean()
    sen_mean[0, tt_label] = spe[~np.isnan(spe)].mean()
    auc_mean[0, tt_label] = auc.mean()

for tt_label in np.arange(label_num):
    print('Label' + str(tt_label) + ': ' + str(split_num)+' fold accuracy is \t\t' + str(acc_mean[0, tt_label]))
    print('Label' + str(tt_label) + ': ' + str(split_num)+' fold specificity is \t' + str(spe_mean[0, tt_label]))
    print('Label' + str(tt_label) + ': ' + str(split_num)+' fold sensitivity is \t' + str(sen_mean[0, tt_label]))
    print('Label' + str(tt_label) + ': ' + str(split_num)+' fold auc is \t\t\t' + str(auc_mean[0, tt_label]))

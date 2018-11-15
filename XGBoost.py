import numpy as np
import os
import xgboost as xgb
from sklearn.model_selection import StratifiedKFold
from imblearn.over_sampling import RandomOverSampler
from sklearn.metrics import accuracy_score, confusion_matrix, roc_auc_score
import matplotlib.pyplot as plt
from keras.utils import np_utils

root = './data'
label_name = 'label_2.txt'
feature_name = 'features.txt'

# set IF_SMOTE to 1 to do SMOTE to training and testing data respectively
IF_SMOTE = 1

feature_path = root+'/'+feature_name
label_path = root+'/'+label_name

featureALL = np.loadtxt(feature_path)
labelALL = np.loadtxt(label_path)
label_num = labelALL.shape[1]

tt_label = 0
total_acc = 0
n_splits = 5
accuracy_test = np.zeros((label_num, n_splits))
accuracy_train = np.zeros((label_num, n_splits))
spe_test = np.zeros((label_num, n_splits))
sen_test = np.zeros((label_num, n_splits))
auc_test = np.zeros((label_num, n_splits))

for tt_label in np.arange(label_num):
    label = labelALL[:, tt_label]
    features = featureALL[~np.isnan(label), :]
    label = label[~np.isnan(label)]
    label = label[np.sum(np.isnan(features), axis=1) == 0]
    features = features[np.sum(np.isnan(features), axis=1) == 0, :]

    # features = features[:, chosen]
    labelNum = len(set(label))
    caseNum = features.shape[0]
    count = 0

    skf = StratifiedKFold(n_splits=n_splits, random_state=0, shuffle=True)
    for train_pick, test_pick in skf.split(features, label):
        X_all = features
        X_test = features[test_pick, :]
        X_train = features[train_pick, :]

        y_all = label
        y_test = label[test_pick]
        y_train = label[train_pick]

        # y_train = np_utils.to_categorical(y_train, num_classes=labelNum)
        # y_test = np_utils.to_categorical(y_test, num_classes=labelNum)
        # y_all = np_utils.to_categorical(y_all, num_classes=labelNum)

        if IF_SMOTE:
            ros = RandomOverSampler(random_state=0)
            X_train, y_train = ros.fit_sample(X_train, y_train)
            X_test, y_test = ros.fit_sample(X_test, y_test)

        predict_result = np.arange(y_test.shape[0])

        param = {'learning_rate':       0.1,
                 'scale_pos_weight':    20,
                 'n_estimators':        500,
                 'max_depth':           5,
                 'min_child_weight':    1,
                 'subsample':           0.6,
                 'colsample_bytree':    0.6,
                 'gamma':               4,
                 'reg_alpha':           2,
                 'reg_lambda':          2,
                 'silent':              1,
                 'objective':           'multi:softmax',
                 'num_class':           labelNum,
                 'eval_metric':         'logloss'}

        clf = xgb.XGBModel(**param)

        clf.fit(X_train, y_train, verbose=True)
        pred = clf.predict(X_test)
        # evaluate predictions
        accuracy_test[tt_label, count] = accuracy_score(y_test, pred)
        c = confusion_matrix(y_test, pred)
        sen_test[tt_label, count] = c[0, 0] / (c[0, 1] + c[0, 0])
        spe_test[tt_label, count] = c[1, 1] / (c[1, 1] + c[1, 0])
        auc_test[tt_label, count] = roc_auc_score(y_test, pred)

        pred_train = clf.predict(X_train)
        accuracy_train[tt_label, count] = accuracy_score(y_train, pred_train)
        count = count + 1
        print('Label ', tt_label, ' - ', count, ' fold: done!')

acc_mean_test = np.mean(accuracy_test, axis=1)
acc_mean_train = np.mean(accuracy_train, axis=1)

spe_mean = np.mean(spe_test, axis=1)
sen_mean = np.mean(sen_test, axis=1)
auc_mean = np.mean(auc_test, axis=1)

print('train acc:', acc_mean_train)
print('test acc:', acc_mean_test)
print('sen:', sen_mean)
print('spe:', spe_mean)
print('AUC:', auc_mean)



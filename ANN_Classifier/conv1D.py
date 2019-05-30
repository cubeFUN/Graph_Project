import numpy as np
import pandas as pd
from sklearn.preprocessing import LabelEncoder
from sklearn.preprocessing import StandardScaler
from sklearn.model_selection import StratifiedShuffleSplit
from keras.models import Sequential
from keras.layers import Dense, Activation, Flatten, Convolution1D, Dropout
from keras.optimizers import SGD
from keras.utils import np_utils
from sklearn.metrics import accuracy_score, confusion_matrix, roc_auc_score

root = './data'
label_name = 'label_c_v1.txt'
feature_name = 'testconv1.txt'

# set IF_SMOTE to 1 to do SMOTE to training and testing data respectively
IF_SMOTE = 1

feature_path = root+'/'+feature_name
label_path = root+'/'+label_name

featuresALL = np.loadtxt(feature_path)
labelALL = np.loadtxt(label_path)
label_num = 1#labelALL.shape[1]

'''
def encode(train, test):
    label_encoder = LabelEncoder().fit(train.species)
    labels = label_encoder.transform(train.species)
    classes = list(label_encoder.classes_)

    train = train.drop(['species', 'id'], axis=1)
    test = test.drop('id', axis=1)

    return train, labels, test, classes
'''

train = featuresALL
test = featuresALL
label = labelALL
classes = list([0,1])
#train, labels, test, classes = encode(train, test)
# standardize train features
#scaler = StandardScaler().fit(train.values)
#scaled_train = scaler.transform(train.values)

# split train data into train and validation
sss = StratifiedShuffleSplit(test_size=0.1, random_state=23)
for train_index, valid_index in sss.split(train, label):
    X_train, X_valid = train[train_index], train[valid_index]
    y_train, y_valid = label[train_index], label[valid_index]
    

nb_features = 27 # number of features per features type (shape, texture, margin)   
nb_class = len(classes)

# reshape train data
X_train_r = np.zeros((len(X_train), nb_features, 3))
X_train_r[:, :, 0] = X_train[:, :nb_features]
X_train_r[:, :, 1] = X_train[:, nb_features:54]
X_train_r[:, :, 2] = X_train[:, 54:]

# reshape validation data
X_valid_r = np.zeros((len(X_valid), nb_features, 3))
X_valid_r[:, :, 0] = X_valid[:, :nb_features]
X_valid_r[:, :, 1] = X_valid[:, nb_features:54]
X_valid_r[:, :, 2] = X_valid[:, 54:]


# Keras model with one Convolution1D layer
# unfortunately more number of covnolutional layers, filters and filters lenght 
# don't give better accuracy
model = Sequential()
model.add(Convolution1D(nb_filter=128, filter_length=1, input_shape=(nb_features, 3)))
model.add(Activation('relu'))
model.add(Flatten())
model.add(Dropout(0.2))
model.add(Dense(512, activation='relu'))
model.add(Dense(256, activation='relu'))
model.add(Dense(nb_class))
model.add(Activation('softmax'))


y_train = np_utils.to_categorical(y_train, nb_class)
y_valid = np_utils.to_categorical(y_valid, nb_class)

sgd = SGD(lr=0.1, nesterov=True, decay=1e-6, momentum=0.9)
model.compile(loss='categorical_crossentropy',optimizer=sgd,metrics=['accuracy'])

nb_epoch = 200
model.fit(X_train_r, y_train, nb_epoch=nb_epoch, validation_data=(X_valid_r, y_valid), batch_size=16)

# reshape train data
X_test_r = np.zeros((len(featuresALL), nb_features, 3))
X_test_r[:, :, 0] = featuresALL[:, :nb_features]
X_test_r[:, :, 1] = featuresALL[:, nb_features:54]
X_test_r[:, :, 2] = featuresALL[:, 54:]


#score = model.evaluate(x_test, y_test, batch_size=16)
#print('>>> score {}'.format(score))

y_pred = model.predict_classes(X_test_r)
for i in range(len(X_test_r)):
	print("X=%s, Predicted=%s" % (labelALL[i], y_pred[i]))
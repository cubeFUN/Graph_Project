# https://medium.com/@hjhuney/implementing-a-random-forest-classification-model-in-python-583891c99652
from sklearn.model_selection import train_test_split
from sklearn import model_selection
from sklearn.model_selection import cross_val_score
from sklearn.metrics import classification_report, confusion_matrix
from sklearn.ensemble import RandomForestClassifier
import numpy as np
from sklearn.model_selection import RandomizedSearchCV

root = './data'
label_name = 'label_c_v1.txt'
feature_name = 'features_r_PET_v1nobig.txt'

feature_path = root+'/'+feature_name
label_path = root+'/'+label_name

featuresALL = np.loadtxt(feature_path)
labelALL = np.loadtxt(label_path)
label_num = 1#labelALL.shape[1]

label = labelALL#[:, tt_label]
features = featuresALL[~np.isnan(label), :]
label = label[~np.isnan(label)]
label = label[np.sum(np.isnan(features), axis=1) == 0]
features = features[np.sum(np.isnan(features), axis=1) == 0, :]

X = features
y = label
# implementing train-test-split
X_train, X_test, y_train, y_test = train_test_split(X, y, test_size=0.3, random_state=100)

#create the random forest model

# random forest model creation
rfc = RandomForestClassifier()
print('>>> X_train {}'.format(X_train.shape))
print('>>> y_train {}'.format(y_train.shape))
rfc.fit(X_train,y_train)
# predictions
rfc_predict = rfc.predict(X_test)

#evaluating the performance

rfc_cv_score = cross_val_score(rfc, X, y, cv=10, scoring='roc_auc')

#print out the results
print("=== Confusion Matrix ===")
print(confusion_matrix(y_test, rfc_predict))
print('\n')
print("=== Classification Report ===")
print(classification_report(y_test, rfc_predict))
print('\n')
print("=== All AUC Scores ===")
print(rfc_cv_score)
print('\n')
print("=== Mean AUC Score ===")
print("Mean AUC Score - Random Forest: ", rfc_cv_score.mean())
'''
# number of trees in random forest
n_estimators = [int(x) for x in np.linspace(start = 200, stop = 2000, num = 10)]
# number of features at every split
max_features = ['auto', 'sqrt']

# max depth
max_depth = [int(x) for x in np.linspace(100, 500, num = 11)]
max_depth.append(None)
# create random grid
random_grid = {
 'n_estimators': n_estimators,
 'max_features': max_features,
 'max_depth': max_depth
 }
# Random search of parameters
rfc_random = RandomizedSearchCV(estimator = rfc, param_distributions = random_grid, n_iter = 100, cv = 3, verbose=2, random_state=42, n_jobs = -1)
# Fit the model
rfc_random.fit(X_train, y_train)
# print results
print(rfc_random.best_params_)
'''
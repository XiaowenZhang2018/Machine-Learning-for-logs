import numpy as np
import matplotlib.pyplot as plt
from sklearn.metrics.regression import r2_score, mean_squared_error
from sklearn.model_selection import train_test_split
from keras.models import Sequential
from keras.layers import Dense, Activation, Flatten, Conv1D, MaxPooling1D, Dropout
import os
import scipy.io as sio
import pandas as pd

os.chdir("C:/Users/xz5984/OneDrive/Research/DLL/Laudau207_2L_new")
layer = 3
log = np.zeros([79*2, 1])
for i in [151]:
    filename = 'sim_bed_'+str(i)+'.mat'
    fullData = sio.loadmat(filename)['s_results'][0]
    sampname = list(fullData[0].dtype.names)
    X = []
    Y = []
    for samp in sampname:
        X += [fullData[samp][0][0]['simRes'][0][11:-10, [1, 2]]]
        Y += [[fullData[samp][0]['res_1'][0][0][0][0], fullData[samp][0]['res_2'][0][0][0][0]]]#, fullData[samp][0]['res_3'][0][0][0][0]], fullData[samp][0]['res_4'][0][0][0][0]]
    X = np.atleast_3d(X)
    Y = np.atleast_2d(Y)

    X_train, X_test, Y_train, Y_test = train_test_split(X, Y, test_size=0.05, random_state=42)
    filename_2 = 'field_bed_'+str(i)+'.mat'
    X_field = np.array([sio.loadmat(filename_2)['fieldData'][10:-10, :]])

    n_points = X_train.shape[1]
    n_features = X_train.shape[2]
    n_outputs = Y_train.shape[1]

    count = 0
    R2_train = 0
    while R2_train < 0.9 and count < 5:
        model = Sequential()
        model.add(Conv1D(strides=1, activation="relu", input_shape=(n_points, n_features), filters=3, kernel_size=2))
        model.add(MaxPooling1D(pool_size=2))
        model.add(Flatten())
        model.add(Dense(n_outputs, activation='relu'))
        model.compile(loss='mean_squared_error', optimizer='adam', metrics=['accuracy'])
        history = model.fit(X_train, Y_train, epochs=1024, batch_size=4, verbose=0)

        # Test
        Y_pred = model.predict(X_test)
        Y_imp = model.predict(X_field)

        # Evaluation
        R2_train = r2_score(Y_train, model.predict(X_train))
        R2_test = r2_score(Y_test, Y_pred)
        RMSD = np.sqrt(mean_squared_error(Y_test, Y_pred))
        print('File: {0}, R2_train:{1:.4f}, R2_test:{2:.4f}, RMSD: {3:.4f}'.format(filename, R2_train, R2_test, RMSD))
        log[i-1:i+1] = Y_imp[0].reshape(-1, 1)
        count = count+1

dataframe = pd.DataFrame({'Rem': log.flatten().tolist()})
dataframe.to_csv("Rem_Laudau207_0011.csv", sep=',')


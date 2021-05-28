# -*- coding: utf-8 -*-

from __future__ import division
from __future__ import print_function

import os
import sys
import time

# temporary solution for relative imports in case pyod is not installed
sys.path.append(
    os.path.abspath(os.path.join(os.path.dirname("__file__"), '..')))

from pyod.models.so_gaal import SO_GAAL
from pyod.utils.data import evaluate_print
from numpy import *
from filter import *

if __name__ == "__main__":

    # input training data
    file = open('data_train.txt')  # training data
    lines = file.readlines()
    n_train = len(lines)

    X_train = zeros((n_train, 2), dtype=int)  # Number of training samples
    X_train_process = []
    X_train_queuing = []
    Y_train = []

    for i in range(n_train):
        line = lines[i].strip('\n').split(', ')
        X_train_process.append(int(line[0]))
        X_train_queuing.append(int(line[1]))
        X_train[i][0] = int(line[0])
        X_train[i][1] = int(line[1])

    file = open('gt_train.txt')  # training groundtruth
    lines = file.readlines()
    for i in range(len(lines)):
        line = lines[i].strip('\n')
        Y_train.append(int(line))

    # input test data
    file = open('data_test.txt')  # test data
    lines = file.readlines()
    n_test = len(lines)

    X_test = zeros((n_test, 2), dtype=int)  # Number of training samples
    X_test_process = []
    X_test_queuing = []
    Y_test = []

    for i in range(len(lines)):
        line = lines[i].strip('\n').split(', ')
        X_test_process.append(int(line[0]))
        X_test_queuing.append(int(line[1]))
        X_test[i][0] = int(line[0])
        X_test[i][1] = int(line[1])

    file = open('gt_test.txt')  # test groundtruth
    lines = file.readlines()
    for i in range(len(lines)):
        line = lines[i].strip('\n')
        Y_test.append(int(line))

    # low pass filtering
    LPF(X_train_process)
    LPF(X_train_queuing)
    LPF(X_test_process)
    LPF(X_test_queuing)

    t1 = int(round(time.time() * 1000))

    # train SO_GAAL detector
    contamination = 0.1  # Outlier ratio
    # stop_epochs = 1000  # training stop epoch
    clf_name = 'SO_GAAL'
    clf = SO_GAAL(contamination=contamination)
    clf.fit(X_train)

    y_train_pred = clf.labels_  # the prediction labels
    y_train_scores = clf.decision_scores_  # outlier scores of the training data

    t2 = int(round(time.time() * 1000))

    y_test_pred = clf.predict(X_test)  # get the prediction on the test data
    y_test_scores = clf.decision_function(X_test)  # outlier scores of the test data

    t3 = int(round(time.time() * 1000))
    print(t2 - t1)
    print(t3 - t2)

    # evaluate and print the results
    print("\nOn Training Data:")
    evaluate_print(clf_name, Y_train, y_train_scores)
    print("\nOn Test Data:")
    evaluate_print(clf_name, Y_test, y_test_scores)

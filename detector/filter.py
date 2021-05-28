# -*- coding: utf-8 -*-
# !/usr/bin/python
from scipy.signal import butter, lfilter
from numpy import *


class LPF:
    def __init__(self, datalist):
        self.datalist = datalist
        self.run()

    def run(self):
        x = self.datalist
        order = 2
        fs = 200000.0  # sample rate, Hz
        cutoff = 5000  # desired cutoff frequency of the filter, Hz
        self.butter_lowpass_filter(x, cutoff, fs, order)  # Filtered data

    def butter_lowpass_filter(self, data, cutoff, fs, order):
        b, a = self.butter_lowpass(cutoff, fs, order=order)
        y = lfilter(b, a, data)
        return y  # Filter requirements.

    def butter_lowpass(self, cutoff, fs, order):
        nyq = 0.5 * fs
        normal_cutoff = cutoff / nyq
        b, a = butter(order, normal_cutoff, btype='low', analog=False)
        return b, a


if __name__ == "__main__":
    pass

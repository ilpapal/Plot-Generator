% Simple program to calculate Mean Relative Error

input_data = readtable("data/misc.txt");

% Get variables from log file
data_ref = table2array(input_data(:, 1));
data_fxp = table2array(input_data(:, 2));

% Calculate error of double and fixed point datatype
error = (data_ref - data_fxp)./(data_ref).*100;

% Skip error calculation when denominator is zero
error(data_ref == 0) = [];

% When both values are zero, error is zero
error(data_ref == 0 & data_fxp == 0) = 0;

% We only need absolute error value
error = abs(error);

% Print mean value of error
disp("Error mean value: " + mean(error) + " %");

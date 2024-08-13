function data_set = split_spr_data(data)
%% Divide the data into time_stamp and measurement
time_stamp = data(:, 1);
measurements = data(:, 2);

%% Find index of the peak value of SPR sensorgram
[~, idx] = max(measurements);

%% Divide the data into two dataset
data_set1 = [time_stamp(1:idx), measurements(1:idx)];
data_set2 = [time_stamp(idx:end)-time_stamp(idx), measurements(idx:end)];

%% Output
data_set = {data_set1, data_set2};
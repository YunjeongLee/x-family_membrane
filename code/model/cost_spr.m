function J = cost_spr(data, fun, params, theta)
%% Data
time_stamp = data(:,1);
measurements = data(:,2);

%% Update params
isEstimated = cell2mat(params(:,3));
assert(sum(isEstimated) == length(theta));
params(isEstimated, 2) = num2cell(theta);

%% Change params to structure
params_struct = cell2struct(params(:, 2), params(:, 1));

%% Calculate Rt
Rt = fun(time_stamp, params_struct);

%% Cost
J = sum( (Rt - measurements).^2, "all" );
end
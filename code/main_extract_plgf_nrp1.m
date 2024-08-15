clear; close all; clc;

%% Add path
% Initialize path
restoredefaultpath;

% Add paths
addpath ../data model/ estimate/ etc/

%% Load SPR sensorgram data
% PlGF concentration used in SPR (nM)
plgf_conc = [300, 100, 30, 10];

% Load data
for i = 1:length(plgf_conc)
    filename = 'spr_plgf_nrp1.xlsx';
    sheetname = sprintf('%d nM', plgf_conc(i));
    cmd_string = sprintf("data_%d = readmatrix('%s', 'NumHeaderLines', 1, 'Sheet', '%s');", plgf_conc(i), filename, sheetname);
    eval(cmd_string);
end

%% Main loop
koff_est = zeros(length(plgf_conc), 1);
kon_est = zeros(length(plgf_conc), 1);
Rmax_est = zeros(length(plgf_conc), 1);

for i = 1:length(plgf_conc)
    % Divide the data into two pieces for `kon` and `koff`
    cmd_string = sprintf('data_set = split_spr_data(data_%d);', plgf_conc(i));
    eval(cmd_string);
    
    %% Dissociation phase
    % Define params
    params = {'R0', data_set{1}(end, 2), false; ...
              'koff', 1e-3, true};

    % Define initial theta
    theta0 = 1e-3;

    % Define dissociation function
    diss_fun = @diss_func;

    % Estimate koff
    [koff_est(i), ~, ~] = minimizer(data_set{2}, @(data, params, theta) cost_spr(data, diss_fun, params, theta), params, theta0);

    %% Association phase
    % Define params
    params = {'conc', plgf_conc(i)*1e-9, false; ...
              'koff', koff_est(i), false; ...
              'Rmax', 120, false; ...
              'kon', 1e4, true};

    % Define initial theta
    theta0 = 1e4;

    % Define association function
    assoc_fun = @assoc_func;

    % Estimate kon
    [kon_est(i), ~, ~] = minimizer(data_set{1}, @(data, params, theta) cost_spr(data, assoc_fun, params, theta), params, theta0);
    
    % Update params
    params_update = params;
    isEstimated = cell2mat(params(:, 3));
    params_update(isEstimated, 2) = num2cell(kon_est(i));
    params_update = cell2struct(params_update(:, 2), params_update(:, 1));
    params_update.R0 = data_set{1}(end, 2);

    % Plot figure
    figure('Position', [10 10 1200 500]);
    subplot(1, 2, 1);
    hold on;
    plot(data_set{1}(:, 1), assoc_fun(data_set{1}(:, 1), params_update), 'linewidth', 3);
    plot(data_set{1}(:, 1), data_set{1}(:, 2), '.', 'MarkerSize', 20);
    hold off;
    xlabel('Time (s)');
    ylabel('Response units [RU]');
    title(sprintf('Association phase - [PlGF] = %d nM', plgf_conc(i)));
    set(gca, 'fontsize', 15)

    subplot(1, 2, 2);
    hold on;
    plot(data_set{2}(:, 1), diss_func(data_set{2}(:, 1), params_update), 'linewidth', 3);
    plot(data_set{2}(:, 1), data_set{2}(:, 2), '.', 'MarkerSize', 20);
    hold off;
    xlabel('Time (s)');
    ylabel('Response units [RU]');
    title(sprintf('Dissociation phase - [PlGF] = %d nM', plgf_conc(i)));
    set(gca, 'fontsize', 15)

end

kon = mean(kon_est)
koff = mean(koff_est)
Kd = koff/kon * 1e9

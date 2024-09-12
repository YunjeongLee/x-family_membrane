clear; close all; clc;

%% Add path
% Initialize path
restoredefaultpath;

% Add paths
addpath ../data model/ etc/ visualize/

%% Generate results folder
result_foldername = 'results/no_PlGF/default';
if ~exist(result_foldername, 'dir')
    mkdir(result_foldername);
end

%% Load parameters
params_raw = readtable("parameters.csv");

% Drop Interpretation and Reference columns
params_raw.Interpretation = [];
params_raw.Reference = [];

%% Treat all ligands at once
% Change unit of parameters that is different from M
params_struct = change_unit(params_raw);

%% Add the number of state to params
params_struct.num_state = 30;
params_struct.species_names = params_raw{1:params_struct.num_state, 'Parameter'};

%% Solve the ODE system
% Define timeline
time_stamp = 0:3600*24*10;

result_all_lig = solve_lig_rec(time_stamp, params_struct);

%% Visualization
visualize_dynamics(time_stamp, result_all_lig, result_foldername)
visualize_lig_prop(result_all_lig, result_foldername)
visualize_rec_prop(result_all_lig, result_foldername)

%% Treat one ligand at once
lig = {'VA', 'VB', 'Pl', 'PDAA', 'PADB', 'PDBB'};
result_lig = cell(length(lig), 1);
for i = 1:length(lig)
    % Generate results folder
    result_foldername = 'results/each_ligand';
    if ~exist(result_foldername, 'dir')
        mkdir(result_foldername);
    end

    % Update params
    params_temp = params_raw;
    params_temp{1:length(lig), 'value'} = 0;
    params_temp{i, 'value'} = params_raw{i, 'value'};
    params_struct = change_unit(params_temp);

    % Add the number of state to params
    params_struct.num_state = 30;
    params_struct.species_names = params_raw{1:params_struct.num_state, 'Parameter'};
    result_lig{i} = solve_lig_rec(time_stamp, params_struct);

    % Visualization
    visualize_each_ligand(params_struct, time_stamp, result_all_lig, result_lig{i}, result_foldername)
end


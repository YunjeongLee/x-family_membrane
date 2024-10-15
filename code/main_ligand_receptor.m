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
time_stamp = 0:3600*2400;

result_all_lig = solve_lig_rec(time_stamp, params_struct);

%% Visualization
visualize_dynamics(time_stamp, result_all_lig, result_foldername)
visualize_lig_prop(result_all_lig, result_foldername)
visualize_rec_prop(result_all_lig, result_foldername)

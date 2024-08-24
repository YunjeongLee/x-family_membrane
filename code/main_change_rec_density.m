clear; close all; clc;

%% Add path
% Initialize path
restoredefaultpath;

% Add paths
addpath ../data model/ etc/ visualize/

%% Load parameters
params_raw = readtable("parameters.csv");

% Drop Interpretation and Reference columns
params_raw.Interpretation = [];
params_raw.Reference = [];

%% Initial settings
% Define time_stamp
time_stamp = 0:3600:3600*24*10;

% Define receptor names and densities
lig_lgd = {'VEGF-A', 'VEGF-B', 'PlGF', 'PDGF-AA', 'PDGF-AB', 'PDGF-BB'};
rec_lgd = {'VEGFR1', 'VEGFR2', 'NRP1', 'PDGFR\alpha', 'PDGFR\beta'};
rec = {'R1', 'R2', 'N1', 'PDRa', 'PDRb'};
rec_density = 0:10:1e4;

color_free_vs_bound = {'#8ecae6', '#219ebc'};
color_lig_dist = {'#ff595e', '#ff924c', '#ffca3a', '#8ac926', '#1982c4', '#6a4c93'};

%% Main loop
free_vs_bound_lig = cell(length(rec), 1);
free_vs_bound_rec = cell(length(rec), 1);
lig_dist = cell(length(rec), 1);
for i = 1:length(rec)
    for j = 1:length(rec_density)
        % Initialize parameter table
        params_temp = params_raw;

        % Change receptor density
        params_temp{strcmp(params_temp.Parameter, rec{i}), 'value'} = rec_density(j);

        % Change unit
        params_struct = change_unit(params_temp);

        % Add the number of state to params
        params_struct.num_state = 30;
        params_struct.species_names = params_temp{1:params_struct.num_state, 'Parameter'};

        % Solve ODE system
        result = solve_lig_rec(time_stamp, params_struct);

        %% Record free vs bound ligand
        VA = [result.VA_free(end), result.VA_bound(end)];
        VB = [result.VB_free(end), result.VB_bound(end)];
        Pl = [result.Pl_free(end), result.Pl_bound(end)];
        PDAA = [result.PDAA_free(end), result.PDAA_bound(end)];
        PDAB = [result.PDAB_free(end), result.PDAB_bound(end)];
        PDBB = [result.PDBB_free(end), result.PDBB_bound(end)];
        
        % Aggregate all data
        data = cat(3, VA/sum(VA)*100, VB/sum(VB)*100, Pl/sum(Pl)*100, ...
                      PDAA/sum(PDAA)*100, PDAB/sum(PDAB)*100, PDBB/sum(PDBB)*100);
        
        % Record data
        free_vs_bound_lig{i}(j, :, :) = data;

        %% Record free vs. bound rec
        R1 = [result.R1_free(end), result.R1_bound(end)];
        R2 = [result.R2_free(end), result.R2_bound(end)];
        N1 = [result.N1_free(end), result.N1_bound(end)];
        PDRa = [result.PDRa_free(end), result.PDRa_bound(end)];
        PDRb = [result.PDRb_free(end), result.PDRb_bound(end)];

        % Aggregate all data
        data = cat(3, R1/sum(R1)*100, R2/sum(R2)*100, N1/sum(N1)*100, ...
                      PDRa/sum(PDRa)*100, PDRb/sum(PDRb)*100);

        % Record data
        free_vs_bound_rec{i}(j, :, :) = data;

        %% Record ligand distribution
        lig_R1 = [result.VA_R1(end), result.VB_R1(end), result.Pl_R1(end), 0, 0, 0];
        lig_R2 = [result.VA_R2(end) + result.VA_R2_N1(end), 0, 0, result.PDAA_R2(end), result.PDAB_R2(end), result.PDBB_R2(end)];
        lig_N1 = [result.VA_N1(end) + result.VA_R2_N1(end), result.VB_N1(end), result.Pl_N1(end), 0, 0, 0];
        lig_PDRa = [result.VA_PDRa(end), 0, 0, result.PDAA_PDRa(end), result.PDAB_PDRa(end), result.PDBB_PDRa(end)];
        lig_PDRb = [result.VA_PDRb(end), 0, 0, 0, result.PDAB_PDRb(end), result.PDBB_PDRb(end)];

        % Aggregate all data
        data = cat(3, lig_R1/sum(lig_R1) * 100, ...
                      lig_R2/sum(lig_R2) * 100, ...
                      lig_N1/sum(lig_N1) * 100, ...
                      lig_PDRa/sum(lig_PDRa) * 100, ...
                      lig_PDRb/sum(lig_PDRb) * 100);

        % Record data
        lig_dist{i}(j, :, :) = data;
    end
end

%% Visualization
xtick = [0, 1e3:3e3:1e4];
for i = 1:length(rec)
    %% Define the default value of receptors
    default = params_raw{strcmp(params_raw.Parameter, rec{i}), 'value'};

    % If it's NRP1 and you're plotting a small range, then set it as nan
    if i == 3
        default2 = nan;
    else
        default2 = default;
    end

    %% Generate results folder
    result_foldername = sprintf('results/all_ligand/change_rec_density/%s', rec{i});
    if ~exist(result_foldername, 'dir')
        mkdir(result_foldername);
    end

    %% Visualization -- Free vs. bound ligand
    lgd = {'Free', 'Bound', sprintf('Base = %d', default)};
    filename = sprintf('%s/free_vs_bound_lig', result_foldername);
    visualize_stack_area(free_vs_bound_lig{i}, default, rec_density, color_free_vs_bound, ...
                         lig_lgd, xtick, rec_lgd{i}, lgd, filename)

    %% Visualization -- Free vs. bound receptor
    filename = sprintf('%s/free_vs_bound_rec', result_foldername);
    visualize_stack_area(free_vs_bound_rec{i}, default, rec_density, color_free_vs_bound, ...
                         rec_lgd, xtick, rec_lgd{i}, lgd, filename)

    %% Visualization -- Ligand distribution
    filename = sprintf('%s/lig_dist', result_foldername);
    visualize_stack_area(lig_dist{i}, default, rec_density, color_lig_dist, ...
                         rec_lgd, xtick, rec_lgd{i}, [lig_lgd, {sprintf('Base = %d', default)}], filename)
end
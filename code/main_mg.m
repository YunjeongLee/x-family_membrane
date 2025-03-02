clear; close all; clc;

%% Add path
% Initialize path
restoredefaultpath;

% Add paths
addpath ../data/ model/mg etc/

%% Generate results folder
result_foldername = 'results/mg/default';
if ~exist(result_foldername, 'dir')
    mkdir(result_foldername);
end

%% Define params
params_raw = readtable("parameters_mg.csv");
params = change_unit_mg(params_raw);

%% Generate mesh
xrange = 0:5e-3:0.1;
time_stamp = 0:10:3600*24;

%% Solve PDE
m = 0;
options = odeset('AbsTol', 1e-20, 'RelTol',1e-9, 'NonNegative', 1:(length(xrange) * length(time_stamp)));
sol = pdepe(m, @(x, t, u, dudx) pdefun(x, t, u, dudx, params), ...
            @(x) pdeic(x, params), ...
            @(xl, ul, xr, ur, t) pdebc(xl, ul, xr, ur, t, params), ...
            xrange, time_stamp, options);

%% Solution
V = sol(:, :, 1);
P = sol(:, :, 2);
R1 = sol(:, :, 3);
R2 = sol(:, :, 4);
VR1 = sol(:, :, 5);
PR1 = sol(:, :, 6);
VR2 = sol(:, :, 7);

%% Visualization
avogadro = 6.02214e23;
EC_area = 1e-5;

figure('Position', [10 10 1600 1000]);
subplot(2, 2, 1);
surf(xrange,time_stamp/3600, V * 1e9, 'EdgeColor', 'none')
title('VEGF-A', 'fontname', 'Arial')
xlabel('Distance (cm)', 'fontname', 'Arial')
ylabel('Time (hour)', 'fontname', 'Arial')
zlabel('Concentration (nM)', 'fontname', 'Arial')
set(gca, 'fontsize', 17, 'fontname', 'Arial')

subplot(2, 2, 2);
surf(xrange,time_stamp/3600, P * 1e9, 'EdgeColor', 'none')
title('PlGF', 'fontname', 'Arial')
xlabel('Distance (cm)', 'fontname', 'Arial')
ylabel('Time (hour)', 'fontname', 'Arial')
zlabel('Concentration (nM)', 'fontname', 'Arial')
set(gca, 'fontsize', 17, 'fontname', 'Arial')

subplot(2, 2, 3);
surf(xrange, time_stamp/3600, (VR1 + PR1) * avogadro * EC_area);
ylim([0 1])
view(90, 0)
title('VEGFR1 complex', 'fontname', 'Arial')
xlabel('Distance (cm)', 'fontname', 'Arial')
ylabel('Time (hour)', 'fontname', 'Arial')
zlabel('Complex (rec/cell)', 'fontname', 'Arial')
set(gca, 'fontsize', 17, 'fontname', 'Arial')

subplot(2, 2, 4);
surf(xrange, time_stamp/3600, VR2 * avogadro * EC_area);
ylim([0 1])
view(90, 0)
title('VEGFR2 complex', 'fontname', 'Arial')
xlabel('Distance (cm)', 'fontname', 'Arial')
ylabel('Time (hour)', 'fontname', 'Arial')
zlabel('Complex (rec/cell)', 'fontname', 'Arial')
set(gca, 'fontsize', 17, 'fontname', 'Arial')

saveas(gca, sprintf('%s/Figure1A', result_foldername), 'epsc')
saveas(gca, sprintf('%s/Figure1A', result_foldername), 'png')

%% Visualize ligand distribution
R1_dist = [VR1(:, 1), PR1(:, 1)] * avogadro * EC_area;
R2_dist = VR2(:, 1) * avogadro * EC_area;
interest = 1:find(time_stamp == 3600*3);


figure('Position', [10 10 800 400])
a = area(time_stamp(interest)/3600, R1_dist(interest, :), 'EdgeColor', 'none');
a(1).FaceColor = [255, 89, 95]/256;
a(2).FaceColor = [106, 76, 147]/256;
xlabel('Time (hour)', 'fontname', 'Arial')
ylabel('# of Complexes (rec/cell)', 'fontname', 'Arial')
legend('VEGF-A', 'PlGF', 'Location', 'northeastoutside', 'fontname', 'Arial')
set(gca, 'fontsize', 17, 'fontname', 'Arial')
saveas(gca, sprintf('%s/lig_dist', result_foldername), 'epsc')
saveas(gca, sprintf('%s/lig_dist', result_foldername), 'png')

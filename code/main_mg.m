clear; close all; clc;

%% Add path
% Initialize path
restoredefaultpath;

% Add paths
addpath ../data/ model/mg etc/

%% Define params
params_raw = readtable("parameters_mg.csv");
params = change_unit_mg(params_raw);

%% Generate mesh
xrange = 0:5e-3:0.1;
time_stamp = 0:100:3600*24;

%% Solve PDE
m = 0;
sol = pdepe(m, @(x, t, u, dudx) pdefun(x, t, u, dudx, params), ...
            @(x) pdeic(x, params), ...
            @(xl, ul, xr, ur, t) pdebc(xl, ul, xr, ur, t, params), ...
            xrange, time_stamp);

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
surf(xrange,time_stamp/3600, V * 1e9)
title('V(x,t)')
xlabel('Distance (cm)')
ylabel('Time (hour)')
zlabel('Concentration (nM)')
set(gca, 'fontsize', 25)

subplot(2, 2, 2);
surf(xrange,time_stamp/3600, P * 1e9)
title('P(x,t)')
xlabel('Distance (cm)')
ylabel('Time (hour)')
zlabel('Concentration (nM)')
set(gca, 'fontsize', 25)

subplot(2, 2, 3);
surf(xrange, time_stamp/3600, (VR1 + PR1) * avogadro * EC_area);
view(90, 0)
title('VEGFR1 complex(x,t)')
xlabel('Distance (cm)')
ylabel('Time (hour)')
zlabel('Complex (rec/cell)')
set(gca, 'fontsize', 25)

subplot(2, 2, 4);
surf(xrange, time_stamp/3600, VR2 * avogadro * EC_area);
view(90, 0)
title('VEGFR2 complex(x,t)')
xlabel('Distance (cm)')
ylabel('Time (hour)')
zlabel('Complex (rec/cell)')
set(gca, 'fontsize', 25)

function [] = visualize_dynamics(time_stamp, result, result_foldername)
%% Colors
color_lig = {'#ff595e', '#ff924c', '#ffca3a', '#8ac926', '#1982c4', '#6a4c93'};
color_rec = {'#8ecae6', '#219ebc', '#023047', '#ffb703', '#fb8500'};

%% List of ligands and receptors
lig = {'VEGF-A', 'VEGF-B', 'PlGF', 'PDGF-AA', 'PDGF-AB', 'PDGF-BB'};
rec = {'VEGFR1', 'VEGFR2', 'NRP1', 'PDGFRa', 'PDGFRb'};

%% Define legend
lgd_lig = {};
for i = 1:length(lig)
    lgd_lig{end+1} = [lig{i}, ' (Free)'];
    lgd_lig{end+1} = [lig{i}, ' (Bound)'];
end

lgd_rec = {};
for i = 1:length(rec)
    lgd_rec{end+1} = [rec{i}, ' (Free)'];
    lgd_rec{end+1} = [rec{i}, ' (Bound)'];
end

%% Plot free vs. bound ligand
lig_list = {'VA', 'VB', 'Pl', 'PDAA', 'PDAB', 'PDBB'};
data_free = zeros(length(result.VA_free), length(lig_list));
data_bound = zeros(length(result.VA_free), length(lig_list));
for i = 1:length(lig_list)
    data_free(:, i) = result.(sprintf('%s_free', lig_list{i})) * 1e12;
    data_bound(:, i) = result.(sprintf('%s_bound', lig_list{i})) * 1e12;
end

% Long time
ylab = 'pM';
filename = 'dynamics_free_vs_bound_lig';
plot_free_vs_bound(time_stamp, data_free, data_bound, ylab, lgd_lig, color_lig, false, result_foldername, filename)

% Short time
filename = 'short_dynamics_free_vs_bound_lig';
plot_free_vs_bound(time_stamp, data_free, data_bound, ylab, lgd_lig, color_lig, true, result_foldername, filename)

%% Plot free vs. bound receptor
avogadro = 6.02214e23; % Molecule/mol
EC_vol = 1e-12; % Liter
rec_list = {'R1', 'R2', 'N1', 'PDRa', 'PDRb'};

data_free = zeros(length(result.VA_free), length(rec_list));
data_bound = zeros(length(result.VA_free), length(rec_list));
for i = 1:length(rec_list)
    data_free(:, i) = result.(sprintf('%s_free', rec_list{i})) * avogadro * EC_vol;
    data_bound(:, i) = result.(sprintf('%s_bound', rec_list{i})) * avogadro * EC_vol;
end


%% Plot bound ligand to VEGFR1
figure('Position', [10 10 800 400])
hold on;
plot(time_stamp/3600, result.VA_R1 * 1e12, 'Color', color_lig{1}, 'LineWidth', 3);
plot(time_stamp/3600, result.VB_R1 * 1e12, 'Color', color_lig{2}, 'LineWidth', 3);
plot(time_stamp/3600, result.Pl_R1 * 1e12, 'Color', color_lig{3}, 'LineWidth', 3);
hold off;
xlabel('Time (hour)')
ylabel('pM')
legend('VEGF-A', 'VEGF-B', 'PlGF', 'Location', 'northeastoutside')
set(gca, 'fontsize', 25);
saveas(gca, sprintf('%s/dynamics_lig_dist_R1', result_foldername), 'epsc')
saveas(gca, sprintf('%s/dynamics_lig_dist_R1', result_foldername), 'png')

%% Plot bound ligand to VEGFR2
figure('Position', [10 10 800 400])
hold on;
plot(time_stamp/3600, (result.VA_R2 + result.VA_R2_N1) * 1e12, 'Color', color_lig{1}, 'LineWidth', 3);
plot(time_stamp/3600, result.PDAA_R2 * 1e12, 'Color', color_lig{4}, 'LineWidth', 3);
plot(time_stamp/3600, result.PDAB_R2 * 1e12, 'Color', color_lig{5}, 'LineWidth', 3);
plot(time_stamp/3600, result.PDBB_R2 * 1e12, 'Color', color_lig{6}, 'LineWidth', 3);
hold off;
xlabel('Time (hour)')
ylabel('pM')
legend('VEGF-A', 'PDGF-AA', 'PDGF-AB', 'PDGF-BB', 'Location', 'northeastoutside')
set(gca, 'fontsize', 25);
saveas(gca, sprintf('%s/dynamics_lig_dist_R2', result_foldername), 'epsc')
saveas(gca, sprintf('%s/dynamics_lig_dist_R2', result_foldername), 'png')

%% Plot bound ligand to NRP1
figure('Position', [10 10 800 400])
hold on;
plot(time_stamp/3600, (result.VA_N1 + result.VA_R2_N1) * 1e12, 'Color', color_lig{1}, 'LineWidth', 3);
plot(time_stamp/3600, result.VB_N1 * 1e12, 'Color', color_lig{2}, 'LineWidth', 3);
plot(time_stamp/3600, result.Pl_N1 * 1e12, 'Color', color_lig{3}, 'LineWidth', 3);
hold off;
xlabel('Time (hour)')
ylabel('pM')
legend('VEGF-A', 'VEGF-B', 'PlGF', 'Location', 'northeastoutside')
set(gca, 'fontsize', 25);
saveas(gca, sprintf('%s/dynamics_lig_dist_N1', result_foldername), 'epsc')
saveas(gca, sprintf('%s/dynamics_lig_dist_N1', result_foldername), 'png')

%% Plot bound ligand to PDGFRa
figure('Position', [10 10 800 400])
hold on;
plot(time_stamp/3600, result.VA_PDRa * 1e12, 'Color', color_lig{1}, 'LineWidth', 3);
plot(time_stamp/3600, result.PDAA_PDRa * 1e12, 'Color', color_lig{4}, 'LineWidth', 3);
plot(time_stamp/3600, result.PDAB_PDRa * 1e12, 'Color', color_lig{5}, 'LineWidth', 3);
plot(time_stamp/3600, result.PDBB_PDRa * 1e12, 'Color', color_lig{6}, 'LineWidth', 3);
hold off;
xlabel('Time (hour)')
ylabel('pM')
legend('VEGF-A', 'PDGF-AA', 'PDGF-AB', 'PDGF-BB', 'Location', 'northeastoutside')
set(gca, 'fontsize', 25);
saveas(gca, sprintf('%s/dynamics_lig_dist_PDRa', result_foldername), 'epsc')
saveas(gca, sprintf('%s/dynamics_lig_dist_PDRa', result_foldername), 'png')

%% Plot bound ligand to PDGFRb
figure('Position', [10 10 800 400])
hold on;
plot(time_stamp/3600, result.VA_PDRb * 1e12, 'Color', color_lig{1}, 'LineWidth', 3);
plot(time_stamp/3600, result.PDAB_PDRb * 1e12, 'Color', color_lig{5}, 'LineWidth', 3);
plot(time_stamp/3600, result.PDBB_PDRb * 1e12, 'Color', color_lig{6}, 'LineWidth', 3);
hold off;
xlabel('Time (hour)')
ylabel('pM')
legend('VEGF-A', 'PDGF-AB', 'PDGF-BB', 'Location', 'northeastoutside')
set(gca, 'fontsize', 25);
saveas(gca, sprintf('%s/dynamics_lig_dist_PDRb', result_foldername), 'epsc')
saveas(gca, sprintf('%s/dynamics_lig_dist_PDRb', result_foldername), 'png')

end

function [] = plot_free_vs_bound(time_stamp, data_free, data_bound, ylab, lgd, color, flag_short, result_foldername, filename)
% If you are going to plot only short time
if flag_short
    interest = 61;
    time_stamp = time_stamp(1:interest)/60;
    data_free = data_free(1:interest, :);
    data_bound = data_bound(1:interest, :);
    xlab = 'Time (min)';
else
    time_stamp = time_stamp/3600;
    xlab = 'Time (hour)';
end

% Plot
figure('Position', [10 10 800 400])
hold on;
for i = 1:size(data_free, 2)
    plot(time_stamp, data_free(:, i), 'Color', color{i}, 'LineWidth', 3)
    plot(time_stamp, data_bound(:, i), 'Color', color{i}, 'LineWidth', 3, 'LineStyle', '--');
end
hold off;
xlabel(xlab)
ylabel(ylab)
legend(lgd, 'Location', 'northeastoutside')
set(gca, 'fontsize', 25);
saveas(gca, sprintf('%s/%s', result_foldername, filename), 'epsc')
saveas(gca, sprintf('%s/%s', result_foldername, filename), 'png')

end

function [] = plot_bound(time_stamp, data, ylab, lgd, color, flag_short, result_foldername, filename)
% If you are going to plot only short time
if flag_short
    interest = 61;
    time_stamp = time_stamp(1:interest)/60;
    data = data(1:interest, :);
    xlab = 'Time (min)';
else
    time_stamp = time_stamp/3600;
    xlab = 'Time (hour)';
end

% Plot
figure('Position', [10 10 800 400])
hold on;
for i = 1:size(data, 2)
    plot(time_stamp, data(:, i), 'Color', color{i}, 'LineWidth', 3);
end
hold off;
xlabel(xlab)
ylabel(ylab)
legend(lgd, 'Location', 'northeastoutside')
set(gca, 'fontsize', 25);
saveas(gca, sprintf('%s/%s', result_foldername, filename), 'epsc')
saveas(gca, sprintf('%s/%s', result_foldername, filename), 'png')

end

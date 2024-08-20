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
figure('Position', [10 10 800 400])
hold on;
% VEGF-A
plot(time_stamp/3600, result.VA_free * 1e12, 'Color', color_lig{1}, 'LineWidth', 3);
plot(time_stamp/3600, result.VA_bound * 1e12, 'Color', color_lig{1}, 'LineWidth', 3, 'LineStyle', '--');
% VEGF-B
plot(time_stamp/3600, result.VB_free * 1e12, 'Color', color_lig{2}, 'LineWidth', 3);
plot(time_stamp/3600, result.VB_bound * 1e12, 'Color', color_lig{2}, 'LineWidth', 3, 'LineStyle', '--');
% PlGF
plot(time_stamp/3600, result.Pl_free * 1e12, 'Color', color_lig{3}, 'LineWidth', 3);
plot(time_stamp/3600, result.Pl_bound * 1e12, 'Color', color_lig{3}, 'LineWidth', 3, 'LineStyle', '--');
% PDGF-AA
plot(time_stamp/3600, result.PDAA_free * 1e12, 'Color', color_lig{4}, 'LineWidth', 3);
plot(time_stamp/3600, result.PDAA_bound * 1e12, 'Color', color_lig{4}, 'LineWidth', 3, 'LineStyle', '--');
% PDGF-AB
plot(time_stamp/3600, result.PDAB_free * 1e12, 'Color', color_lig{5}, 'LineWidth', 3);
plot(time_stamp/3600, result.PDAB_bound * 1e12, 'Color', color_lig{5}, 'LineWidth', 3, 'LineStyle', '--');
% PDGF-BB
plot(time_stamp/3600, result.PDBB_free * 1e12, 'Color', color_lig{6}, 'LineWidth', 3);
plot(time_stamp/3600, result.PDBB_bound * 1e12, 'Color', color_lig{6}, 'LineWidth', 3, 'LineStyle', '--');
hold off;
xlabel('Time (hour)')
ylabel('pM')
legend(lgd_lig, 'Location', 'northeastoutside')
set(gca, 'fontsize', 25);
saveas(gca, sprintf('%s/dynamics_free_vs_bound_lig', result_foldername), 'epsc')
saveas(gca, sprintf('%s/dynamics_free_vs_bound_lig', result_foldername), 'png')

%% Plot free vs. bound receptor
avogadro = 6.02214e23; % Molecule/mol
EC_vol = 1e-12; % Liter

figure('Position', [10 10 800 400])
hold on;
% VEGFR1
plot(time_stamp/3600, result.R1_free * avogadro * EC_vol, 'Color', color_rec{1}, 'LineWidth', 3);
plot(time_stamp/3600, result.R1_bound * avogadro * EC_vol, 'Color', color_rec{1}, 'LineWidth', 3, 'LineStyle', '--');
% VEGFR2
plot(time_stamp/3600, result.R2_free * avogadro * EC_vol, 'Color', color_rec{2}, 'LineWidth', 3);
plot(time_stamp/3600, result.R2_bound * avogadro * EC_vol, 'Color', color_rec{2}, 'LineWidth', 3, 'LineStyle', '--');
% NRP1
plot(time_stamp/3600, result.N1_free * avogadro * EC_vol, 'Color', color_rec{3}, 'LineWidth', 3);
plot(time_stamp/3600, result.N1_bound * avogadro * EC_vol, 'Color', color_rec{3}, 'LineWidth', 3, 'LineStyle', '--');
% PDGFRa
plot(time_stamp/3600, result.PDRa_free * avogadro * EC_vol, 'Color', color_rec{4}, 'LineWidth', 3);
plot(time_stamp/3600, result.PDRa_bound * avogadro * EC_vol, 'Color', color_rec{4}, 'LineWidth', 3, 'LineStyle', '--');
% PDGFRb
plot(time_stamp/3600, result.PDRb_free * avogadro * EC_vol, 'Color', color_rec{5}, 'LineWidth', 3);
plot(time_stamp/3600, result.PDRb_bound * avogadro * EC_vol, 'Color', color_rec{5}, 'LineWidth', 3, 'LineStyle', '--');
hold off;
xlabel('Time (hour)')
ylabel('Receptors/cell')
legend(lgd_rec, 'Location', 'northeastoutside')
set(gca, 'fontsize', 25);
saveas(gca, sprintf('%s/dynamics_free_vs_bound_rec', result_foldername), 'epsc')
saveas(gca, sprintf('%s/dynamics_free_vs_bound_rec', result_foldername), 'png')

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

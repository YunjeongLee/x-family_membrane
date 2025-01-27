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
plot_free_vs_bound(time_stamp, [], data_free, data_bound, ylab, lgd_lig, color_lig, result_foldername, filename)

% Short time
interest = 60*60+1;
filename = 'short_dynamics_free_vs_bound_lig';
plot_free_vs_bound(time_stamp, interest, data_free, data_bound, ylab, lgd_lig, color_lig, result_foldername, filename)

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

% Long time
ylab = 'Receptors/cell';
filename = 'dynamics_free_vs_bound_rec';
plot_free_vs_bound(time_stamp, [], data_free, data_bound, ylab, lgd_rec, color_rec, result_foldername, filename)

% Short time
interest = 5*60+1;
filename = 'short_dynamics_free_vs_bound_rec';
plot_free_vs_bound(time_stamp, interest, data_free, data_bound, ylab, lgd_rec, color_rec, result_foldername, filename)

%% Plot bound ligand to VEGFR1
data = [result.VA_R1, result.VB_R1, result.Pl_R1] * 1e12;
ylab = 'pM';
lgd = {'VEGF-A', 'VEGF-B', 'PlGF'};
color = color_lig(1:3);

% Long time
filename = 'dynamics_lig_dist_R1';
plot_bound(time_stamp, [], data, ylab, lgd, color, result_foldername, filename);

if result.VB(1) == 0
    data_temp = [result.VA_R1, result.Pl_R1] * avogadro * EC_vol;
    filename = 'stack_lig_dist_R1';
    ylab_temp = '# of Complexes (rec/cell)';
    lgd_temp = {'VEGF-A', 'PlGF'};
    plot_stack(time_stamp, [], data_temp, ylab_temp, lgd_temp, color_lig, result_foldername, filename);
end

% Short time
interest = 60*60*12+1;
filename = 'short_dynamics_lig_dist_R1';
plot_bound(time_stamp, interest, data, ylab, lgd, color, result_foldername, filename);

%% Plot bound ligand to VEGFR2
data = [(result.VA_R2 + result.VA_R2_N1), result.PDAA_R2, result.PDAB_R2, result.PDBB_R2] * 1e12;
ylab = 'pM';
lgd = {'VEGF-A', 'PDGF-AA', 'PDGF-AB', 'PDGF-BB'};
color = color_lig([1, 4:6]);

% Long time
filename = 'dynamics_lig_dist_R2';
plot_bound(time_stamp, [], data, ylab, lgd, color, result_foldername, filename);

% Short time
interest = 60*60+1;
filename = 'short_dynamics_lig_dist_R2';
plot_bound(time_stamp, interest, data, ylab, lgd, color, result_foldername, filename);

%% Plot bound ligand to NRP1
data = [(result.VA_N1 + result.VA_R2_N1), result.VB_N1, result.Pl_N1] * 1e12;
ylab = 'pM';
lgd = {'VEGF-A', 'VEGF-B', 'PlGF'};
color = color_lig(1:3);

% Long time
filename = 'dynamics_lig_dist_N1';
plot_bound(time_stamp, [], data, ylab, lgd, color, result_foldername, filename);

% Short time
interest = 20*60+1;
filename = 'short_dynamics_lig_dist_N1';
plot_bound(time_stamp, interest, data, ylab, lgd, color, result_foldername, filename);

%% Plot bound ligand to PDGFRa
data = [result.VA_PDRa, result.PDAA_PDRa, result.PDAB_PDRa, result.PDBB_PDRa] * 1e12;
ylab = 'pM';
lgd = {'VEGF-A', 'PDGF-AA', 'PDGF-AB', 'PDGF-BB'};
color = color_lig([1, 4:6]);

% Long time
filename = 'dynamics_lig_dist_PDRa';
plot_bound(time_stamp, [], data, ylab, lgd, color, result_foldername, filename);

% Short time
interest = 60*60*4+1;
filename = 'short_dynamics_lig_dist_PDRa';
plot_bound(time_stamp, interest, data, ylab, lgd, color, result_foldername, filename);

%% Plot bound ligand to PDGFRb
data = [result.VA_PDRb, result.PDAB_PDRb, result.PDBB_PDRb] * 1e12;
ylab = 'pM';
lgd = {'VEGF-A', 'PDGF-AB', 'PDGF-BB'};
color = color_lig([1, 5:6]);

% Long time
filename = 'dynamics_lig_dist_PDRb';
plot_bound(time_stamp, [], data, ylab, lgd, color, result_foldername, filename);

% Short time
interest = 60*60*2+1;
filename = 'short_dynamics_lig_dist_PDRb';
plot_bound(time_stamp, interest, data, ylab, lgd, color, result_foldername, filename);

end

function [] = plot_free_vs_bound(time_stamp, interest, data_free, data_bound, ylab, lgd, color, result_foldername, filename)
% If you are going to plot only short time
if ~isempty(interest)
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
xlabel(xlab, 'fontname', 'Arial')
ylabel(ylab, 'fontname', 'Arial')
legend(lgd, 'Location', 'northeastoutside', 'fontname', 'Arial')
set(gca, 'fontsize', 17, 'fontname', 'Arial');
saveas(gca, sprintf('%s/%s', result_foldername, filename), 'epsc')
saveas(gca, sprintf('%s/%s', result_foldername, filename), 'png')

end

function [] = plot_bound(time_stamp, interest, data, ylab, lgd, color, result_foldername, filename)
% If you are going to plot only short time
if ~isempty(interest)
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
xlabel(xlab, 'fontname', 'Arial')
ylabel(ylab, 'fontname', 'Arial')
legend(lgd, 'Location', 'northeastoutside', 'fontname', 'Arial')
set(gca, 'fontsize', 17, 'fontname', 'Arial');
saveas(gca, sprintf('%s/%s', result_foldername, filename), 'epsc')
saveas(gca, sprintf('%s/%s', result_foldername, filename), 'png')

end

function [] = plot_stack(time_stamp, interest, data, ylab, lgd, color, result_foldername, filename)
% If you are going to plot only short time
if ~isempty(interest)
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
a = area(time_stamp, data, 'EdgeColor', 'none');
a(1).FaceColor = color{1};
a(2).FaceColor = color{end};
hold off;
xlabel(xlab, 'fontname', 'Arial')
ylabel(ylab, 'fontname', 'Arial')
ylim([0 1610])
legend(lgd, 'Location', 'northeastoutside', 'fontname', 'Arial')
set(gca, 'fontsize', 17, 'fontname', 'Arial');
saveas(gca, sprintf('%s/%s', result_foldername, filename), 'epsc')
saveas(gca, sprintf('%s/%s', result_foldername, filename), 'png')

end
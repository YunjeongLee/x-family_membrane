function [] = visualize_each_ligand(params_struct, time_stamp, result_all, result_each, result_foldername)
%% Find index for free ligands
ind_VA = strcmp(params_struct.species_names, 'VA');
ind_VB = strcmp(params_struct.species_names, 'VB');
ind_Pl = strcmp(params_struct.species_names, 'Pl');
ind_PDAA = strcmp(params_struct.species_names, 'PDAA');
ind_PDAB = strcmp(params_struct.species_names, 'PDAB');
ind_PDBB = strcmp(params_struct.species_names, 'PDBB');

%% Colors
color_lig = {'#A4036F', '#54478C', '#048BA8', '#16DB93', '#EFEA5A', '#F29E4C'};
color_rec = {'#729EA1', '#B5BD89', '#DFBE99', '#EC9192', '#DB5375'};

%% Check which ligand was treated and set receptors and color for the plot
if ~isempty(find(ind_VA, 1))
    lig = 'VA';
    rec = {'R1', 'R2', 'N1', 'PDRa', 'PDRb'};
    rec_lgd = {'VEGFR1', 'VEGFR2', 'NRP1', 'PDGFR\alpha', 'PDGFR\beta'};
    color_ligand = color_lig{1};
    color_receptor = color_rec;
elseif ~isempty(find(ind_VB, 1))
    lig = 'VB';
    rec = {'R1', 'N1'};
    rec_lig = {'VEGFR1', 'NRP1'};
    color_ligand = color_lig{2};
    color_receptor = color_rec([1, 3]);
elseif ~isempty(find(ind_Pl, 1))
    lig = 'Pl';
    rec = {'R1', 'N1'};
    rec_lig = {'VEGFR1', 'NRP1'};
    color_ligand = color_lig{3};
    color_receptor = color_rec([1, 3]);
elseif ~isempty(find(ind_PDAA, 1))
    lig = 'PDAA';
    rec = {'R2', 'PDRa'};
    rec_lig = {'VEGFR2', 'PDGFR\alpha'};
    color_ligand = color_lig{4};
    color_receptor = color_rec([2, 4]);
elseif ~isempty(find(ind_PDAB, 1))
    lig = 'PDAB';
    rec = {'R2', 'PDRa', 'PDRb'};
    rec_lig = {'VEGFR2', 'PDGFR\alpha', 'PDGFR\beta'};
    color_ligand = color_lig{5};
    color_receptor = color_rec([2, 4, 5]);
elseif ~isempty(find(ind_PDBB, 1))
    lig = 'PDBB';
    rec = {'R2', 'PDRa', 'PDRb'};
    rec_lig = {'VEGFR2', 'PDGFR\alpha', 'PDGFR\beta'};
    color_ligand = color_lig{6};
    color_receptor = color_rec([2, 4, 5]);
end

%% Visualize dynamics for free vs. bound ligand
% Define the concentrations of free and bound ligands
Free_lig = result_each.(sprintf('%s_free', lig));
Bound_lig = result_each.(sprintf('%s_bound', lig));
lgd = {sprintf('%s (Free)', lig), sprintf('%s (Bound)', lig)};

% Plot figure
figure('Position', [10 10 800 400])
hold on;
plot(time_stamp/3600, Free_lig * 1e12, 'Color', color_ligand, 'LineWidth', 3);
plot(time_stamp/3600, Bound_lig * 1e12, 'Color', color_ligand, 'LineWidth', 3, 'LineStyle', '--');
hold off;
xlabel('Time (hour)')
ylabel('pM')
legend(lgd, 'Location', 'northeastoutside')
set(gca, 'fontsize', 25);
saveas(gca, sprintf('%s/dynamics_free_vs_bound_%s', result_foldername, lig), 'epsc')
saveas(gca, sprintf('%s/dynamics_free_vs_bound_%s', result_foldername, lig), 'png')

%% Visualize dynamics for free vs. bound receptor
avogadro = 6.02214e23; % Molecule/mol
EC_vol = 1e-12; % Liter

% Define legend
lgd = [cellfun(@(x) [x, ' (Free)'], rec_lgd, 'UniformOutput', false); ...
       cellfun(@(x) [x, ' (Bound)'], rec_lgd, 'UniformOutput', false)];
lgd = lgd(:);

% Plot figure
figure('Position', [10 10 800 400])
hold on;
for i = 1:length(rec)
    Free_rec = result_each.(sprintf('%s_free', rec{i}));
    Bound_rec = result_each.(sprintf('%s_bound', rec{i}));
    plot(time_stamp/3600, Free_rec * avogadro * EC_vol, 'Color', color_receptor{i}, 'LineWidth', 3);
    plot(time_stamp/3600, Bound_rec * avogadro * EC_vol, 'Color', color_receptor{i}, 'LineWidth', 3, 'LineStyle', '--');
end
hold off;
xlabel('Time (hour)')
ylabel('Receptors/cell')
legend(lgd, 'Location', 'northeastoutside')
set(gca, 'fontsize', 25);
saveas(gca, sprintf('%s/dynamics_free_vs_bound_rec_%s', result_foldername, lig), 'epsc')
saveas(gca, sprintf('%s/dynamics_free_vs_bound_rec_%s', result_foldername, lig), 'png')

%% Visualize free vs. bound ligand proportion
% Define the ratio of free vs. bound ligand for each ligand treatment
ratio_each = [Free_lig(end), Bound_lig(end)]/(Free_lig(end) + Bound_lig(end)) * 100;

% Define the ratio of free vs. bound ligand for all ligand treatment
Free_lig_all = result_all.(sprintf('%s_free', lig));
Bound_lig_all = result_all.(sprintf('%s_bound', lig));
ratio_all = [Free_lig_all(end), Bound_lig_all(end)]/(Free_lig_all(end) + Bound_lig_all(end)) * 100;
data = [ratio_each; ratio_all];

% Plot figure
figure('Position', [10 10 600 400]);
b = bar(1:2, data, 'stacked', 'EdgeColor', 'none', 'BarWidth', 0.5);
b(1).FaceColor = color_lig{1};
b(2).FaceColor = color_lig{3};
for j = 1:size(data, 2)
    for i = 1:size(data, 1)
            if j ~= 2
                text(i-0.2, sum(data(i, 1:j))+3, sprintf('%.2f', data(i, j)), 'FontSize', 20, 'Color', 'w');
            else
                text(i-0.2, sum(data(i, 1:j))-5, sprintf('%.2f', data(i, j)), 'FontSize', 20, 'Color', 'w');
            end
    end
end
xlim([0 3]);
ylim([0 100]);
xticklabels({sprintf('%s-treated', lig), 'All ligands'})
ylabel('Proportion (%)')
legend('Free', 'Bound', 'location', 'northeastoutside')
set(gca, 'fontsize', 20);
saveas(gca, sprintf('%s/free_VS_bound_%s', result_foldername, lig), 'png');
saveas(gca, sprintf('%s/free_VS_bound_%s', result_foldername, lig), 'epsc');

%% Visualize free vs. bound receptor proportion
% Define ratio of free vs. bound receptor for each ligand treatment
ratio_each = zeros(length(rec), 2);
ratio_all = zeros(length(rec), 2);
for i = 1:length(rec)
    % Each treatment
    free_rec_each = result_each.(sprintf('%s_free', rec{i}));
    bound_rec_each = result_each.(sprintf('%s_bound', rec{i}));
    ratio_each(i, :) = [free_rec_each(end), bound_rec_each(end)]/(free_rec_each(end) + bound_rec_each(end)) * 100;
    % All treatment
    free_rec_all = result_all.(sprintf('%s_free', rec{i}));
    bound_rec_all = result_all.(sprintf('%s_bound', rec{i}));
    ratio_all(i, :) = [free_rec_all(end), bound_rec_all(end)]/(free_rec_all(end) + bound_rec_all(end)) * 100;
end

% Plot figure
figure('Position', [10 10 1600 500]);
hold on;
b1 = bar((1:length(rec)) - 0.2, ratio_each, 'stacked', 'EdgeColor', 'none', 'BarWidth', 0.3);
b1(1).FaceColor = color_lig{1};
b1(2).FaceColor = color_lig{3};
for j = 1:size(ratio_each, 2)
    for i = 1:size(ratio_each, 1)
            if j ~= 2
                text(i-0.2-0.14, 3, sprintf('%.2f', ratio_each(i, j)), 'FontSize', 20, 'Color', 'w');
            else
                text(i-0.2-0.14, sum(ratio_each(i, 1:j))-3, sprintf('%.2f', ratio_each(i, j)), 'FontSize', 20, 'Color', 'w');
            end
    end
end
xticklabels([{''}, rec_lgd, {''}])
xlim([0 length(rec)+1])
ylim([0 100])
ylabel('Proportion (%)')

b2 = bar((1:length(rec)) + 0.2, ratio_all, 'stacked', 'EdgeColor', 'none', 'BarWidth', 0.3);
b2(1).FaceColor = color_lig{2};
b2(2).FaceColor = color_lig{4};
for j = 1:size(ratio_all, 2)
    for i = 1:size(ratio_all, 1)
            if j ~= 2
                text(i+0.2-0.14, 3, sprintf('%.2f', ratio_all(i, j)), 'FontSize', 20, 'Color', 'w');
            else
                text(i+0.2-0.14, sum(ratio_all(i, 1:j))-3, sprintf('%.2f', ratio_all(i, j)), 'FontSize', 20, 'Color', 'w');
            end
    end
end
hold off;
legend([b1, b2], 'Free (each ligand)', 'Bound (each ligand)', ...
    'Free (all ligands)', 'Bound (all ligands)', 'Location', 'northeastoutside')
set(gca, 'fontsize', 20)
saveas(gca, sprintf('%s/Receptor_free_VS_bound_%s', result_foldername, lig), 'png')
saveas(gca, sprintf('%s/Receptor_free_VS_bound_%s', result_foldername, lig), 'epsc')

%% Visualize proportion of a specified ligand occupying each receptor
ratio_all = zeros(length(rec), 1);
for i = 1:length(rec)
    bound_rec_all = result_all.(sprintf('%s_bound', rec{i}));
    if strcmp(lig, 'VA') && strcmp(rec{i}, 'R2')
        complex = {[lig, '_', rec{i}], [lig, '_', rec{i}, '_N1']};
        lig_rec = result_all.(sprintf('%s', complex{1})) + result_all.(sprintf('%s', complex{2}));
    else
        complex = [lig, '_', rec{i}];
        lig_rec = result_all.(sprintf('%s', complex));
    end
    ratio_all(i) = lig_rec(end)/bound_rec_all(end) * 100;
end
data = [ratio_each(:, 2), ratio_all];

% Visualize figure
figure('Position', [10 10 1200 500]);
b = bar(1:length(rec), data, 'EdgeColor', 'none', 'BarWidth', 1);
b(1).FaceColor = color_lig{1};
b(2).FaceColor = color_lig{3};
for j = 1:size(data, 2)
    if j == 1
        for i = 1:size(data, 1)
            text(i-0.3, data(i, j)+3, sprintf('%.2f', data(i, j)), 'FontSize', 20, 'Color', 'k');
        end
    else
        for i = 1:size(data, 1)
            text(i+0, data(i, j)+3, sprintf('%.2f', data(i, j)), 'FontSize', 20, 'Color', 'k');
        end
    end
end
xticklabels(rec_lgd)
legend({sprintf('%s-treated', lig), 'All ligands'}, 'Location', 'northeastoutside')
xlim([0 length(rec)+1])
ylim([0 70])
ylabel('Proportion (%)')
set(gca, 'fontsize', 20)
saveas(gca, sprintf('%s/Receptor_free_VS_bound_%s', result_foldername, lig), 'png')
saveas(gca, sprintf('%s/Receptor_free_VS_bound_%s', result_foldername, lig), 'epsc')

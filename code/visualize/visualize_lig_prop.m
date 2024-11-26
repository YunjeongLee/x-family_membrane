function [] = visualize_lig_prop(result, result_foldername)
%% Define color of bar
color_rec = {'#345995', '#eac435'};

%% Calculate proportion of free and bound ligand
VA = [result.VA_free(end), result.VA_bound(end)]/(result.VA_free(end) + result.VA_bound(end)) * 100;
VB = [result.VB_free(end), result.VB_bound(end)]/(result.VB_free(end) + result.VB_bound(end)) * 100;
Pl = [result.Pl_free(end), result.Pl_bound(end)]/(result.Pl_free(end) + result.Pl_bound(end)) * 100;
PDAA = [result.PDAA_free(end), result.PDAA_bound(end)]/(result.PDAA_free(end) + result.PDAA_bound(end)) * 100;
PDAB = [result.PDAB_free(end), result.PDAB_bound(end)]/(result.PDAB_free(end) + result.PDAB_bound(end)) * 100;
PDBB = [result.PDBB_free(end), result.PDBB_bound(end)]/(result.PDBB_free(end) + result.PDBB_bound(end)) * 100;

%% Generate data for bar plot
data = [VA; VB; Pl; PDAA; PDAB; PDBB];

%% Plot figure
figure('Position', [10 10 1200 500]);
b = bar(1:6, data, 'stacked', 'EdgeColor', 'none', 'BarWidth', 0.5);
b(1).FaceColor = color_rec{4};
b(2).FaceColor = color_rec{5};
for j = 1:size(data, 2)
    for i = 1:size(data, 1)
            if j ~= 2
                text(i-0.1, sum(data(i, 1:j))+3, sprintf('%.0f', data(i, j)), 'FontSize', 20, 'Color', 'k');
            else
                text(i-0.1, sum(data(i, 1:j))-5, sprintf('%.0f', data(i, j)), 'FontSize', 20, 'Color', 'k');
            end
    end
end
xlim([0 7]);
ylim([0 100]);
xticklabels({'VEGF-A', 'VEGF-B', 'PlGF', 'PDGF-AA', 'PDGF-AB', 'PDGF-BB'})
ylabel('Percentage (%)')
legend('Free', 'Bound', 'location', 'northeastoutside')
set(gca, 'fontsize', 25);
saveas(gca, sprintf('%s/Ligand_free_VS_bound', result_foldername), 'png');
saveas(gca, sprintf('%s/Ligand_free_VS_bound', result_foldername), 'epsc');
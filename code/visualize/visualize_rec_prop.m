function [] = visualize_rec_prop(result, result_foldername)
%% Define color of bar
color_lig = {'#ff595e', '#ff924c', '#ffca3a', '#8ac926', '#1982c4', '#6a4c93'};
color_rec = {'#345995', '#eac435'};

%% Calculate the proportion of free vs. bound receptors
R1 = [result.R1_free(end), result.R1_bound(end)]/(result.R1_free(end) + result.R1_bound(end)) * 100;
R2 = [result.R2_free(end), result.R2_bound(end)]/(result.R2_free(end) + result.R2_bound(end)) * 100;
N1 = [result.N1_free(end), result.N1_bound(end)]/(result.N1_free(end) + result.N1_bound(end)) * 100;
PDRa = [result.PDRa_free(end), result.PDRa_bound(end)]/(result.PDRa_free(end) + result.PDRa_bound(end)) * 100;
PDRb = [result.PDRb_free(end), result.PDRb_bound(end)]/(result.PDRb_free(end) + result.PDRb_bound(end)) * 100;

%% Generate data for plot
data = [R1; R2; N1; PDRa; PDRb];

%% Plot figure
figure('Position', [10 10 1200 500]);
b = bar(1:5, data, 'stacked', 'EdgeColor', 'none', 'BarWidth', 0.5);
b(1).FaceColor = color_rec{1};
b(2).FaceColor = color_rec{2};
for j = 1:size(data, 2)
    for i = 1:size(data, 1)
            if j ~= 2
                text(i-0.1, 3, sprintf('%.0f', data(i, j)), 'FontSize', 20, 'Color', 'w', 'fontname', 'Arial');
            else
                text(i-0.1, sum(data(i, 1:j))-3, sprintf('%.0f', data(i, j)), 'FontSize', 20, 'Color', 'k', 'fontname', 'Arial');
            end
    end
end
xticklabels({'VEGFR1', 'VEGFR2', 'NRP1', 'PDGFR\alpha', 'PDGFR\beta'});
xlim([0 6])
ylim([0 100])
ylabel('Percentage (%)')
legend('Free', 'Bound', 'Location', 'northeastoutside', 'fontname', 'Arial')
set(gca, 'fontsize', 25, 'fontname', 'Arial')
saveas(gca, sprintf('%s/Receptor_free_VS_bound', result_foldername), 'png')
saveas(gca, sprintf('%s/Receptor_free_VS_bound', result_foldername), 'epsc')

%% Calculate the proportion of ligand occuping each receptor
lig_R1 = [result.VA_R1(end), result.VB_R1(end), result.Pl_R1(end), 0, 0, 0];
lig_R2 = [result.VA_R2(end) + result.VA_R2_N1(end), 0, 0, result.PDAA_R2(end), result.PDAB_R2(end), result.PDBB_R2(end)];
lig_N1 = [result.VA_N1(end) + result.VA_R2_N1(end), result.VB_N1(end), result.Pl_N1(end), 0, 0, 0];
lig_PDRa = [result.VA_PDRa(end), 0, 0, result.PDAA_PDRa(end), result.PDAB_PDRa(end), result.PDBB_PDRa(end)];
lig_PDRb = [result.VA_PDRb(end), 0, 0, 0, result.PDAB_PDRb(end), result.PDBB_PDRb(end)];

%% Generate data for plot
data = [lig_R1/sum(lig_R1) * 100; ...
        lig_R2/sum(lig_R2) * 100; ...
        lig_N1/sum(lig_N1) * 100; ...
        lig_PDRa/sum(lig_PDRa) * 100; ...
        lig_PDRb/sum(lig_PDRb) * 100];

%% Plot figure
figure('Position', [10 10 1200 500]);
b = bar(1:5, data, 'stacked', 'EdgeColor', 'none', 'BarWidth', 0.5);
for i = 1:length(color_lig)
    b(i).FaceColor = color_lig{i};
end
xticklabels({'VEGFR1', 'VEGFR2', 'NRP1', 'PDGFR\alpha', 'PDGFR\beta'});
xlim([0 6])
ylim([0 100])
ylabel('Percentage (%)')
legend('VEGF-A', 'VEGF-B', 'PlGF', 'PDGF-AA', 'PDGF-AB', 'PDGF-BB', 'Location', 'northeastoutside', 'fontname', 'Arial')
set(gca, 'fontsize', 25, 'fontname', 'Arial')
saveas(gca, sprintf('%s/Receptor_ligand_dist', result_foldername), 'png')
saveas(gca, sprintf('%s/Receptor_ligand_dist', result_foldername), 'epsc')

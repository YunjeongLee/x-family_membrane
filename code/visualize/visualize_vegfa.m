function [] = visualize_vegfa(time_stamp, params_struct, result)
%% VEGF-A:VEGFR1
assoc_VAR1 = params_struct.konVAR1 .* result.VA .* result.R1;
dissoc_VAR1 = params_struct.koffVAR1 * result.VA_R1;

%% VEGF-A:VEGFR2
assoc_VAR2 = params_struct.konVAR2 .* result.VA .* result.R2;
dissoc_VAR2 = params_struct.koffVAR2 * result.VA_R2;

%% VEGF-A:NRP1
assoc_VAN1 = params_struct.konVAN1 .* result.VA .* result.N1;
dissoc_VAN1 = params_struct.koffVAN1 * result.VA_N1;

%% VEGF-A:PDGFRa
assoc_VAPDRa = params_struct.konVAPDRa .* result.VA .* result.PDRa;
dissoc_VAPDRa = params_struct.koffVAPDRa .* result.VA_PDRa;

%% VEGF-A:PDGFRb
assoc_VAPDRb = params_struct.konVAPDRb .* result.VA .* result.PDRb;
dissoc_VAPDRb = params_struct.koffVAPDRb .* result.VA_PDRb;

%% Visualization
figure('Position', [10 10 1600 400]);
subplot(1, 2, 1)
semilogy(time_stamp/3600, assoc_VAR1, 'linewidth', 3)
hold on;
semilogy(time_stamp/3600, assoc_VAR2, 'linewidth', 3)
semilogy(time_stamp/3600, assoc_VAN1, 'linewidth', 3)
semilogy(time_stamp/3600, assoc_VAPDRa, 'linewidth', 3)
semilogy(time_stamp/3600, assoc_VAPDRb, 'linewidth', 3)
hold off;
xlabel('Time (hour)')
ylabel('M')
legend('VEGFR1', 'VEGFR2', 'NRP1', 'PDGFR\alpha', 'PDGFR\beta', ...
       'Location', 'northeastoutside')
title('Association of VEGF-A')
set(gca, 'fontsize', 20)

subplot(1, 2, 2)
semilogy(time_stamp/3600, dissoc_VAR1, 'linewidth', 3)
hold on;
semilogy(time_stamp/3600, dissoc_VAR2, 'linewidth', 3)
semilogy(time_stamp/3600, dissoc_VAN1, 'linewidth', 3)
semilogy(time_stamp/3600, dissoc_VAPDRa, 'linewidth', 3)
semilogy(time_stamp/3600, dissoc_VAPDRb, 'linewidth', 3)
hold off;
xlabel('Time (hour)')
ylabel('M')
legend('VEGFR1', 'VEGFR2', 'NRP1', 'PDGFR\alpha', 'PDGFR\beta', ...
       'Location', 'northeastoutside')
title('Dissociation of VEGF-A')
set(gca, 'fontsize', 20)

%% Merge association and dissociation
figure('Position', [10 10 800 400])
hold on;
plot(time_stamp/3600, assoc_VAR1 - dissoc_VAR1, 'LineWidth', 3)
plot(time_stamp/3600, assoc_VAR2 - dissoc_VAR2, 'LineWidth', 3)
plot(time_stamp/3600, assoc_VAN1 - dissoc_VAN1, 'LineWidth', 3)
plot(time_stamp/3600, assoc_VAPDRa - dissoc_VAPDRa, 'LineWidth', 3)
plot(time_stamp/3600, assoc_VAPDRb - dissoc_VAPDRb, 'LineWidth', 3)
hold off;
xlabel('Time (hour)')
ylabel('M')
legend('VEGFR1', 'VEGFR2', 'NRP1', 'PDGFR\alpha', 'PDGFR\beta', ...
       'Location', 'northeastoutside')
title('Association - Dissociation')
set(gca, 'fontsize', 20)

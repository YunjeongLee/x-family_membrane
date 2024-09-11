function [] = visualize_assoc_dissoc(data, default, xrange, color, ttl, xtick, xlabels, lgd, filenames)
%% Plot dynamics of association and dissociation
figure('Position', [10 10 900 400]);
hold on;
area(xrange, - data{1} + data{2}, 'EdgeColor', 'none')
colororder(color)
xline(default, 'LineWidth', 3, 'LineStyle', ':');
hold off;
xlabel(sprintf('[%s] (rec/cell)', xlabels))
ylabel('M/s')
title('- Association + dissociation')
legend(lgd, 'Location', 'northeastoutside')
set(gca, 'fontsize', 25);
saveas(gca, filenames{1}, 'epsc')
saveas(gca, filenames{1}, 'png')

%% Plot proportion of association and dissociation
% Calculate proportion
prop = {};
for i = 1:size(data, 2)
    prop{end+1} = data{i}./sum(data{i}, 2) * 100;
end

figure('Position', [10 10 1600 400]);
for i = 1:size(data, 2)
    subplot(1, 2, i);
    hold on;
    area(xrange, prop{i}, 'EdgeColor', 'none');
    colororder(color)
    xline(default, 'LineWidth', 3, 'LineStyle', ':');
    hold off;
    xlabel(sprintf('[%s] (rec/cell)', xlabels))
    ylabel('Proportion (%)')
    ylim([0 100])
    xtickformat('%,g')
    title(ttl{i})
    legend(lgd, 'Location', 'northeastoutside')
    set(gca, 'fontsize', 25, 'xtick', xtick)
end
saveas(gca, filenames{2}, 'epsc')
saveas(gca, filenames{2}, 'png')

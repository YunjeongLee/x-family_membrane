function [] = visualize_free_lig(data, default, xrange, color, ttl, xtick, xlabels, lgd, filename)
figure('Position', [10 10 1600 500]);
for i = 1:size(data, 2)
    subplot(2, 3, i);
    hold on;
    area(xrange, data(:, i), 'EdgeColor', 'none', 'facecolor', color{i});
    colororder(color{i});
    xline(default, 'LineWidth', 3, 'LineStyle', ':');
    hold off;
    xlabel(sprintf('[%s] (rec/cell)', xlabels), 'fontname', 'Arial')
    ylabel('pM', 'fontname', 'Arial')
    xtickformat('%,g')
    title(ttl{i}, 'fontname', 'Arial')
    legend(lgd, 'Location', 'northeastoutside', 'fontname', 'Arial')
    set(gca, 'fontsize', 15, 'xtick', xtick, 'fontname', 'Arial')
end
saveas(gca, filename, 'epsc')
saveas(gca, filename, 'png')

function [] = visualize_stack_area(data, default, xrange, color, ttl, xtick, xlabels, lgd, filename)
figure('Position', [10 10 1600 500]);
for i = 1:size(data, 3)
    subplot(2, 3, i);
    hold on;
    area(xrange, data(:, :, i), 'EdgeColor', 'none');
    colororder(color);
    xline(default, 'LineWidth', 3, 'LineStyle', ':');
    hold off;
    xlabel(sprintf('[%s] (rec/cell)', xlabels))
    ylabel('Percentage (%)')
    ylim([0 100])
    xtickformat('%,g')
    title(ttl{i}, 'fontname', 'Arial')
    legend(lgd, 'Location', 'northeastoutside', 'fontname', 'Arial')
    set(gca, 'fontsize', 15, 'xtick', xtick, 'fontname', 'Arial')
end
saveas(gca, filename, 'epsc')
saveas(gca, filename, 'png')

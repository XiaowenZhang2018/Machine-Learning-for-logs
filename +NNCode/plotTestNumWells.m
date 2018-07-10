function plotTestNumWells(s_allRes)

% Retrieve some useful data
nPts = length(s_allRes);
trainColor = 'r';
testColor = 'b';

%%%% RMSD -----------------------------------------------------------------
fRMSD = figure;
ax = axes;
titleStr = ['RMSD: ' s_allRes(1).outputLog ' from '];
for ii = 1:length(s_allRes(1).inputLogs)
    titleStr = [titleStr s_allRes(1).inputLogs{ii} ', '];
end
ax.Title.String = titleStr(1:end-2);
ax.XLim = [0, nPts+1];
ax.XLabel.String = 'Number of Wells in Training Set';
ax.YLabel.String = 'RMSD';

hold on;

% Errorbar, Training Set
lineRMSDTrain = errorbar(ax, 1:nPts, [s_allRes.avg_rmsd_train], [s_allRes.std_rmsd_train], ...
    '-s', 'MarkerSize', 6, ...
    'Color', trainColor, 'MarkerEdgeColor', trainColor, 'MarkerFaceColor', trainColor);


% Errorbar, Test Set
lineRMSDTest = errorbar(ax, 1:nPts, [s_allRes.avg_rmsd_test], [s_allRes.std_rmsd_test], ...
    '-s', 'MarkerSize', 6,...
    'Color', testColor, 'MarkerEdgeColor', testColor, 'MarkerFaceColor', testColor);

% Add legend to plot
legend('Training Set', 'Test Set');

% Save figure as image
saveas(fRMSD, 'RMSD.png')


%%%% R2 -------------------------------------------------------------------
fR2 = figure;
ax = axes;
titleStr = ['R2:' titleStr(6:end)];
ax.Title.String = titleStr;
ax.XLim = [0, nPts+1];
ax.XLabel.String = 'Number of Wells in Training Set';
ax.YLabel.String = 'R2';

hold on;

% Errorbar, Training Set
lineR2Train = errorbar(ax, 1:nPts, [s_allRes.avg_r2_train], [s_allRes.std_r2_train], ...
    '-s', 'MarkerSize', 6, ...
    'Color', trainColor, 'MarkerEdgeColor', trainColor, 'MarkerFaceColor', trainColor);


% Errorbar, Test Set
lineR2Test = errorbar(ax, 1:nPts, [s_allRes.avg_r2_test], [s_allRes.std_r2_test], ...
    '-s', 'MarkerSize', 6,...
    'Color', testColor, 'MarkerEdgeColor', testColor, 'MarkerFaceColor', testColor);

% Add legend to plot
legend('Training Set', 'Test Set');

% Save figure as image
saveas(fR2, 'R2.png')

end
function fh = display_sliceLine_profile(profiTime, height, CH1_Sig_Profi, CH1_BG_Profi, CH2_Sig_Profi, CH2_BG_Profi, elSig_Profi, VDR_Profi, Temp_Profi, Pres_Profi, RH_Profi, varargin)

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'profiTime', @isnumeric);
addRequired(p, 'height', @isnumeric);
addRequired(p, 'CH1_Sig_Profi', @isnumeric);
addRequired(p, 'CH1_BG_Profi', @isnumeric);
addRequired(p, 'CH2_Sig_Profi', @isnumeric);
addRequired(p, 'CH2_BG_Profi', @isnumeric);
addRequired(p, 'elSig_Profi', @isnumeric);
addRequired(p, 'VDR_Profi', @isnumeric);
addRequired(p, 'Temp_Profi', @isnumeric);
addRequired(p, 'Pres_Profi', @isnumeric);
addRequired(p, 'RH_Profi', @isnumeric);
addParameter(p, 'RCS_Scale', 'linear', @ischar);
addParameter(p, 'RCS_Range', [0, 1e10], @isnumeric);
addParameter(p, 'hRange', [0, 30], @isnumeric);
addParameter(p, 'VDR_Range', [0, 0.3], @isnumeric);
addParameter(p, 'Temp_Range', [-60, 0], @isnumeric);
addParameter(p, 'RH_Range', [0, 100], @isnumeric);
addParameter(p, 'Sig_Range', [1e-4, 1e5], @isnumeric);

parse(p, profiTime, height, CH1_Sig_Profi, CH1_BG_Profi, CH2_Sig_Profi, CH2_BG_Profi, elSig_Profi, VDR_Profi, Temp_Profi, Pres_Profi, RH_Profi, varargin{:});

figure('Name', sprintf('Profile: %s', datestr(profiTime, 'yyyy-mm-dd HH:MM:SS')), 'Position', [20, 500, 800, 400], 'Units', 'Pixels', 'Color', 'w');

subPos = subfigPos([0.05, 0.11, 0.92, 0.8], 1, 4, 0.02, 0);

% signal
subplot('Position', subPos(1, :), 'Units', 'Normalized');
CH1_Sig_Profi(CH1_Sig_Profi <= 0) = NaN;
CH2_Sig_Profi(CH2_Sig_Profi <= 0) = NaN;
CH1_BG_Profi(CH1_BG_Profi <= 0) = NaN;
CH2_BG_Profi(CH2_BG_Profi <= 0) = NaN;
p1 = semilogx(CH1_Sig_Profi, height, '-', 'Color', 'b', 'LineWidth', 1, 'DisplayName', 'CH1 Sig');
hold on;
p2 = semilogx(CH2_Sig_Profi, height, '-', 'Color', 'r', 'LineWidth', 1, 'DisplayName', 'CH2 Sig');
p3 = semilogx(CH1_BG_Profi, height, '--', 'Color', 'b', 'LineWidth', 1, 'DisplayName', 'CH2 BG');
p4 = semilogx(CH2_BG_Profi, height, '--', 'Color', 'r', 'LineWidth', 1, 'DisplayName', 'CH2 BG');

xlim(p.Results.Sig_Range);
ylim(p.Results.hRange);

xlabel('Signal (MHz)');
ylabel('Height (km)');

legend([p1, p2, p3, p4], 'Location', 'NorthEast');

set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', 'Box', 'on', 'LineWidth', 2);

% range-corrected signal
subplot('Position', subPos(2, :), 'Units', 'Normalized');

if strcmpi(p.Results.RCS_Scale, 'log')
    elSig_Profi(elSig_Profi <= 0) = NaN;

    semilogx(elSig_Profi, height, '-k', 'LineWidth', 1); hold on;
else
    plot(elSig_Profi, height, '-k', 'LineWidth', 1); hold on;
end

xlim(p.Results.RCS_Range);
ylim(p.Results.hRange);

xlabel('range-cor. signal');
ylabel('');

set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', 'YTickLabel', '', 'Box', 'on', 'LineWidth', 2, 'TickLength', [0.02, 0.01]);

% volume depolarization ratio
subplot('Position', subPos(3, :), 'Units', 'Normalized');

plot(VDR_Profi, height, '-g', 'LineWidth', 1); hold on;

xlim(p.Results.VDR_Range);
ylim(p.Results.hRange);

xlabel('vol. depol.');
ylabel('');

set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', 'YTickLabel', '', 'Box', 'on', 'LineWidth', 2);

% RH and temperature
subplot('Position', subPos(4, :), 'Units', 'Normalized');

line(Temp_Profi, height, 'color', 'r', 'LineWidth', 1);
ax1 = gca;
ax1.XLim = p.Results.Temp_Range;
ax1.YLim = p.Results.hRange;
ax1.XLabel.String = 'Temperature (\circC)';
ax1.YLabel.String = '';
ax1.FontSize = 11;
ax1.YLabel.FontSize = 10;
ax1.XLabel.FontSize = 10;
ax1.XColor = 'k';
ax1.YColor = 'k';
set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', 'YTickLabel', '', 'Box', 'on', 'LineWidth', 2);

ax1_pos = ax1.Position;
ax2 = axes('Position', ax1_pos, 'XAxisLocation', 'top', 'YAxisLocation', 'right', 'Color', 'none');
ax2.XColor = 'k';
ax2.YColor = 'k';
ax2.XLim = p.Results.RH_Range;
ax2.YLim = p.Results.hRange;
ax2.XLabel.String = 'RH (%)';
ax2.XLabel.FontSize = 10;
ax2.FontSize = 10;
ax2.YTick = [];
line(RH_Profi, height, 'Parent', ax2, 'color', 'b', 'LineWidth', 2);

set(gca, 'XMinorTick', 'on', 'YMinorTick', 'on', 'YTickLabel', '', 'Box', 'on', 'LineWidth', 2);

% annotations
text(-1.1, 1.05, sprintf('%s', datestr(profiTime, 'yyyy-mm-dd HH:MM:SS')), 'units', 'Normalized', 'FontSize', 12, 'HorizontalAlignment', 'center', 'FontWeight', 'Bold');

set(findall(gcf, '-Property', 'FontName'), 'FontName', 'Times New Roman');

end
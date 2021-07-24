function [fh] = display_depol_profi(ax, height, VDR, PDR, varargin)
% DISPLAY_DEPOL_PROFI display particle backscatter profile.
% Example:
%    [fh] = display_depol_profi(ax, height, VDR, PDR, varargin)
% Inputs:
%    ax: axes
%        axes handle.
%    height: array
%        height above ground. (km)
%    VDR: array
%        volume depolarization ratio.
%    PDR: array
%        particle depolarization ratio.
% Keywords:
%    hRange: 2-element array
%        spatial range. (km)
%    DepolRange: 2-element array
%        depolarization range.
%    LBH: numeric
%        layer base height. (km)
%    LTH: numeric
%        layer top height. (km)
% Outputs:
%    fh: figure
%        figure handle.
% History:
%    2020-05-28. First Edition by Zhenping
% Contact:
%    zp.yin@whu.edu.cn

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'ax');
addRequired(p, 'height', @isnumeric);
addRequired(p, 'VDR', @isnumeric);
addRequired(p, 'PDR', @isnumeric);
addParameter(p, 'hRange', [0, 1000], @isnumeric);
addParameter(p, 'DepolRange', [0, 0.3], @isnumeric);
addParameter(p, 'LBH', [], @isnumeric);
addParameter(p, 'LTH', [], @isnumeric);

parse(p, ax, height, VDR, PDR, varargin{:});

axes(ax);

% linear scale
p1 = plot(VDR, height, 'Color', 'g', 'LineWidth', 2, 'DisplayName', '\delta_v');
hold on;
p2 = plot(PDR, height, 'Color', 'b', 'LineWidth', 2, 'DisplayName', '\delta_p');

if ~ isempty(p.Results.LBH)
    plot(p.Results.DepolRange, [p.Results.LBH, p.Results.LBH], '--k', 'LineWidth', 2);
end

if ~ isempty(p.Results.LTH)
    plot(p.Results.DepolRange, [p.Results.LTH, p.Results.LTH], '--k', 'LineWidth', 2);
end

hold off;

xlabel('');
ylabel('');
title('depol. ratio.');

xlim(p.Results.DepolRange);
ylim(p.Results.hRange);

legend([p1, p2], 'Location', 'NorthEast');

set(gca, 'XMinorTick', 'on', ...
    'XTick', linspace(p.Results.DepolRange(1), p.Results.DepolRange(end), 5), ...
    'YMinorTick', 'on', ...
    'YTick', linspace(p.Results.hRange(1), p.Results.hRange(end), 5), ...
    'YTickLabel', '', 'Box', 'on', 'LineWidth', 2, 'TickDir', 'in', ...
    'TickLength', [0.02, 0.02], 'layer', 'top');

end
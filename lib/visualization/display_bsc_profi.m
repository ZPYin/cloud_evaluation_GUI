function [fh] = display_bsc_profi(ax, height, aerBsc, varargin)
% DISPLAY_BSC_PROFI display particle backscatter profile.
% Example:
%    [fh] = display_bsc_profi(ax, height, aerBsc, varargin)
% Inputs:
%    ax: axes
%        axes handle.
%    height: array
%        height above ground. (km)
%    aerBsc: array
%        particle backscatter. (Mm-1sr-1)
% Keywords:
%    hRange: 2-element array
%        spatial range. (km)
%    aerBscRange: 2-element array
%        particle backscatter range. (Mm-1sr-1)
%    LBH: numeric
%        layer base height. (km)
%    LTH: numeric
%        layer top height. (km)
%    dustBsc: array
%        dust backscatter. (Mm-1sr-1)
%    nondustBsc: array
%        non-dust backscatter. (Mm-1sr-1)
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
addRequired(p, 'aerBsc', @isnumeric);
addParameter(p, 'hRange', [0, 1000], @isnumeric);
addParameter(p, 'aerBscRange', [0, 5], @isnumeric);
addParameter(p, 'LBH', [], @isnumeric);
addParameter(p, 'LTH', [], @isnumeric);
addParameter(p, 'dustBsc', NaN(size(height)), @isnumeric);
addParameter(p, 'nondustBsc', NaN(size(height)), @isnumeric);

parse(p, ax, height, aerBsc, varargin{:});

axes(ax);

% linear scale
p1 = plot(aerBsc, height, 'Color', 'b', 'LineWidth', 2, 'DisplayName', 'Total');
hold on;

p2 = plot(p.Results.dustBsc, height, 'Color', 'y', 'LineStyle', '--', 'LineWidth', 2, 'DisplayName', 'dust');
p3 = plot(p.Results.nondustBsc, height, 'Color', 'm', 'LineStyle', '--', 'LineWidth', 2, 'DisplayName', 'non-dust');

if ~ isempty(p.Results.LBH)
    plot(p.Results.aerBscRange, [p.Results.LBH, p.Results.LBH], '--k', 'LineWidth', 2);
end

if ~ isempty(p.Results.LTH)
    plot(p.Results.aerBscRange, [p.Results.LTH, p.Results.LTH], '--k', 'LineWidth', 2);
end

hold off;

xlabel('');
ylabel('');
title('par. backs. (Mm-1*sr-1)');

xlim(p.Results.aerBscRange);
ylim(p.Results.hRange);

legend([p1, p2, p3], 'Location', 'NorthEast');

set(gca, 'XMinorTick', 'on', ...
    'XTick', linspace(p.Results.aerBscRange(1), p.Results.aerBscRange(end), 5), ...
    'YMinorTick', 'on', ...
    'YTick', linspace(p.Results.hRange(1), p.Results.hRange(end), 5), ...
    'YTickLabel', '', 'Box', 'on', 'LineWidth', 2, 'TickDir', 'in', ...
    'TickLength', [0.02, 0.02], 'layer', 'top');

end
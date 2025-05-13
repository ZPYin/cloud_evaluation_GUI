function [fh] = display_RH_profi(ax, height, RH, varargin)
% DISPLAY_RH_PROFI display relative humidity profile.
%
% USAGE:
%    [fh] = display_RH_profi(ax, height, RH, varargin)
%
% INPUTS:
%    ax: axes
%        axes handle.
%    height: array
%        height above ground. (km)
%    RH: array
%        relative humidity. (%)
%
% KEYWORDS:
%    hRange: 2-element array
%        spatial range. (km)
%    RHRange: 2-element array
%        relative humidity range.
%    CBH: numeric
%        cloud base height. (km)
%    CTH: numeric
%        cloud top height. (km)
%    CTT: numeric
%        cloud top temperature. (celsius)
%
% OUTPUTS:
%    fh: figure
%        figure handle.
%
% HISTORY:
%    2020-05-28: first edition by Zhenping
% .. Authors: - zp.yin@whu.edu.cn

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'ax');
addRequired(p, 'height', @isnumeric);
addRequired(p, 'RH', @isnumeric);
addParameter(p, 'hRange', [0, 1000], @isnumeric);
addParameter(p, 'RHRange', [0, 100], @isnumeric);
addParameter(p, 'CBH', NaN, @isnumeric);
addParameter(p, 'CTH', NaN, @isnumeric);
addParameter(p, 'CTT', NaN, @isnumeric);

parse(p, ax, height, RH, varargin{:});

axes(ax);

% linear scale
p1 = plot(RH, height, 'Color', 'b', 'LineWidth', 2);
hold on;

if ~ isempty(p.Results.CBH)
    plot(p.Results.RHRange, [p.Results.CBH, p.Results.CBH], '--m', 'LineWidth', 2);
end

if ~ isempty(p.Results.CTH)
    plot(p.Results.RHRange, [p.Results.CTH, p.Results.CTH], '--m', 'LineWidth', 2);
end

if (~ isempty(p.Results.CTT)) && (~ isempty(p.Results.CTH))
    text(mean(p.Results.RHRange), p.Results.CTH, sprintf('%5.1f \\circC', p.Results.CTT), 'Color', 'r', 'FontWeight', 'Bold', 'Units', 'Data');
end

hold off;

xlabel('');
ylabel('');
title('Relative humidity (%)');

xlim(p.Results.RHRange);
ylim(p.Results.hRange);

set(gca, 'XMinorTick', 'on', ...
    'XTick', linspace(p.Results.RHRange(1), p.Results.RHRange(end), 5), ...
    'YMinorTick', 'on', ...
    'YTick', linspace(p.Results.hRange(1), p.Results.hRange(end), 5), ...
    'YTickLabel', '', 'Box', 'on', 'LineWidth', 2, 'TickDir', 'in', ...
    'TickLength', [0.02, 0.02], 'layer', 'top');

end
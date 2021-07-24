function [fh] = display_mass_profi(ax, height, mass_nd, mass_d, varargin)
% DISPLAY_MASS_PROFI display mass concentration profile.
% Example:
%    [fh] = display_mass_profi(ax, height, mass_nd, mass_d, varargin)
% Inputs:
%    ax: axes
%        axes handle.
%    height: array
%        height above ground. (km)
%    mass_nd: array
%        non-dust mass conc. (ug*m-3)
%    mass_d: array
%        dust mass conc. (ug*m-3)
% Keywords:
%    hRange: 2-element array
%        spatial range. (km)
%    massRange: 2-element array
%        range for mass concentration. (ug*m-3)
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
addRequired(p, 'mass_nd', @isnumeric);
addRequired(p, 'mass_d', @isnumeric);
addParameter(p, 'hRange', [0, 1000], @isnumeric);
addParameter(p, 'massRange', [0, 500], @isnumeric);
addParameter(p, 'LBH', [], @isnumeric);
addParameter(p, 'LTH', [], @isnumeric);

parse(p, ax, height, mass_nd, mass_d, varargin{:});

axes(ax);

% linear scale
p1 = plot(mass_nd, height, 'Color', 'm', 'LineWidth', 2, 'DisplayName', 'non-dust');
hold on;
p2 = plot(mass_d, height, 'Color', 'y', 'LineWidth', 2, 'DisplayName', 'dust');

if ~ isempty(p.Results.LBH)
    plot(p.Results.massRange, [p.Results.LBH, p.Results.LBH], '--k', 'LineWidth', 2);
end

if ~ isempty(p.Results.LTH)
    plot(p.Results.massRange, [p.Results.LTH, p.Results.LTH], '--k', 'LineWidth', 2);
end

hold off;

ylabel('');
title('mass conc. (ug*m-3)');

xlim(p.Results.massRange);
ylim(p.Results.hRange);

legend([p1, p2], 'Location', 'NorthEast');

set(gca, 'XMinorTick', 'on', ...
    'XTick', linspace(p.Results.massRange(1), p.Results.massRange(end), 5), ...
    'YMinorTick', 'on', ...
    'YTick', linspace(p.Results.hRange(1), p.Results.hRange(end), 5), ...
    'YTickLabel', '', ...
    'Box', 'on', 'LineWidth', 2, 'TickDir', 'in', ...
    'TickLength', [0.02, 0.02], 'layer', 'top');

end
function [fh] = display_Temp_profi(ax, height, Temp, varargin)
%display_Temp_profi display temperature profile.
%Example:
%   [fh] = display_Temp_profi(ax, height, Temp, varargin)
%Inputs:
%   ax: axes
%       axes handle.
%   height: array
%       height above ground. (km)
%   Temp: array
%       temperature. (degree celsius)
%Keywords:
%   hRange: 2-element array
%       spatial range. (km)
%   TempRange: 2-element array
%       temperature range.
%   CBH: numeric
%       cloud base height. (km)
%   CTH: numeric
%       cloud top height. (km)
%   CTT: numeric
%       cloud top temperature. (celsius)
%Outputs:
%   fh: figure
%       figure handle.
%History:
%   2020-05-28. First Edition by Zhenping
%Contact:
%   zp.yin@whu.edu.cn

p = inputParser;
p.KeepUnmatched = true;

addRequired(p, 'ax');
addRequired(p, 'height', @isnumeric);
addRequired(p, 'Temp', @isnumeric);
addParameter(p, 'hRange', [0, 1000], @isnumeric);
addParameter(p, 'TempRange', [-40, 30], @isnumeric);
addParameter(p, 'CBH', NaN, @isnumeric);
addParameter(p, 'CTH', NaN, @isnumeric);
addParameter(p, 'CTT', NaN, @isnumeric);

parse(p, ax, height, Temp, varargin{:});

axes(ax);

% linear scale
p1 = plot(Temp, height, 'Color', 'b', 'LineWidth', 2);
hold on;

if ~ isempty(p.Results.CBH)
    plot(p.Results.TempRange, [p.Results.CBH, p.Results.CBH], '--k', 'LineWidth', 2);
end

if ~ isempty(p.Results.CTH)
    plot(p.Results.TempRange, [p.Results.CTH, p.Results.CTH], '--k', 'LineWidth', 2);
end

if (~ isempty(p.Results.CTT)) && (~ isempty(p.Results.CTH))
    text(mean(p.Results.TempRange), p.Results.CTH, sprintf('%5.1f \\circC', p.Results.CTT), 'Color', 'r', 'FontWeight', 'Bold', 'Units', 'Data');
end

hold off;

xlabel('');
ylabel('');
title('Temperature (\circC)');

xlim(p.Results.TempRange);
ylim(p.Results.hRange);

set(gca, 'XMinorTick', 'on', ...
    'XTick', linspace(p.Results.TempRange(1), p.Results.TempRange(end), 5), ...
    'YMinorTick', 'on', ...
    'YTick', linspace(p.Results.hRange(1), p.Results.hRange(end), 5), ...
    'YTickLabel', '', 'Box', 'on', 'LineWidth', 2, 'TickDir', 'in', ...
    'TickLength', [0.02, 0.02]);

end
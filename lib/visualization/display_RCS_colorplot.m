function [fh] = display_RCS_colorplot(ax, mTime, height, RCS, varargin)
%display_RCS_colorplot display range corrected signal colorplot.
%Example:
%   [fh] = display_RCS_colorplot(ax, mTime, height, RCS, varargin)
%Inputs:
%   ax: axes
%       axes handle.
%   mTime: array
%       measurement time.
%   height: array
%       height above ground. (km)
%   RCS: matrix (height * time)
%       range corrected signal.
%Keywords:
%   scale: char
%       'linear' or 'log'
%   tRange: 2-element array
%       temporal range.
%   hRange: 2-element array
%       spatial range. (km)
%   cRange: 2-element array
%       color range for range corrected signal.
%   Temp: matrix (height * time)
%       temperature data. (celsius)
%   CBH: numeric
%       cloud base height. (km)
%   CTH: numeric
%       cloud top height. (km)
%   CTT: numeric
%       cloud top temperature. (celsius)
%   cloud_starttime: numeric
%       start time of the cloud contaminated profile.
%   cloud_stoptime: numeric
%       stop time of the cloud contaminated profile.
%   ret_starttime: numeric
%       start time of the averaged region.
%   ret_stoptime: numeric
%       stop time of the averaged region.
%   ret_bottom: numeric
%       bottom of the averaged region. (km)
%   ret_top: numeric
%       top of the averaged region. (km)
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
addRequired(p, 'mTime', @isnumeric);
addRequired(p, 'height', @isnumeric);
addRequired(p, 'RCS', @isnumeric);
addParameter(p, 'scale', 'linear', @ischar);
addParameter(p, 'tRange', [0, 1], @isnumeric);
addParameter(p, 'hRange', [0, 1000], @isnumeric);
addParameter(p, 'cRange', [0, 1e12], @isnumeric);
addParameter(p, 'Temp', [], @isnumeric);
addParameter(p, 'CBH', NaN, @isnumeric);
addParameter(p, 'CTH', NaN, @isnumeric);
addParameter(p, 'CTT', NaN, @isnumeric);
addParameter(p, 'cloud_starttime', NaN, @isnumeric);
addParameter(p, 'cloud_stoptime', NaN, @isnumeric);
addParameter(p, 'ret_starttime', NaN, @isnumeric);
addParameter(p, 'ret_stoptime', NaN, @isnumeric);
addParameter(p, 'ret_bottom', NaN, @isnumeric);
addParameter(p, 'ret_top', NaN, @isnumeric);

parse(p, ax, mTime, height, RCS, varargin{:});

axes(ax);

if strcmpi(p.Results.scale, 'linear')
    % linear scale
    p1 = pcolor(mTime, height, RCS);
    p1.EdgeColor = 'None';
    hold on;

    caxis(p.Results.cRange)
elseif strcmpi(p.Results.scale, 'log')
    % logarithm scale
    RCS(RCS <= 0) = NaN;
    p1 = pcolor(mTime, height, log10(RCS));
    p1.EdgeColor = 'None';
    hold on;

    caxis(log10(p.Results.cRange));
else
    error('Wrong range corrected signal scale mode');
end

if (~ isempty(p.Results.Temp)) && (numel(p.Results.Temp) == numel(RCS)) && ...
    (any(any((~ isnan(p.Results.Temp)), 1), 2))
    [c1, h] = contour(mTime, height, p.Results.Temp, [0, -40.0], ...
                      'LineColor', 'm', 'LineWidth', 2, 'LineStyle', '--');
    clabel(c1, h, 'FontSize', 10, 'Color', 'm', 'FontWeight', 'bold');
end

if (~ isnan(p.Results.cloud_starttime)) && (~ isnan(p.Results.cloud_stoptime)) && (~ isnan(p.Results.CBH)) && (~ isnan(p.Results.CTH))
    rectangle('Position', [p.Results.cloud_starttime, p.Results.CBH, (p.Results.cloud_stoptime - p.Results.cloud_starttime), (p.Results.CTH - p.Results.CBH)], 'EdgeColor', 'w', 'LineWidth', 2, 'LineStyle', '--', 'FaceColor', 'none');
end

if (~ isempty(p.Results.CTT)) && (~ isempty(p.Results.CTH))
    text(mean([p.Results.cloud_starttime, p.Results.cloud_stoptime]), p.Results.CTH, sprintf('%5.1f \\circC', p.Results.CTT), 'Color', 'r', 'FontWeight', 'Bold', 'Units', 'Data');
end

if (~ isnan(p.Results.ret_starttime)) && (~ isnan(p.Results.ret_stoptime)) && (~ isnan(p.Results.ret_bottom)) && (~ isnan(p.Results.ret_top))
    rectangle('Position', [p.Results.ret_starttime, p.Results.ret_bottom, (p.Results.ret_stoptime - p.Results.ret_starttime), (p.Results.ret_top - p.Results.ret_bottom)], 'EdgeColor', 'y', 'LineWidth', 2, 'LineStyle', '--', 'FaceColor', 'none');
end

hold off;

xlabel('');
ylabel('Height (km)');
title('range-corrected signal @ 532 nm');

xlim(p.Results.tRange);
ylim(p.Results.hRange);

load('myjet_colormap.mat');
colormap(myjet);

set(gca, 'XMinorTick', 'on', ...
    'XTick', linspace(p.Results.tRange(1), p.Results.tRange(end), 5), ...
    'YMinorTick', 'on', ...
    'YTick', linspace(p.Results.hRange(1), p.Results.hRange(end), 5), ...
    'Box', 'on', 'LineWidth', 2, 'TickDir', 'out', ...
    'TickLength', [0.015, 0.015]);
ax.XAxis.MinorTickValues = linspace(p.Results.tRange(1), p.Results.tRange(end), 25);

datetick(gca, 'x', 'HH:MM', 'KeepTicks', 'KeepLimits');

cb = colorbar('Position', [0.692, 0.698, 0.01, 0.2], 'Units', 'Normalized');
titleHandle = get(cb, 'Title');
set(titleHandle, 'String', '[a.u.]');
set(cb, 'TickDir', 'in', 'Box', 'on', 'TickLength', 0.02);

end
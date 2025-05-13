function [fh] = display_RCS_profi(ax, height, RCS, mol_RCS, varargin)
% DISPLAY_RCS_PROFI display range corrected signal profile.
%
% USAGE:
%    [fh] = display_RCS_profi(ax, height, RCS, mol_RCS, varargin)
%
% INPUTS:
%    ax: axes
%        axes handle.
%    height: array
%        height above ground. (km)
%    RCS: array
%        range corrected signal.
%    mol_RCS: array
%        molecular range corrected signal.
%
% KEYWORDS:
%    scale: char
%        'linear' or 'log'
%    hRange: 2-element array
%        spatial range. (km)
%    RCSRange: 2-element array
%        range for range corrected signal.
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
addRequired(p, 'RCS', @isnumeric);
addRequired(p, 'mol_RCS', @isnumeric);
addParameter(p, 'scale', 'linear', @ischar);
addParameter(p, 'hRange', [0, 1000], @isnumeric);
addParameter(p, 'RCSRange', [0, 1e12], @isnumeric);
addParameter(p, 'CBH', NaN, @isnumeric);
addParameter(p, 'CTH', NaN, @isnumeric);
addParameter(p, 'CTT', NaN, @isnumeric);

parse(p, ax, height, RCS, mol_RCS, varargin{:});

axes(ax);

if strcmpi(p.Results.scale, 'linear')
    % linear scale
    p1 = plot(RCS, height, 'Color', 'g', 'LineWidth', 2, 'DisplayName', 'lidar');
    hold on;
    p2 = plot(mol_RCS, height, 'Color', 'b', 'LineStyle', '--', 'LineWidth', 2, 'DisplayName', 'molecule');
elseif strcmpi(p.Results.scale, 'log')
    % logarithm scale
    RCS(RCS <= 0) = NaN;
    mol_RCS(mol_RCS <= 0) = NaN;
    p1 = semilogx(RCS, height, 'Color', 'g', 'LineWidth', 2, 'DisplayName', 'lidar');
    hold on;
    p2 = semilogx(mol_RCS, height, 'Color', 'b', 'LineStyle', '--', 'LineWidth', 2, 'DisplayName', 'molecule');
else
    error('Wrong range corrected signal scale mode');
end

if ~ isempty(p.Results.CBH)
    plot(p.Results.RCSRange, [p.Results.CBH, p.Results.CBH], '--m', 'LineWidth', 2);
end

if ~ isempty(p.Results.CTH)
    plot(p.Results.RCSRange, [p.Results.CTH, p.Results.CTH], '--m', 'LineWidth', 2);
end

if (~ isempty(p.Results.CTT)) && (~ isempty(p.Results.CTH))

    if strcmpi(p.Results.scale, 'linear')
        posAnnotation = mean(p.Results.RCSRange);
    else
        posAnnotation = 10 .^ (mean(log10(p.Results.RCSRange)));
    end

    text(posAnnotation, p.Results.CTH, sprintf('%5.1f \\circC', p.Results.CTT), 'Color', 'r', 'FontWeight', 'Bold', 'Units', 'Data');
end

hold off;

xlabel('');
ylabel('');
title('range-corrected signal');

legend([p1, p2], 'Location', 'NorthEast');

xlim(p.Results.RCSRange);
ylim(p.Results.hRange);

set(gca, 'XMinorTick', 'on', ...
    'YMinorTick', 'on', ...
    'YTick', linspace(p.Results.hRange(1), p.Results.hRange(end), 5), ...
    'Box', 'on', 'LineWidth', 2, 'TickDir', 'in', ...
    'TickLength', [0.02, 0.02], 'layer', 'top');

end
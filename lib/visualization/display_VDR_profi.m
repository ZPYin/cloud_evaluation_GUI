function [fh] = display_VDR_profi(ax, height, VDR, mol_VDR, varargin)
% DISPLAY_VDR_PROFI display volume depolarization ratio profile.
%
% USAGE:
%    [fh] = display_VDR_profi(ax, height, VDR, mol_VDR, varargin)
%
% INPUTS:
%    ax: axes
%        axes handle.
%    height: array
%        height above ground. (km)
%    VDR: array
%        volume depolarization ratio.
%    mol_VDR: array
%        molecular volume depolarization ratio
%
% KEYWORDS:
%    hRange: 2-element array
%        spatial range. (km)
%    VDRRange: 2-element array
%        range for volume depolarization ratio.
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
addRequired(p, 'VDR', @isnumeric);
addRequired(p, 'mol_VDR', @isnumeric);
addParameter(p, 'hRange', [0, 1000], @isnumeric);
addParameter(p, 'VDRRange', [0, 1e12], @isnumeric);
addParameter(p, 'CBH', NaN, @isnumeric);
addParameter(p, 'CTH', NaN, @isnumeric);
addParameter(p, 'CTT', NaN, @isnumeric);

parse(p, ax, height, VDR, mol_VDR, varargin{:});

axes(ax);

% linear scale
p1 = plot(VDR, height, 'Color', 'g', 'LineWidth', 2);
hold on;
p2 = plot(mol_VDR, height, 'Color', 'b', 'LineStyle', '--', 'LineWidth', 2);

if ~ isempty(p.Results.CBH)
    plot(p.Results.VDRRange, [p.Results.CBH, p.Results.CBH], '--m', 'LineWidth', 2);
end

if ~ isempty(p.Results.CTH)
    plot(p.Results.VDRRange, [p.Results.CTH, p.Results.CTH], '--m', 'LineWidth', 2);
end

if (~ isempty(p.Results.CTT)) && (~ isempty(p.Results.CTH))
    text(mean(p.Results.VDRRange), p.Results.CTH, sprintf('%5.1f \\circC', p.Results.CTT), 'Color', 'r', 'FontWeight', 'Bold', 'Units', 'Data');
end

hold off;

xlabel('');
ylabel('');
title('volume depol.');

xlim(p.Results.VDRRange);
ylim(p.Results.hRange);

set(gca, 'XMinorTick', 'on', ...
    'XTick', linspace(p.Results.VDRRange(1), p.Results.VDRRange(end), 5), ...
    'YMinorTick', 'on', ...
    'YTick', linspace(p.Results.hRange(1), p.Results.hRange(end), 5), ...
    'Box', 'on', 'LineWidth', 2, 'TickDir', 'in', ...
    'TickLength', [0.02, 0.02], 'layer', 'top');

end
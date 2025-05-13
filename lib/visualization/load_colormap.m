function [cMaps] = load_colormap(cMapName)
% LOAD_COLORMAP load colormap.
%
% USAGE:
%    [cMaps] = load_colormap(cMapName)
%
% INPUTS:
%    cMapName: char
%    - myjet
%    - chiljet
%    - jet
%    - parula and other matlab built-in colormaps. (see details at MATLAB
%      'colormap' document)
%
% OUTPUTS:
%    cMaps: matrix (nColor * 3)
%        RGB colormap
%
% HISTORY:
%    2020-08-20: first edition by Zhenping
% .. Authors: - zp.yin@whu.edu.cn

switch lower(cMapName)
case 'myjet'

    tmp = load('myjet_colormap.mat', 'myjet');
    cMaps = tmp.myjet;

case 'chiljet'

    tmp = load('chiljet_colormap.mat', 'chiljet');
    cMaps = tmp.chiljet;

otherwise

    cMaps = colormap(cMapName);

end

end
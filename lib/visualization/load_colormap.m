function [cMaps] = load_colormap(cMapName)
% LOAD_COLORMAP load colormap.
% Example:
%    [cMaps] = load_colormap(cMapName)
% Inputs:
%    cMapName: char
%    - myjet
%    - chiljet
%    - jet
%    - parula and other matlab built-in colormaps. (see details at MATLAB
%      'colormap' document)
% Outputs:
%    cMaps: matrix (nColor * 3)
%        RGB colormap
% History:
%    2020-08-20. First Edition by Zhenping
% Contact:
%    zp.yin@whu.edu.cn

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
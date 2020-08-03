function [p1, lh1, lh2]=draw_slice_line(varargin)
% Function to draw a vertical line
% Usage:
%   [p1,p2]=draw_slice_line(h, 'color', 'r');  uses axes refered to by handle, h
% Edited by Zhenping
% 2020-08-03

p = inputParser;
p.KeepUnmatched = true;

addParameter(p, 'ax1', []);
addParameter(p, 'ax2', []);
addParameter(p, 'color', 'r');
addParameter(p, 'hRange', [0, 40], @isnumeric);

parse(p, varargin{:});

p1 = [];
lh1 = [];
lh2 = [];

if isempty(p.Results.ax1) || isempty(p.Results.ax2)
    return;
end

% Get current user data
axes(p.Results.ax1);
cudata = get(gcf, 'UserData'); 
axes(p.Results.ax2);
cudata2 = get(gcf, 'UserData');

axes(p.Results.ax1);
hold on;

% Wait for left mouse button to be pressed
p1 = get(p.Results.ax1, 'CurrentPoint');       %get starting point
p1 = p1(1, 1:2);                   %extract x and y
lh1 = plot([p1(1), p1(1)], p.Results.hRange, 'LineStyle', '-', 'Color', p.Results.color, 'LineWidth', 1);      %plot starting point

% Set gcf object properties 'UserData' and call function 'wbmf' on mouse motion. 
axes(p.Results.ax2);
hold on;
lh2 = plot([p1(1), p1(2)], p.Results.hRange, 'LineStyle', '-', 'Color', p.Results.color, 'LineWidth', 1);

% Save current point (p1) data in a structure to be passed
udata.p1 = p1;
udata.h1 = p.Results.ax1;
udata.lh1 = lh1;
udata.h2 = p.Results.ax2;
udata.lh2 = lh2;
udata.hRange = p.Results.hRange;

axes(p.Results.ax1);
set(gcf, 'UserData', udata, 'WindowButtonMotionFcn', 'wmf_sliceTool', 'DoubleBuffer', 'on');
waitforbuttonpress;

% Get data for the end point
p1 = get(p.Results.ax1, 'Currentpoint');       %get end point
p1 = p1(1, 1:2);                   %extract x and y
set(gcf,'UserData', cudata, 'WindowButtonMotionFcn', '', 'DoubleBuffer', 'off'); %reset UserData, etc..
axes(p.Results.ax2);
set(gcf, 'UserData', cudata2, 'WindowButtonMotionFcn', '', 'DoubleBuffer', 'off'); %reset UserData, etc..

end
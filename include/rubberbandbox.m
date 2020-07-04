function [p1,p2,lh,lh2]=rubberbandbox(varargin)
% Function to draw a rubberband box and return the start and end points
% Usage: [p1,p2]=rubberbox;     uses current axes
%        [p1,p2]=rubberbox(h);  uses axes refered to by handle, h
% Based on an idea of Sandra Martinka's Rubberline
% Written/Edited by Bob Hamans (B.C.Hamans@student.tue.nl)
% Edited by Zhenping
% 02-04-2003

lh = [];
lh2 = [];

%Check for optional argument
switch nargin
case 0
  h=gca;

case 1
  h=varargin{1};
  axes(h);

  % Get current user data
  cudata=get(gcf,'UserData'); 
  hold on;
  % Wait for left mouse button to be pressed
  waitforbuttonpress;
  p1=get(h,'CurrentPoint');       %get starting point
  p1=p1(1,1:2);                   %extract x and y
  lh=plot(p1(1),p1(2),'-r', 'LineWidth', 1);      %plot starting point
  % Save current point (p1) data in a structure to be passed
  udata.p1=p1;
  udata.h=h;
  udata.lh=lh;
  % Set gcf object properties 'UserData' and call function 'wbmf' on mouse motion. 
  set(gcf,'UserData',udata,'WindowButtonMotionFcn','wbmf','DoubleBuffer','on');
  waitforbuttonpress;
  
  % Get data for the end point
  p2=get(h,'Currentpoint');       %get end point
  p2=p2(1,1:2);                   %extract x and y
  set(gcf,'UserData',cudata,'WindowButtonMotionFcn','','DoubleBuffer','off'); %reset UserData, etc..
  delete(lh);

case 2
  h = varargin{1};
  h2 = varargin{2};
  axes(h);
  % Get current user data
  cudata=get(gcf,'UserData'); 
  axes(h2);
  cudata2=get(gcf, 'UserData');

  axes(h);
  hold on;
  % Wait for left mouse button to be pressed
  waitforbuttonpress;
  p1=get(h,'CurrentPoint');       %get starting point
  p1=p1(1,1:2);                   %extract x and y
  lh=plot(p1(1),p1(2),'-r', 'LineWidth', 1);      %plot starting point

  % Set gcf object properties 'UserData' and call function 'wbmf' on mouse motion. 
  axes(h2);
  hold on;
  lh2 = plot(p1(1), p1(2), '-r', 'LineWidth', 1);

  % Save current point (p1) data in a structure to be passed
  udata.p1=p1;
  udata.h=h;
  udata.lh=lh;
  udata.h2=h2;
  udata.lh2=lh2;

  axes(h);
  set(gcf,'UserData',udata,'WindowButtonMotionFcn','wbmf','DoubleBuffer','on');
  waitforbuttonpress;
  
  % Get data for the end point
  p2=get(h,'Currentpoint');       %get end point
  p2=p2(1,1:2);                   %extract x and y
  set(gcf,'UserData',cudata,'WindowButtonMotionFcn','','DoubleBuffer','off'); %reset UserData, etc..
  % delete(lh);
  axes(h2);
  set(gcf,'UserData',cudata2,'WindowButtonMotionFcn','','DoubleBuffer','off'); %reset UserData, etc..
  % delete(lh2)

otherwise
  disp('Too many input arguments.');
end

end
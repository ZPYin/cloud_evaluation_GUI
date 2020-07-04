
function wbmf %window motion callback function

utemp=get(gcf,'UserData');
ptemp=get(utemp.h,'CurrentPoint');
ptemp=ptemp(1,1:2);
% Use 5 point to draw a rectangular rubberband box
set(utemp.lh,'XData',[ptemp(1),ptemp(1),utemp.p1(1),utemp.p1(1),ptemp(1)],'YData',[ptemp(2),utemp.p1(2),utemp.p1(2),ptemp(2),ptemp(2)]);

if isfield(utemp, 'h2')
    % Use 5 point to draw a rectangular rubberband box
    set(utemp.lh2,'XData',[ptemp(1),ptemp(1),utemp.p1(1),utemp.p1(1),ptemp(1)],'YData',[ptemp(2),utemp.p1(2),utemp.p1(2),ptemp(2),ptemp(2)]);
end

end
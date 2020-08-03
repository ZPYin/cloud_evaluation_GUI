function wmf_sliceTool %window motion callback function

utemp = get(gcf, 'UserData');
ptemp = get(utemp.h1, 'CurrentPoint');
ptemp = ptemp(1,1:2);
hRange = utemp.hRange;
% Use 2 point to draw a vertical line
set(utemp.lh1, 'XData', [ptemp(1), ptemp(1)],'YData', hRange);

if isfield(utemp, 'h2')
    % Use 2 point to draw a vertical line
    set(utemp.lh2, 'XData', [ptemp(1), ptemp(1)], 'YData', hRange);
end

end
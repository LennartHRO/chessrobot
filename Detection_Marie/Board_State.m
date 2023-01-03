function [board_state, display] = Board_State(frm)

% find chess figures 
% -------------------
[coosys,ctr,rad,color] = Detect_Circle(frm);

% Number of detected circles
n_circles = length(rad);


% Calculate board axis
% x-axis a=1, ..., h=8
x_tick = abs(coosys(1,1)-coosys(2,1))/9;
x_ctr = (ctr(:,1)-coosys(1,1))/x_tick;
x_ctr = round(x_ctr,0);

% y-axis 
y_tick = abs(coosys(1,2)-coosys(3,2))/9;
y_ctr = abs((coosys(3,2)-ctr(:,2)))/y_tick;
y_ctr = round(y_ctr,0);

% concentarate ctr coordinates with board coordinates
fig = [ctr,x_ctr,y_ctr,rad,color];
I_black = color == 1;
fig_black = fig(I_black, :);
fig_white = fig(not(I_black), :);


% Display circles being tracked with it's centers
display = frm;

% display = insertShape(display, 'Circle', [ctr(:,1), ctr(:,2), rad(:)], ...
%             'LineWidth', 10);
% display = insertText(display,ctr,1:size(ctr,1));

% display black figures
display = insertShape(display, 'Circle', [fig_black(:,1), fig_black(:,2), fig_black(:,5)], ...
            'LineWidth', 10, 'Color', 'cyan');

% display white figures
display = insertShape(display, 'Circle', [fig_white(:,1), fig_white(:,2), fig_white(:,5)], ...
            'LineWidth', 10 , 'Color', 'magenta');

% display board markers
display = insertShape(display, 'Circle', [coosys(:,1), coosys(:,2), [40;40;40]], ...
            'LineWidth', 10, 'Color','yellow');

display = insertMarker(display, ctr, '+', 'Color', 'red', 'Size', 40);



board_state = zeros(8);
% for i = 1:length(ctr)
%     board_state(ctr(i,4),ctr(i,3)) = 1;
% end
for i = 1:length(fig_black)
    board_state(fig_black(i,4),fig_black(i,3)) = 1;
end
for i = 1:length(fig_white)
    board_state(fig_white(i,4),fig_white(i,3)) = 3;
end


end
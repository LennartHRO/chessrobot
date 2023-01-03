I = imread('Input_Images/easy0.jpg');
Ibw = im2bw(I);

%Ifill = imfill(Ibw,'holes');
stats = [regionprops(Ibw); regionprops(not(Ibw))]

imshow(Ibw)
hold on

for i = 1:numel(stats)
    rectangle('Position', stats(i).BoundingBox, ...
    'Linewidth', 3, 'EdgeColor', 'r', 'LineStyle', '--');
end

verticalProfile = mean(Ibw, 2);
figure
subplot(2, 1, 1);
plot(verticalProfile, 'b-', 'LineWidth', 2);
grid on;
horizontalProfile = mean(Ibw, 1);
subplot(2, 1, 2);
plot(horizontalProfile, 'b-', 'LineWidth', 2);
grid on;


[imagePoints,boardSize] = detectCheckerboardPoints(I);

J = insertText(I,imagePoints,1:size(imagePoints,1));
J = insertMarker(I,imagePoints,'o','Color','red','Size',5);
imshow(J);

% imshow(Ifill)
% Iarea = bwareaopen(Ibw,100);
% Ifinal = bwlabel(Iarea);
% stat = regionprops(Ibw,'boundingbox');
% imshow(I); hold on;
% for cnt = 1 : numel(stat)
%     bb = stat(cnt).BoundingBox;
%     rectangle('position',bb,'edgecolor','r','linewidth',2);
% end
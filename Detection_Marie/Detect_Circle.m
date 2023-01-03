function [coosys,ctr,rad,color] = Detect_Circle(frm)
% Finds circular objects in frame
% Source: https://de.mathworks.com/help/images/detect-and-measure-circular-objects-in-an-image.html

% 'Method','twostage' - Sensitivity 0.96 is sufficient, but higher
% Sensitivity causes false positive results

% checking for white circles (3) % only whites! 
[ctr1,rad1] = imfindcircles(frm,[70 100],'ObjectPolarity','bright', ...
    'Sensitivity',0.96,'Method','twostage');

% checking for black circles (1) % includes also other colors 
[ctr2,rad2] = imfindcircles(frm,[70 100],'ObjectPolarity','dark', ...
    'Sensitivity',0.98,'Method','twostage');

% concaterating arrays, color white = 3, black = 1
ctr = cat(1,ctr1,ctr2);
rad = cat(1,rad1,rad2);
color = cat(1, (3*ones(length(ctr1),1)), ones(length(ctr2),1));

% erasing duplicates 
% threshold of distance optimized
dist = pdist2(ctr,ctr,'euclidean');
duplicates = (dist < (2*mean(rad))) == (dist > 1);
duplicates = triu(duplicates);
duplicates = logical(sum(duplicates(:,:)));
ctr = ctr(not(duplicates),:);
rad = rad(not(duplicates),:);
color = color(not(duplicates),:);



% filter out extrema to detect coordinate frame
% max y  
[ctr_sort1,I] = sort(ctr(:,2), 'descend');
ctr_sort1 = ctr(I(1:2),:);

% min y && min x --> y - Achse
y_max = ctr(I(end),:);

% delete coosys coordinates from ctr array
ctr = ctr(I(3:end-1),:);
rad = rad(I(3:end-1),:);
color = color(I(3:end-1),:);

% && min x --> Ursprung
[ctr_sort2,I] = min(ctr_sort1(:,1));
origin = ctr_sort1(I,:);

% max y && max x --> x - Achse
[ctr_sort2,I] = max(ctr_sort1(:,1));
x_max = ctr_sort1(I,:);

coosys = [origin;x_max;y_max];





end



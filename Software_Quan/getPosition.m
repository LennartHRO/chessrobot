function [Position] = getPosition(bw_Image)
Stats = regionprops('table',bw_Image,'Centroid','MajorAxisLength','MinorAxisLength');
Center = Stats.Centroid;

% Size of bw_Image
bw_Image_Height = size(bw_Image,1);
bw_Image_Width = size(bw_Image,2);

% Size one square
Square_Height = bw_Image_Height/8;
Square_Width = bw_Image_Width/8;

% Get position
Column = getColumn(Center(1),Square_Width);
Row = getRow(Center(2),Square_Height);

Position = append(Column,Row);
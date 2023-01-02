function [Move] = getMove(Image_Before_Move,Image_After_Move)

% Read images
X = imread(Image_Before_Move);
Y = imread(Image_After_Move);

% Fuse images
Fused_Image = imfuse(X,Y); % Result: Piece before move shown in red, after in green, everything else grey scale
%Fused_Image = imread('3.png'); % 3.png is an already fused image, just for reference

%figure('Name','Fused_Image','NumberTitle','off');
%imshow(Fused_Image);

% Extract color layer from Fused_image
Red_Layer = imsubtract(Fused_Image(:,:,1), rgb2gray(Fused_Image));     % Red layer (grey scale subtracted)
Green_Layer = imsubtract(Fused_Image(:,:,2), rgb2gray(Fused_Image));   % Green layer (grey scale subtracted)        
% Filter noise
Red_Layer = medfilt2(Red_Layer, [3 3]);
Green_Layer = medfilt2(Green_Layer, [3 3]); 

% Convert to black and white
Piece_Before = imbinarize(Red_Layer,0.1); 
Piece_After = imbinarize(Green_Layer,0.1);
% Only choose area greater than 500, must be calibrated dependent on piece size
Piece_Before = bwareaopen(Piece_Before,500);   
Piece_After = bwareaopen(Piece_After,500);

figure('Name','Piece_Before','NumberTitle','off');
imshow(Piece_Before);
figure('Name','Piece_After','NumberTitle','off');
imshow(Piece_After);

% Get move
Position_Before = getPosition(Piece_Before);
Position_After = getPosition(Piece_After);

Move = append(Position_Before,Position_After);

end
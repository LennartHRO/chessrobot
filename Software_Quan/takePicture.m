function [Chessboard_Image] = takePicture(Camera)

% Capture one frame
Video_Frame = snapshot(Camera);

%TODO: Trim Image to the exact size of the chessboard
Chessboard_Image = Video_Frame;

end
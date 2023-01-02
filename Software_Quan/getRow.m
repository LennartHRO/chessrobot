function [Row] = getRow(y_Center,Square_Height)
if y_Center>0 && y_Center<Square_Height
    Row = '8';
elseif y_Center>Square_Height && y_Center<2*Square_Height
    Row = '7';
elseif y_Center>2*Square_Height && y_Center<3*Square_Height
    Row = '6';
elseif y_Center>3*Square_Height && y_Center<4*Square_Height
    Row = '5';
elseif y_Center>4*Square_Height && y_Center<5*Square_Height
    Row = '4';
elseif y_Center>5*Square_Height && y_Center<6*Square_Height
    Row = '3';
elseif y_Center>6*Square_Height && y_Center<7*Square_Height
    Row = '2';
elseif y_Center>7*Square_Height && y_Center<8*Square_Height
    Row = '1';
elseif y_Center<0 || y_Center > 8*Square_Height
    fprintf('Fehler');
end
end
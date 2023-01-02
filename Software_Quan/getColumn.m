function [Column] = getColumn(x_Center,Square_Width)
if x_Center>0 && x_Center<Square_Width
    Column = 'a';
elseif x_Center>Square_Width && x_Center<2*Square_Width
    Column = 'b';
elseif x_Center>2*Square_Width && x_Center<3*Square_Width
    Column = 'c';
elseif x_Center>3*Square_Width && x_Center<4*Square_Width
    Column = 'd';
elseif x_Center>4*Square_Width && x_Center<5*Square_Width
    Column = 'e';
elseif x_Center>5*Square_Width && x_Center<6*Square_Width
    Column = 'f';
elseif x_Center>5*Square_Width && x_Center<7*Square_Width
    Column = 'g';
elseif x_Center>7*Square_Width && x_Center<8*Square_Width
    Column = 'h';
elseif x_Center<0 || x_Center > 8*Square_Width
    fprintf('Fehler');
end
end
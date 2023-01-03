

%obere linke Ecke: x geht nach rechts , y nach unten
%Schach: untere linke Ecke: Buchstaben nach rechts, Zahlen nach oben

% Sort 1: y
[ctr_Y_sort,I] = sort(ctr(:,2),'descend')
ctr_X_sort = ctr(I,1);
ctr_sort = [ctr_X_sort, ctr_Y_sort];

% Sort 2: split into A - B - G - H 
[ctr_X_sort,I_A] = sort(ctr_sort(1:8,1),'ascend');
I_A = I_A;
[ctr_X_sort,I_B] = sort(ctr_sort(9:16,1),'ascend');
I_B = I_B +8;
[ctr_X_sort,I_G] = sort(ctr_sort(17:24,1),'ascend');
I_G = I_G + 16;
[ctr_X_sort,I_H] = sort(ctr_sort(25:32,1),'ascend');
I_H = I_H + 24;

I = [I_A; I_B; I_G; I_H];
ctr_sort = ctr_sort(I,:);

% Adding row A=1, B=2, ..., G=7, H=8 and column information 
start_pos = [1,1;1,2;1,3;1,4;1,5;1,6;1,7;1,8;...
             2,1;2,2;2,3;2,4;2,5;2,6;2,7;2,8;...
             7,1;7,2;7,3;7,4;7,5;7,6;7,7;7,8;...
             8,1;8,2;8,3;8,4;8,5;8,6;8,7;8,8];

% index - X - Y - row - column - color 
figure_state = [ctr_sort,start_pos]
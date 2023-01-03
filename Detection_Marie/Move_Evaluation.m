clc; clear;

% calculate previous board state
frm_prev=imread('Input_Images/Game1/Move9.jpeg');
[board_state_prev, display_prev] = Board_State(frm_prev);

% calculate current board state
frm=imread('Input_Images/Game1/Move10.jpeg');
[board_state, display] = Board_State(frm);

% showing the two pictures
imshowpair(display_prev,display,'montage')

% calculating the difference
board_move = board_state - board_state_prev;

% dictinary to look up move
dic = ["h1","h2","h3","h4","h5","h6","h7","h8"; ...
       "g1" "g2" "g3" "g4" "g5" "g6" "g7" "g8"; ...
       "f1" "f2" "f3" "f4" "f5" "f6" "f7" "f8"; ...
       "e1" "e2" "e3" "e4" "e5" "e6" "e7" "e8"; ...
       "d1" "d2" "d3" "d4" "d5" "d6" "d7" "d8"; ...
       "c1" "c2" "c3" "c4" "c5" "c6" "c7" "c8"; ...
       "b1" "b2" "b3" "b4" "b5" "b6" "b7" "b8"; ...
       "a1" "a2" "a3" "a4" "a5" "a6" "a7" "a8"];

switch (max(max(board_move)))
    case 3
        % white moves to an empty field 
        % Find the old field of the moved figure
        [row,col]=find(board_move==-3);
        old = dic(row,col);
        % Find the new field of the moved figure
        [row,col]=find(board_move==3);
        new = dic(row,col);
        
        move = append(old,new);
        text = sprintf('WHITE MOVES from %s to %s',old,new);
        disp(text);
    case 2
        % white beats a black figure
        % Find the old field of the moved figure
        [row,col]=find(board_move==-3);
        old = dic(row,col);
        % Find the new field of the moved figure
        [row,col]=find(board_move==2);
        new = dic(row,col);

        move = append(old,new);
        text = sprintf('WHITE MOVES from %s to %s and BEATS a black figure',old,new);
        disp(text);
    case 1
        % black moves to an empty field
        % Find the old field of the moved figure
        [row,col]=find(board_move==-1);
        old = dic(row,col);
        % Find the new field of the moved figure
        [row,col]=find(board_move==1);
        new = dic(row,col);

        move = append(old,new);
        text = sprintf('BLACK MOVES from %s to %s',old,new);
        disp(text);
    case 0 
        switch (min(min(board_move)))
            case 0
                % nothing has changed 
                move = "";
                text = sprintf('...nothing changed...');
                disp(text);
            case -2
                % black beats a white figure
                % Find the old field of the moved figure
                [row,col]=find(board_move==-1);
                old = dic(row,col);
                % Find the new field of the moved figure
                [row,col]=find(board_move==-2);
                new = dic(row,col);

                move = append(old, new);
                text = sprintf('BLACK MOVES from %s to %s and BEATS a white figure',old,new);
                disp(text);
        end
end

move
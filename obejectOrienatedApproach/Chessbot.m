classdef Chessbot
    
    properties
        chess_status    % aktueller Spielstand (8x8 matrix, 0-keine Figur auf Feld, 1-eine Figur auf Feld)
    end

    methods (Access = public)
        function obj = Chessbot()

            obj.chess_status = [ones(1,8); ones(1,8);zeros(1,8);zeros(1,8);zeros(1,8);zeros(1,8);ones(1,8); ones(1,8)];


            %Open in.txt to write and close again (to delete any old data).
            clearfile = fopen('C:\Users\lenna\OneDrive - TUM\Uni\Entickelung modularer Roboter\Schachroboter\IO\in.txt','w'); 
            fclose(clearfile);

            %Open out.txt to write and close again (to delete any old data).
            clearfile = fopen('C:\Users\lenna\OneDrive - TUM\Uni\Entickelung modularer Roboter\Schachroboter\IO\out.txt','w'); 
            fclose(clearfile);

            %Open in.txt again to read
            Input = fopen('C:\Users\lenna\OneDrive - TUM\Uni\Entickelung modularer Roboter\Schachroboter\IO\in.txt','r'); 
                    
            %Open out.txt to write (append)
            Output = fopen('C:\Users\lenna\OneDrive - TUM\Uni\Entickelung modularer Roboter\Schachroboter\IO\out.txt','a');

        end

        function [obj, beat] = check_beat(obj, move_string)
            % 
            %
            %
            % === INPUT ARGUMENTS ===
            % move_string : move in the fromat 'c2c4'
            %
            % === OUTPUT ARGUMENTS ===
            % beat : bool, if there is a chesspiece at the goal field

            beat = 0;

            row_string = '12345678';
            column_string = 'abcdefgh';
            start_pos = [strfind(row_string,move_string(2)), strfind(column_string,move_string(1))];
            end_pos = [strfind(row_string,move_string(4)), strfind(column_string,move_string(3))];


            obj.chess_status(start_pos(1), start_pos(2)) = 0;
            if (obj.chess_status(end_pos(1), end_pos(2)) == 1)
                beat = 1;
            end

            obj.chess_status(end_pos(1), end_pos(2)) = 1;


        end

        function robot_move = calculateMove(obj, player_move)
            % === INPUT ARGUMENTS ===
            % player_move : move made by the player
            %
            % === OUTPUT ARGUMENTS ===
            % robot_move : move the robot will be executing next

            
            %Open file out.txt (this line goes to function setup for setting up)
            %Output = fopen('C:\Users\lenna\OneDrive - TUM\Uni\Entickelung modularer Roboter\Schachroboter\IO\out.txt','a'); %TODO: open file from path f = fopen('../../filename');
            
            
            %Send player's move to out.txt
            fprintf(Output,'%4s',player_move);    % Send Move to out.txt

            
            %These 3 lines for setting up go in setup
            %clearfile = fopen('C:\Users\lenna\OneDrive - TUM\Uni\Entickelung modularer Roboter\Schachroboter\IO\in.txt','w'); %Just open and then close in.txt again to clear old data
            %fclose(clearfile); 
            %Input = fopen('C:\Users\lenna\OneDrive - TUM\Uni\Entickelung modularer Roboter\Schachroboter\IO\in.txt','r'); %Now open file to read, TODO: path to in.txt
            

            %Read Engine's move from in.txt
            newmove = 0; %ther will be no new move at first
            while ~newmove %when there is still no new move, stay in while loop
                A = fscanf(Input,'%s'); %Can file in.txt, if no new move was printed, A = ''

                if ~isequal(A,'')    %check if A~=''.i.e. if new move was printed
                    newmove = 1;     % if there is a new move, get out of the while loop
                    fprintf('%s',A); %print newmove to console, just for debugging, this line can be deleted later
                end
            end

            robot_move = A;


        end
    end
end
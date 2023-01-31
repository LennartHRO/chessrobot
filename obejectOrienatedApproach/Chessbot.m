classdef Chessbot
    
    properties

    end

    methods (Static)
        function obj = Chessbot()

        end
        
        
        function setup()

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

        function [robot_move, beat] = calculateMove(obj, player_move)
            % ..
            %
            %
            % === INPUT ARGUMENTS ===
            % player_move : move made by the player
            %
            % === OUTPUT ARGUMENTS ===
            % robot_move : move the robot will be executing next
            % beat : bool, if there is a chesspiece at the goal field

            
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
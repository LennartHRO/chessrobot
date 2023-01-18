classdef Chessbot
    %Chessbot Summary of this class goes here
    

    properties
        
    end

    methods
        function obj = Chessbot()
  
        end

        function [robot_move, beat] = calculateMove(player_move)
            % ..
            % 
            %
            % === INPUT ARGUMENTS ===
            % player_move : move made by the player
            %
            % === OUTPUT ARGUMENTS ===
            % robot_move : move the robot will be executing next
            % beat : bool, if there is a chesspiece at the goal field 

            
            %Send player's move to out.txt
            %Open file out.txt
            Output = fopen('out.txt','w'); %TODO: open file from path f = fopen('../../filename');
            fprintf(Output,'%4s',player_move);    % Send Move to out.txt

            %Read Engine's move from in.txt
            clearfile = fopen('in.txt','w'); %Just open and then close in.txt again to clear old data
            fclose(clearfile);

            Input = fopen('in.txt','r'); %Now open file to read, TODO: path to in.txt
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
% HEBI Initialization
initializeHEBI;
% Camera Initialization
initializeCamera;
% Open files
Output = fopen('out.txt','w');
Input = fopen('in.txt','r');

if userPlayswhite    %TODO: Check if player plays white
    
    Image_Before_Move=takePicture(Camera); %Take picture before move
    Prompt = "Fang Du an!\nDrücke ENTER wenn Du mit Deinem Zug fertig bist\n\n";
    
    if strcmp(input(Prompt,'s'), '')  % When player press ENTER

        fprintf('Jetzt warte...\n')
        Image_After_Move=takePicture(Camera); % Take picture after move
        Player_Move=getMove(Image_Before_Move,Image_After_Move); % Get move    
        fprintf(Output,'%4s',Player_Move);    % Send Move to out.txt

    end

else 
    fprintf('Ich fange an!\n');

end

End_Match = 0;
while(~End_Match)

    %TODO: Wait for new move from in.txt then read it
    Robot_Move = fscanf(Input,'%4s'); % Get move from in.txt
    moveRobotarm(Robot_Move); %TODO: Function to move robot arm from one point to an other
    
    while ~moveIsdone
        % Just wait until move is done
        fprintf("Ich bewege grad die Schachfigur...\n")
    end

    if moveIsdone

        Image_Before_Move=takePicture(Camera);    % Take picture before move
        Prompt = "Fertig! Du bist dran!\nDrücke ENTER wenn Du mit Deinem Zug fertig bist\n\n";
                
        if strcmp(input(Prompt,'s'), '')
            fprintf('Jetzt warte...\n')
            Image_After_Move=takePicture(Camera); % Take picture after move
            Player_Move=getMove(Image_Before_Move,Image_After_Move); % Get move    
            fprintf(Output,'%4s',Player_Move);    % Send Move to out.txt

        end

    end

end % End of while loop, start waiting for new move from in.txt again
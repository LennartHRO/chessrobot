function [moveIsdone] = moveRobotarm(Robot_Move)
% moveRobotarm(Robot_Move) move robot arm according to
% predetermined move Robot_Move, e.g. 'e7e5'.
% Input 'Robot_Move': String
% Output 'moveIsdone': Bool, check if move is done properly

% Split move into square position
Start_Square = Robot_Move(1:2);
End_Square   = Robot_Move(3:4);

% Turn Chess board square into joints position
Start_Position = turnSquare2Position(Start_Square);  %TODO
End_Position = turnSquare2Position(End_Square);    %TODO

%% Move arm from Start_Position to End_Position
% Get kinematics
kin = HebiKinematics('4R.xml');

trajGen = HebiTrajectoryGenerator(kin);

waypoints = [Start_Position; End_Position]; 
% Generate linear trajectory
traj = trajGen.newLinearMove(waypoints);
% Execute trajectory in position and velocity
cmd = CommandStruct();
t0 = tic();
t = toc(t0);
while t < traj.getDuration()
    t = toc(t0);

    % React to something (e.g. position error or effort threshold)
    fbk = group.getNextFeedback();
    if fbk.position - fbk.positionCmd > 0.1
        group.send(CommandStruct()); % turn off commands
        error('Reacting to something...');
    end

    % Get target state at current point in time
    [pos, vel, ~] = traj.getState(t);

    % Command position/velocity
    cmd.position = pos;
    cmd.velocity = vel;
    group.send(cmd);

end


moveIsdone = 1;
end
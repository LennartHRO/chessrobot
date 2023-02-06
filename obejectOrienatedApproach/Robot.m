classdef Robot
    % Klasse Robot
    % Enthält alle Attribute, die den Roboterarm beschreiben, und alle
    % Funktionen, die dieser auführen kann.

    properties
        % hier werden alle nötigen Attribute des Roboters deklariert
        % Hebi-spezifisch:
        gripper_group % Hebi-Group für den Greifer
        arm2R_group % Hebi-Group für den arm2R-Arm
        hinge_group % Hebi-Group für das Hinge-Gelenk
        gripper_cmd 
        arm2R_cmd
        hinge_cmd
        arm2R_kin
        hinge_kin
        arm2R_trajGen
        hinge_trajGen
        % Konstanten:
        board_offset % 2x1 vector in the cartesian arm system from the origin to the lower left corner of the grid (base of the board system)
        fig_gripped_min_torque 
        gripper_open_angle
        gripper_closed_angle
        % Variablen des Greifers
        gripper_opened
        figure_gripped
        % Variablen des Arms:
        hinge_target % Scalar that is the target angle (radians) of the hinge (= first joint)
        xy_target % 2x1 vector of the desired arm position in the cartesian system
        first_xy
        second_xy
        arm_target_reached
        % State-Machine:
        Arm_SM
    end

    methods(Access = public)
        function obj = Robot() % Works

            %Construct an instance of this class
            % hier werden alle  Attribute des Roboters initializiert
            %
            % Hebi-spezifisch:
            %{
            obj.gripper_group = HebiLookup.newGroupFromNames('Greifer',{'Greifer'}); 
            obj.arm2R_group = HebiLookup.newGroupFromNames('Arm',{'Hinteres_Gelenk' ,'Vorderes_Gelenk'});
            obj.hinge_group = HebiLookup.newGroupFromNames('Hebende',{'Hebendes_Gelenk'});
            obj.gripper_cmd = CommandStruct();
            obj.arm2R_cmd = CommandStruct();
            obj.hinge_cmd = CommandStruct();
            obj.arm2R_kin = HebiUtils.loadHRDF('2R_kinematics.xml'); 
            obj.hinge_kin = HebiUtils.loadHRDF('2R_kinematics.xml'); % TODO: Create 1-dimensional hinge xml and add it
            obj.arm2R_trajGen = HebiTrajectoryGenerator(obj.arm2R_kin);
            obj.hinge_trajGen = HebiTrajectoryGenerator(obj.hinge_kin);
            %}
            % Konstanten:
            obj.board_offset = [0.19 -0.133]; 
            obj.fig_gripped_min_torque = 0.3;
            obj.gripper_open_angle = 1.7; % TODO: Adjust
            obj.gripper_closed_angle = 2.02; % TODO: Adjust
            % Variablen des Greifers
            obj.gripper_opened = false;
            obj.figure_gripped = false;
            % Variablen des Arms:
            obj.hinge_target = 0.5; % TODO: Adjust
            obj.xy_target  = [0 0]; % 2x1 vector of the desired arm position in the cartesian system
            obj.first_xy = [0 0];
            obj.second_xy = [0 0];
            obj.arm_target_reached = 0;
            % State-Machine:
            % Initialization of the state machine and its constants. 
            % TODO: adjust the values of the constants
            obj.Arm_SM = ArmStateMachine(up_angle = 0.5, down_angle = 0, rest_xy = [0.1 -0.4], discard_xy = [0.3 -0.4]);
            % Variablen die den Zug beschreiben

        end

        function makeMove(obj, desired_move_mtx,figure_must_be_beat) % Not yet done
            chess_move_done = false;
            [first_xy, second_xy] = obj.field_to_robot_coords(desired_move_mtx);
            while chess_move_done == false
                % The SM is run with only the the variables that are determined in Matlab being explicitly set:
                disp(obj.arm_target_reached);
                step(obj.Arm_SM, statemachine_first_xy = first_xy, statemachine_second_xy = second_xy, statemachine_arm_target_reached = obj.arm_target_reached); 
                switch obj.Arm_SM.function_to_run
                    case "none"
                        obj.arm_stop();
                    case "gripper_open"
                        obj.gripper_open();
                    case "gripper_close"
                        obj.gripper_close();
                    case "arm2R_move"
                        obj.arm_target_reached = 0;
                        xy_target = obj.Arm_SM.xy_target;
                        obj.arm2R_move(xy_target);
                    case "hinge_move"
                        obj.arm_target_reached = 0;
                        hinge_target = obj.Arm_SM.hinge_target;
                        obj.hinge_move(hinge_target);
                    case "arm_stop"
                        obj.arm_stop();
                    otherwise
                        disp("Error");
                end
                chess_move_done = obj.Arm_SM.chess_move_done;
                pause(1);
            end
        end

        function [first_xy, second_xy] = field_to_robot_coords(obj, desired_move_mtx) % Works
            cell_size = 0.05; % [m] Breite = Höhe
            first_pos_field_sys = cell_size*desired_move_mtx(1,:) - 0.5*[cell_size,cell_size];
            second_pos_field_sys = cell_size*desired_move_mtx(2,:) - 0.5*[cell_size,cell_size];
            first_xy = first_pos_field_sys + obj.board_offset;
            second_xy = second_pos_field_sys + obj.board_offset;
        end

        function arm2R_move(obj, xy_target) % Works but not so accurate
            disp("Moving 2R arm");
            %{
            % generate trajectory
            obj.arm2R_trajGen.setAlgorithm('MinJerkPhase'); % MinJerk trajectories
            obj.arm2R_trajGen.setSpeedFactor(1);
            % get the joint position that the arm needs to be moved
            jointspace_target = obj.arm2R_kin.getIK("XYZ", [xy_target 0]);
            xy_target_joint_position = [jointspace_target(1), jointspace_target(2)];
            % get the current joint position
            fbk = obj.arm2R_group.getNextFeedback();
            xy_init_joint_pos = [fbk.position(1), fbk.position(2)];
            % create the trajectory
            xy_waypoints = [xy_init_joint_pos; xy_target_joint_position];
            xy_traj = obj.arm2R_trajGen.newJointMove(xy_waypoints);
            % move the arm with command
            t0 = tic(); % start a timer at the current CPU time
            t = toc(t0); % time since start of timer
            
            while t < xy_traj.getDuration() % Duration is the total time the trajectory takes
                t = toc(t0); % time since start of timer
                % get position and velocity at time t from trajectory
                [pos, vel, accel] = xy_traj.getState(t);
                % send the position commands
                obj.arm2R_cmd.position(1) = pos(1);
                obj.arm2R_cmd.position(2) = pos(2);
                %disp(pos);
                % send the velocity commands
                obj.arm2R_cmd.velocity(1) = vel(1);
                obj.arm2R_cmd.velocity(2) = vel(2);
                obj.arm2R_group.send(obj.arm2R_cmd);
            end
            %}
            obj.arm_target_reached = 1;
        end

        function hinge_move(obj, hinge_target) % TODO: Copy code from arm2R_move, adjust it to just one motor
            disp("Moving arm hinge!");
            % generate trajectory
            obj.hinge_trajGen.setAlgorithm('MinJerkPhase'); % MinJerk trajectories
            obj.hinge_trajGen.setSpeedFactor(1);
            % get the joint position that the arm with hinge needs to be moved
            jointspace_target = obj.hinge_kin.getIK("XYZ", [hinge_target 0]);
            hinge_target_joint_position = [jointspace_target(1), jointspace_target(2)];
            % get the current joint position
            fbk = obj.hinge_group.getNextFeedback();
            hinge_init_joint_pos = [fbk.position(1), fbk.position(2)];
            % create the trajectory
            hinge_waypoints = [hinge_init_joint_pos; hinge_target_joint_position];
            hinge_traj = obj.hinge_trajGen.newJointMove(hinge_waypoints);
            % move the arm with hinge
            t0 = tic(); % start a timer at the current CPU time
            t = toc(t0); % time since start of timer
            
            while t < hinge_traj.getDuration() % Duration is the total time the trajectory takes
                t = toc(t0); % time since start of timer
                % get position and velocity at time t from trajectory
                [pos, vel, accel] = hinge_traj.getState(t);
                % send the position commands
                obj.hinge_cmd.position(1) = pos(1);
                obj.hinge_cmd.position(2) = pos(2);
                %disp(pos);
                % send the velocity commands
                obj.hinge_cmd.velocity(1) = vel(1);
                obj.hinge_cmd.velocity(2) = vel(2);
                obj.hinge_group.send(obj.hinge_cmd);
            end

            obj.arm_target_reached = 1;
        end

        function gripper_open(obj) % Works
            disp("Opening Gripper");
            %{
            fbk = obj.group.getNextFeedback();
            gripper_angle = fbk.position(4);
            while gripper_angle > obj.gripper_open_angle 
                gripper_vel = -0.5; % TODO: Adjust
                obj.cmd.velocity = [0 0 0 gripper_vel];
                obj.group.send(obj.cmd);
                fbk = obj.group.getNextFeedback();
                gripper_angle = fbk.position(4);
            end
            obj.cmd.velocity = [0 0 0 0];
            obj.group.send(obj.cmd);
            %}
            obj.gripper_opened = true;
            %disp("Gripper opened!");
        end


        function gripper_close(obj) % Works
            disp("Closing Gripper");
            %{
            fbk = obj.group.getNextFeedback();
            gripper_angle = fbk.position(4);
            while gripper_angle < obj.gripper_closed_angle 
                gripper_vel = 0.5; % TODO: Adjust
                obj.cmd.velocity = [0 0 0 gripper_vel];
                obj.group.send(obj.cmd);
                fbk = obj.group.getNextFeedback();
                gripper_angle = fbk.position(4);
            end
            obj.cmd.velocity = [0 0 0 0];
            obj.group.send(obj.cmd);
            fbk = obj.group.getNextFeedback();
            gripper_torque = abs(fbk.effort(4));
            if gripper_torque > obj.fig_gripped_min_torque
                obj.figure_gripped = true;
                disp("Figure gripped!");
            else
                obj.figure_gripped = false;
                disp("Figure not gripped!");
            end
            %}
            obj.gripper_opened = false;
        end


        function arm_stop(obj)
            disp("Stopping Arm");
            %obj.cmd.velocity = [0 0 0 0];
            %obj.group.send(obj.cmd);
        end
    end

    
end
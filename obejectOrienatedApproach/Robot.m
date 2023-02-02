classdef Robot
    % Klasse Robot
    % Enthält alle Attribute, die den Roboterarm beschreiben, und alle
    % Funktionen, die dieser auführen kann.

    properties
        % hier werden alle nötigen Attribute des Roboters deklariert
        % Hebi-spezifisch:
        group % Hebi-Group
        kin % Hebi Kinematics
        % Konstanten:
        board_offset % 2x1 vector in the cartesian arm system from the origin to the lower left corner of the grid (base of the board system)
        fig_gripped_min_torque 
        gripper_open_angle
        gripper_closed_angle
        % Variablen des Arms:
        hinge_target % Scalar that is the target angle (radians) of the hinge (= first joint)
        xy_target % 2x1 vector of the desired arm position in the cartesian system
        % State-Machine:
        Arm_SM
    end

    methods(Access = public)
        function obj = Robot()
            %Construct an instance of this class
            % hier werden alle  Attribute des Roboters initializiert
            %
            % Hebi-spezifisch:
            group = HebiLookup.newGroupFromNames('Arm',{'Gelenk_1','Gelenk_2','Gelenk_3','Greifer'}); % TODO: Richtige Namen einfügen
            kin = = HebiUtils.loadHRDF('2R_kinematics.xml'); % TODO: Richtige Kinematik-Datei einbinden
            % Konstanten:
            board_offset = [0.165 0.135]; % TODO: Offset von Basisprofil-Ecke zu Gelenkmittelpunkt hinzufügen% 2x1 vector in the cartesian arm system from the origin to the lower left corner of the grid (base of the board system)
            fig_gripped_min_torque = 0.6;
            gripper_open_angle = 0.2; % TODO: Adjust
            gripper_closed_angle = 0; % TODO: Adjust
            % Variablen des Arms:
            hinge_target = 0.5; % TODO: Adjust
            xy_target  = [0 0]; % 2x1 vector of the desired arm position in the cartesian system
            % State-Machine:
            % Initialization of the state machine and its constants. 
            % TODO: adjust the values of the constants
            Arm_SM = ArmStateMachine(up_angle = 0.5, down_angle = 0, rest_xy = [0.1 -0.4], discard_xy = [0.3 -0.4]);
            % Variablen die den Zug beschreiben

        end

        function field_to_robot_coords(obj, desired_move_mtx)
            % TODO
            obj.first_xy = ;
            obj.second_xy = ;
        end

        function makeMove(obj, desired_move_mtx,figure_must_be_beat)
            % === INPUT ARGUMENTS ===
            % desired_move_mtx = a 2x2 matrix
            % where the first row is the xy-coords (arm system) of the
            % starting position of the move while the second row is the
            % coords of the end position.
            obj.chess_move_done = false;
            while obj.chess_move_done == false
                % The SM is run with only the the variables that are determined in Matlab being explicitly set:
                step(Arm_SM,first_xy = ,second_xy = , arm_target_reached = ,??? = figure_must_be_beat); 
                obj.chess_move_done = obj.Arm_SM.chess_move_done;
            end
        end

        function move_arm(obj, hinge_target,xy_target)
            % TODO: Die Funktion soll das erste Gelenk (= Hinge) und die
            % Gelenke 2 und 3 (= 2R-Arm) ansteuern.
            % Sobald sowohl hinge-target als auch xy-target erreicht sind 
            % soll die globale Variable 
        end

        function gripper_open(obj)
            fbk = obj.group.getNextFeedback();
            obj.gripper_angle = fbk.pos(4);
            while obj.gripper_angle < obj.gripper_open_angle 
                obj.gripper_vel = 0.1; % TODO: Adjust
                obj.cmd.velocity = [0 0 0 obj.gripper_vel];
                obj.group.send(obj.cmd);
                fbk = obj.group.getNextFeedback();
                obj.gripper_angle = fbk.pos(4);
            end
            obj.cmd.velocity = [0 0 0 0];
            obj.group.send(obj.cmd);
            obj.gripper_open = true;
        end

        function gripper_close(obj)
            fbk = obj.group.getNextFeedback();
            obj.gripper_angle = fbk.pos(4);
            while obj.gripper_angle > obj.gripper_closed_angle 
                obj.gripper_vel = -0.1; % TODO: Adjust
                obj.cmd.velocity = [0 0 0 obj.gripper_vel];
                obj.group.send(obj.cmd);
                fbk = obj.group.getNextFeedback();
                obj.gripper_angle = fbk.pos(4);
            end
            obj.cmd.velocity = [0 0 0 0];
            obj.group.send(obj.cmd);
            fbk = obj.group.getNextFeedback();
            obj.gripper_torque = fbk.effort(4);
            if obj.gripper_torque > obj.fig_gripped_min_torque
                obj.figure_gripped = true;
            else
                obj.figure_gripped = false;
            end
            obj.gripper_open = false;
        end

        function arm_stop()
            obj.cmd.velocity = [0 0 0 0];
            obj.group.send(obj.cmd);
        end
    end

    
end
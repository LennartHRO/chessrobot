classdef Robot
    % Klasse Robot
    % Enthält alle Attribute, die den Roboterarm beschreiben, und alle
    % Funktionen, die dieser auführen kann.

    properties
        % hier werden alle nötigen Attribute des Roboters deklariert

        group
    end

    methods (Access = public)
        function obj = Robot()
            %Construct an instance of this class
            %hier werden alle  Attribute des Roboters initializiert

        end

        function makeMove(obj, robot_Move)
            % === INPUT ARGUMENTS ===
            % robot_Move : sting, move the robot has to executre (eg.: 'd2d4')
            disp("move")
            %TODO
        end
    end

    
end
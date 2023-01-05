classdef Robot
    % Klasse Robot
    % Enthält alle Attribute, die den Roboterarm beschreiben, und alle
    % Funktionen, die dieser auführen kann.

    properties
        group
    end

    methods
        function obj = Robot()
            %Construct an instance of this class   
            
        end

        function success = makeMove(startPos, endPos)
            %TODO
            success = 1;
        end
    end
end
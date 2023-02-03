classdef Camera
    % This class should contain everything, what has to do with the Camera
    % and the according computervision algorithm.

    properties %(Access = private)
        frm_prev        %frames before and after the player makes a move
        frm

        board_state_prev
        board_state

        display_prev
        display

        img_before
        img_after

        mobile
        cam
    end


    methods (Access = public)
        function obj = Camera()
            clear moblie;
            obj.mobile = mobiledev;
            obj.cam = camera(obj.mobile, 'back');
          
        end

        function [move, beat, color, text] = getMove(obj)
            % This function returns all the information abaout the move the
            % player has made, according to the previous taken piktures
            %
            % === OUTPUT ARGUMENTS ===
            % move : string of the move (eg.: 'h8g8')
            % beat : does the figure beats a figure (0-no, 1-yes)
            % color: color of the moved figure (0-white, 1-black)
            % text : info text
            %
            % TODO detection of rochade and en passant
            
            %default values
            move = [];
            beat = 0;
            color = [];
            text = 'error';

            % calculating the difference
            board_move = obj.board_state - obj.board_state_prev;

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

                    beat = 0;
                    color = 0;
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

                    beat = 1;
                    color = 0;
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

                    beat = 0;
                    color = 1;
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

                            beat = 1;
                            color = 1;
                    end
            end
        end

        function obj = makePhoto(obj, when)
            % This function makes a photo of the current situation and
            % stores it either in frm_prev or in frm.
            %
            % === INPUT ARGUMENTS ===
            % when : 0 -> photo before player has moved, 1 -> photo after player has moved
            %
            % === OUTPUT ARGUMENTS ===
            % obj

            if(when == 0)
                %obj.frm_prev=imread('Input_Images/Game1/Move9.jpeg');
                obj.img_before = snapshot(obj.cam, 'immediate');
                [obj.board_state_prev, obj.display_prev] = obj.Board_State(obj.img_before);
            end

            if(when == 1)
                %obj.frm=imread('Input_Images/Game1/Move10.jpeg');
                obj.img_after = snapshot(obj.cam, 'immediate');
                [obj.board_state, obj.display] = obj.Board_State(obj.img_after);
            end

        end

        function showPicture(obj, which)
            % This function is show the photos which are stored in
            % display_prev/display.
            %
            % === INPUT ARGUMENTS ===
            % which : 0 -> photo before player has moved, 1 -> photo after
            %         player has moved, 2 -> both photos



            if(which==0)
                imshow(obj.display_prev);
            end
            if(which==1)
                imshow(obj.display);
            end
            if(which==2)
                imshowpair(obj.display_prev,obj.display,'montage');
            end
        end


    end

    methods (Access = private)
        function [coosys,ctr,rad,color] = Detect_Circle(obj, frm)
            % Finds circular objects in frame
            % Source: https://de.mathworks.com/help/images/detect-and-measure-circular-objects-in-an-image.html

            % 'Method','twostage' - Sensitivity 0.96 is sufficient, but higher
            % Sensitivity causes false positive results

            % checking for white circles (3) % only whites!
            [ctr1,rad1] = imfindcircles(frm,[70 100],'ObjectPolarity','bright', ...
                'Sensitivity',0.96,'Method','twostage');

            % checking for black circles (1) % includes also other colors
            [ctr2,rad2] = imfindcircles(frm,[70 100],'ObjectPolarity','dark', ...
                'Sensitivity',0.98,'Method','twostage');

            % concaterating arrays, color white = 3, black = 1
            ctr = cat(1,ctr1,ctr2);
            rad = cat(1,rad1,rad2);
            color = cat(1, (3*ones(length(ctr1),1)), ones(length(ctr2),1));

            % erasing duplicates
            % threshold of distance optimized
            dist = pdist2(ctr,ctr,'euclidean');
            duplicates = (dist < (2*mean(rad))) == (dist > 1);
            duplicates = triu(duplicates);
            duplicates = logical(sum(duplicates(:,:)));
            ctr = ctr(not(duplicates),:);
            rad = rad(not(duplicates),:);
            color = color(not(duplicates),:);



            % filter out extrema to detect coordinate frame
            % max y
            [ctr_sort1,I] = sort(ctr(:,2), 'descend');
            ctr_sort1 = ctr(I(1:2),:);

            % min y && min x --> y - Achse
            y_max = ctr(I(end),:);

            % delete coosys coordinates from ctr array
            ctr = ctr(I(3:end-1),:);
            rad = rad(I(3:end-1),:);
            color = color(I(3:end-1),:);

            % && min x --> Ursprung
            [ctr_sort2,I] = min(ctr_sort1(:,1));
            origin = ctr_sort1(I,:);

            % max y && max x --> x - Achse
            [ctr_sort2,I] = max(ctr_sort1(:,1));
            x_max = ctr_sort1(I,:);

            coosys = [origin;x_max;y_max];

        end

        function [board_state, display] = Board_State(obj, frm)

            % find chess figures
            % -------------------
            [coosys,ctr,rad,color] = obj.Detect_Circle(frm);

            % Number of detected circles
            n_circles = length(rad);


            % Calculate board axis
            % x-axis a=1, ..., h=8
            x_tick = abs(coosys(1,1)-coosys(2,1))/9;
            x_ctr = (ctr(:,1)-coosys(1,1))/x_tick;
            x_ctr = round(x_ctr,0);

            % y-axis
            y_tick = abs(coosys(1,2)-coosys(3,2))/9;
            y_ctr = abs((coosys(3,2)-ctr(:,2)))/y_tick;
            y_ctr = round(y_ctr,0);

            % concentarate ctr coordinates with board coordinates
            fig = [ctr,x_ctr,y_ctr,rad,color];
            I_black = color == 1;
            fig_black = fig(I_black, :);
            fig_white = fig(not(I_black), :);


            % Display circles being tracked with it's centers
            display = frm;

            % display = insertShape(display, 'Circle', [ctr(:,1), ctr(:,2), rad(:)], ...
            %             'LineWidth', 10);
            % display = insertText(display,ctr,1:size(ctr,1));

            % display black figures
            display = insertShape(display, 'Circle', [fig_black(:,1), fig_black(:,2), fig_black(:,5)], ...
                'LineWidth', 10, 'Color', 'cyan');

            % display white figures
            display = insertShape(display, 'Circle', [fig_white(:,1), fig_white(:,2), fig_white(:,5)], ...
                'LineWidth', 10 , 'Color', 'magenta');

            % display board markers
            display = insertShape(display, 'Circle', [coosys(:,1), coosys(:,2), [40;40;40]], ...
                'LineWidth', 10, 'Color','yellow');

            display = insertMarker(display, ctr, '+', 'Color', 'red', 'Size', 40);



            board_state = zeros(8);
            % for i = 1:length(ctr)
            %     board_state(ctr(i,4),ctr(i,3)) = 1;
            % end
            for i = 1:length(fig_black)
                board_state(fig_black(i,4),fig_black(i,3)) = 1;
            end
            for i = 1:length(fig_white)
                board_state(fig_white(i,4),fig_white(i,3)) = 3;
            end


        end
    end
end
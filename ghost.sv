module ghost_red (input Reset, frame_clk, hasMoved, isDefeated, death, input logic [9:0] pacmanX, input logic [9:0] pacmanY, output [9:0] ghost_redX, output [9:0] ghost_redY);


    logic [9:0] ghostX, ghostY, ghostXmotion, ghostYmotion;

    logic [19:0] distance, distance_up, distance_down, distance_left, distance_right, min_distance;


    logic [2:0] direction, min_direction;


    logic right_stop_motion, left_stop_motion, up_stop_motion, down_stop_motion;

    int size = 8;

    always_comb
    begin
        direction = 5;
        min_direction = 0;

        if (min_distance == distance_up)
        min_direction = 3;

        else if (min_distance == distance_down)
        min_direction = 1;
        else if (min_distance == distance_left)
        min_direction = 2;
        else if (min_distance == distance_right)
        min_direction = 0;



        if (min_distance == distance_up && up_stop_motion == 1'b0)
        direction = 3;

        else if (min_distance == distance_down && down_stop_motion == 1'b0)
        direction = 1;
        else if (min_distance == distance_left && left_stop_motion == 1'b0)
        direction = 2;
        else if (min_distance == distance_right && right_stop_motion == 1'b0)
        direction = 0;

        else 
        begin
        case(min_direction)

            0: begin
                if (((distance_up - min_distance) <= (distance_down - min_distance)) && up_stop_motion == 0)
                direction = 3;

                else if (((distance_down - min_distance) <= (distance_up - min_distance)) && down_stop_motion == 0)
                direction = 1;

                else if (left_stop_motion == 0)
                direction = 2;
            end

            1: begin
                if (((distance_right - min_distance) <= (distance_left - min_distance)) && right_stop_motion == 0)
                direction = 0;

                else if (((distance_left - min_distance) <= (distance_right - min_distance)) && left_stop_motion == 0)
                direction = 2;

                else if (up_stop_motion == 0)
                direction = 3;
            end


            2: begin
                if (((distance_up - min_distance) <= (distance_down - min_distance)) && up_stop_motion == 0)
                direction = 3;

                else if (((distance_down - min_distance) <= (distance_up - min_distance)) && down_stop_motion == 0)
                direction = 1;

                else if (right_stop_motion == 0)
                direction = 0;

                end 


                3: begin
                    if (((distance_right - min_distance) <= (distance_left - min_distance)) && right_stop_motion == 0)
                    direction = 0;
    
                    else if (((distance_left - min_distance) <= (distance_right - min_distance)) && left_stop_motion == 0)
                    direction = 2;
    
                    else if (down_stop_motion == 0)
                    direction = 1;

                end


        endcase




        // if (right_stop_motion == 0)
        // direction = 0;


        // else if (up_stop_motion == 0)
        // direction = 3;


        // else if (left_stop_motion == 0)
        // direction = 2;

        // else if (down_stop_motion == 0)
        // direction = 1;


        

        end
        end



    always_ff @ (posedge Reset or posedge frame_clk)
    begin
        if (Reset)
            begin
                ghostX <= 384;
                ghostY <= 96;
                ghostXmotion <= 0;
                ghostYmotion <= 0;

            end


        else if (death)
        begin

            ghostXmotion <= 0;
            ghostYmotion <= 0;
        end

        else if (isDefeated == 1)
            begin
                ghostX <= 384;
                ghostY <= 96;
                ghostXmotion <= 0;
                ghostYmotion <= 0;

            end

        else if (hasMoved == 0)
        begin
            ghostXmotion <= 0;
            ghostYmotion <= 0;
        end
        
        else 
                begin
            case (direction)
                0: begin
                    ghostXmotion <= 1;
                    ghostYmotion <= 0;
                end

                1: begin
                    ghostXmotion <= 0;
                    ghostYmotion <= 1;
                end
                2: begin
                    ghostXmotion <= -1;
                    ghostYmotion <= 0;
                end
                3: begin
                    ghostXmotion <= 0;
                    ghostYmotion <= -1;
                end

            endcase

        ghostX <= ghostX + ghostXmotion;
        ghostY <= ghostY + ghostYmotion;
        end
    end


    assign ghost_redX = ghostX;
    assign ghost_redY = ghostY;


    four_direction_distance fdd(.*);


    ghost_wall_check gwc (.ghostX, .ghostY, .right_stop_motion, .up_stop_motion, .left_stop_motion, .down_stop_motion);

    findMinFour fmf (.A(distance_up), .B(distance_down), .C(distance_left), .D(distance_right), .minVal(min_distance));



endmodule




module ghost_green(input Reset, frame_clk, hasMoved, isDefeated, death, input logic [9:0] pacmanX, input logic [9:0] pacmanY, output [9:0] ghost_greenX, output [9:0] ghost_greenY );

    logic [9:0] ghostX, ghostY, ghostXmotion, ghostYmotion, optimal_X;

    logic [19:0] distance, distance_up, distance_down, distance_left, distance_right, min_distance;


    logic [2:0] direction, min_direction;


    logic right_stop_motion, left_stop_motion, up_stop_motion, down_stop_motion;

    int size = 8;

    always_comb
    begin
        direction = 5;
        min_direction = 0;

        if (min_distance == distance_up)
        min_direction = 3;

        else if (min_distance == distance_down)
        min_direction = 1;
        else if (min_distance == distance_left)
        min_direction = 2;
        else if (min_distance == distance_right)
        min_direction = 0;



        if (min_distance == distance_up && up_stop_motion == 1'b0)
        direction = 3;

        else if (min_distance == distance_down && down_stop_motion == 1'b0)
        direction = 1;
        else if (min_distance == distance_left && left_stop_motion == 1'b0)
        direction = 2;
        else if (min_distance == distance_right && right_stop_motion == 1'b0)
        direction = 0;

        else 
        begin
        case(min_direction)

            0: begin
                if (((distance_up - min_distance) <= (distance_down - min_distance)) && up_stop_motion == 0)
                direction = 3;

                else if (((distance_down - min_distance) <= (distance_up - min_distance)) && down_stop_motion == 0)
                direction = 1;

                else if (left_stop_motion == 0)
                direction = 2;
            end

            1: begin
                if (((distance_right - min_distance) <= (distance_left - min_distance)) && right_stop_motion == 0)
                direction = 0;

                else if (((distance_left - min_distance) <= (distance_right - min_distance)) && left_stop_motion == 0)
                direction = 2;

                else if (up_stop_motion == 0)
                direction = 3;
            end


            2: begin
                if (((distance_up - min_distance) <= (distance_down - min_distance)) && up_stop_motion == 0)
                direction = 3;

                else if (((distance_down - min_distance) <= (distance_up - min_distance)) && down_stop_motion == 0)
                direction = 1;

                else if (right_stop_motion == 0)
                direction = 0;

                end 


                3: begin
                    if (((distance_right - min_distance) <= (distance_left - min_distance)) && right_stop_motion == 0)
                    direction = 0;
    
                    else if (((distance_left - min_distance) <= (distance_right - min_distance)) && left_stop_motion == 0)
                    direction = 2;
    
                    else if (down_stop_motion == 0)
                    direction = 1;

                end


        endcase




        // if (right_stop_motion == 0)
        // direction = 0;


        // else if (up_stop_motion == 0)
        // direction = 3;


        // else if (left_stop_motion == 0)
        // direction = 2;

        // else if (down_stop_motion == 0)
        // direction = 1;


        

        end
        end



    always_ff @ (posedge Reset or posedge frame_clk)
    begin

            if (Reset)


            begin

                ghostX <= 384;
                ghostY <= 88;
                ghostXmotion <= 0;
                ghostYmotion <= 0;

            end


            else if (death)
            begin
    
                ghostXmotion <= 0;
                ghostYmotion <= 0;
            end



            else if (isDefeated == 1)
            begin
                ghostXmotion <= 0;
                ghostYmotion <= 0;
                ghostX <= 384;
                ghostY <= 88;
            end



            else if (hasMoved == 0)
            begin
                ghostXmotion <= 0;
                ghostYmotion <= 0;
            
            end
            else 
                begin
            case (direction)
                0: begin
                    ghostXmotion <= 1;
                    ghostYmotion <= 0;
                end

                1: begin
                    ghostXmotion <= 0;
                    ghostYmotion <= 1;
                end
                2: begin
                    ghostXmotion <= -1;
                    ghostYmotion <= 0;
                end
                3: begin
                    ghostXmotion <= 0;
                    ghostYmotion <= -1;
                end
                
                5 : begin
                    ghostXmotion <= 0;
                    ghostYmotion <= 0;
                end
            endcase

        ghostX <= ghostX + ghostXmotion;
        ghostY <= ghostY + ghostYmotion;
        end
    end


    assign ghost_greenX = ghostX;
    assign ghost_greenY = ghostY;

    
    four_direction_distance #(.VERT_OFFSET(5)) fdd (.*);


    ghost_wall_check gwc (.ghostX, .ghostY, .right_stop_motion, .up_stop_motion, .left_stop_motion, .down_stop_motion);

    findMinFour fmf (.A(distance_up), .B(distance_down), .C(distance_left), .D(distance_right), .minVal(min_distance));


endmodule



module ghost_aqua (input Reset, frame_clk, hasMoved, isDefeated, death, input logic [9:0] pacmanX, input logic [9:0] pacmanY, output [9:0] ghost_aquaX, output [9:0] ghost_aquaY );

    logic [9:0] ghostX, ghostY, ghostXmotion, ghostYmotion, optimal_X;

    logic [19:0] distance, distance_up, distance_down, distance_left, distance_right, min_distance;


    logic [2:0] direction, min_direction;


    logic right_stop_motion, left_stop_motion, up_stop_motion, down_stop_motion;

    int size = 8;

    always_comb
    begin
        direction = 5;
        min_direction = 0;

        if (min_distance == distance_up)
        min_direction = 3;

        else if (min_distance == distance_down)
        min_direction = 1;
        else if (min_distance == distance_left)
        min_direction = 2;
        else if (min_distance == distance_right)
        min_direction = 0;



        if (min_distance == distance_up && up_stop_motion == 1'b0)
        direction = 3;

        else if (min_distance == distance_down && down_stop_motion == 1'b0)
        direction = 1;
        else if (min_distance == distance_left && left_stop_motion == 1'b0)
        direction = 2;
        else if (min_distance == distance_right && right_stop_motion == 1'b0)
        direction = 0;

        else 
        begin
        case(min_direction)

            0: begin
                if (((distance_up - min_distance) <= (distance_down - min_distance)) && up_stop_motion == 0)
                direction = 3;

                else if (((distance_down - min_distance) <= (distance_up - min_distance)) && down_stop_motion == 0)
                direction = 1;

                else if (left_stop_motion == 0)
                direction = 2;
            end

            1: begin
                if (((distance_right - min_distance) <= (distance_left - min_distance)) && right_stop_motion == 0)
                direction = 0;

                else if (((distance_left - min_distance) <= (distance_right - min_distance)) && left_stop_motion == 0)
                direction = 2;

                else if (up_stop_motion == 0)
                direction = 3;
            end


            2: begin
                if (((distance_up - min_distance) <= (distance_down - min_distance)) && up_stop_motion == 0)
                direction = 3;

                else if (((distance_down - min_distance) <= (distance_up - min_distance)) && down_stop_motion == 0)
                direction = 1;

                else if (right_stop_motion == 0)
                direction = 0;

                end 


                3: begin
                    if (((distance_right - min_distance) <= (distance_left - min_distance)) && right_stop_motion == 0)
                    direction = 0;
    
                    else if (((distance_left - min_distance) <= (distance_right - min_distance)) && left_stop_motion == 0)
                    direction = 2;
    
                    else if (down_stop_motion == 0)
                    direction = 1;

                end


        endcase




        // if (right_stop_motion == 0)
        // direction = 0;


        // else if (up_stop_motion == 0)
        // direction = 3;


        // else if (left_stop_motion == 0)
        // direction = 2;

        // else if (down_stop_motion == 0)
        // direction = 1;


        

        end
        end



    always_ff @ (posedge frame_clk or posedge Reset)
    begin
        if (Reset)


        begin

            ghostX <= 88;
            ghostY <= 400;
            ghostXmotion <= 0;
            ghostYmotion <= 0;

        end

        else if (death)
        begin

            ghostXmotion <= 0;
            ghostYmotion <= 0;
        end


        else if (isDefeated == 1)
            begin
                ghostX <= 88;
            ghostY <= 400;
                ghostXmotion <= 0;
                ghostYmotion <= 0;
            end

        else if (hasMoved == 0)
        begin
            ghostXmotion <= 0;
            ghostYmotion <= 0;
        
        end



            else 
                begin
            case (direction)
                0: begin
                    ghostXmotion <= 1;
                    ghostYmotion <= 0;
                end

                1: begin
                    ghostXmotion <= 0;
                    ghostYmotion <= 1;
                end
                2: begin
                    ghostXmotion <= -1;
                    ghostYmotion <= 0;
                end
                3: begin
                    ghostXmotion <= 0;
                    ghostYmotion <= -1;
                end
                
                5 : begin
                    ghostXmotion <= 0;
                    ghostYmotion <= 0;
                end
            endcase

        ghostX <= ghostX + ghostXmotion;
        ghostY <= ghostY + ghostYmotion;
        end
    end


    assign ghost_aquaX = ghostX;
    assign ghost_aquaY = ghostY;

    
    four_direction_distance #(.HORIZ_OFFSET(10)) fdd (.*);


    ghost_wall_check gwc (.ghostX, .ghostY, .right_stop_motion, .up_stop_motion, .left_stop_motion, .down_stop_motion);

    findMinFour fmf (.A(distance_up), .B(distance_down), .C(distance_left), .D(distance_right), .minVal(min_distance));

endmodule




module ghost_wall_check #(X_MOTION = 1, Y_MOTION = 1) 

    (input [9:0] ghostX, ghostY, output right_stop_motion, up_stop_motion, left_stop_motion, down_stop_motion);

    sprite_wall sw_right(.X(ghostX), .Y(ghostY), .X_motion(1'b1), .Y_motion(0), .stop_motion(right_stop_motion));

    sprite_wall sw_up(.X(ghostX), .Y(ghostY), .X_motion(0), .Y_motion(-1), .stop_motion(up_stop_motion));
    sprite_wall sw_down(.X(ghostX), .Y(ghostY), .X_motion(0), .Y_motion(1'b1), .stop_motion(down_stop_motion));
    sprite_wall sw_left(.X(ghostX), .Y(ghostY), .X_motion(-1), .Y_motion(0), .stop_motion(left_stop_motion));


endmodule


module four_direction_distance #(parameter HORIZ_OFFSET = 0, parameter VERT_OFFSET = 0)
    
    (input [9:0] pacmanX, pacmanY, ghostX, ghostY, output [19:0] distance, distance_down, distance_left, distance_up, distance_right);

    ghost_pacman_distance pd (.pacmanX, .pacmanY, .ghostX(ghostX), .ghostY(ghostY), .distance);

    ghost_pacman_distance pd_up (.pacmanX, .pacmanY, .ghostX(ghostX + HORIZ_OFFSET), .ghostY(ghostY-1 + VERT_OFFSET), .distance(distance_up));
    ghost_pacman_distance pd_right (.pacmanX, .pacmanY, .ghostX(ghostX+1 + HORIZ_OFFSET), .ghostY(ghostY + VERT_OFFSET), .distance(distance_right));
    ghost_pacman_distance pd_down (.pacmanX, .pacmanY, .ghostX(ghostX + HORIZ_OFFSET), .ghostY(ghostY+1 + VERT_OFFSET), .distance(distance_down));
    ghost_pacman_distance pd_left (.pacmanX, .pacmanY, .ghostX(ghostX-1 + HORIZ_OFFSET), .ghostY(ghostY + VERT_OFFSET), .distance(distance_left));


endmodule



module ghost_pacman_distance(input [9:0] pacmanX, pacmanY, ghostX, ghostY, output [19:0] distance);


    assign distance = (pacmanX-ghostX)*(pacmanX - ghostX) + (pacmanY - ghostY)*(pacmanY - ghostY);



endmodule



module ghost_pac_dist (input [9:0] pacmanX, pacmanY, ghostX, ghostY, ghostXmotion, ghostYmotion, output [19:0] distance);

logic [9:0] ghostXPos, ghostYPos;

always_comb
begin
ghostXPos = ghostX;
ghostYPos = ghostY;
if (ghostXmotion == 1)
ghostXPos = ghostX + 1;
if (ghostXmotion != 0)
ghostXPos = ghostX -1;
if (ghostYmotion == 1)
ghostYPos = ghostY +1;
if (ghostYmotion != 0)
ghostYPos = ghostY -1;
end

ghost_pacman_distance gp(.pacmanX, .pacmanY, .ghostX(ghostXPos), .ghostY(ghostYPos), .distance);

endmodule



module findMinFour(input logic [19:0] A, B, C, D, output [19:0] minVal);

    logic [19:0] minVal_;
	 
	 always_comb 
	 begin
	

	  minVal_ = A;
      minVal_ = (B < minVal_)? B: minVal_;

      minVal_ = (C < minVal_)? C: minVal_;

      minVal_ = (D < minVal_)? D: minVal_;
	 
	 
	 end

    assign minVal = minVal_;


endmodule
//-------------------------------------------------------------------------
//    Color_Mapper.sv                                                    --
//    Stephen Kempf                                                      --
//    3-1-06                                                             --
//                                                                       --
//    Modified by David Kesler  07-16-2008                               --
//    Translated by Joe Meng    07-07-2013                               --
//                                                                       --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 385 Lab 7                                         --
//    University of Illinois ECE Department                              --
//-------------------------------------------------------------------------


module  color_mapper ( input        [9:0] pacmanX, pacmanY, DrawX, DrawY, ghost_redX, ghost_redY,ghost_greenX, ghost_greenY, ghost_aquaX, ghost_aquaY,
                       input Clk, input isDefeated, death, closePacman, reversal, red_enable, green_enable, aqua_enable, input [1:0] lives, input [41:0][41:0] dots, input first_on, second_on, third_on, input [9:0] fruit_location [6], input logic [1:0] last_keypress,
                       output logic [7:0]  Red, Green, Blue );
    
    logic pacman_on, ghost_red_on, ghost_green_on, wall_on, ghost_aqua_on;
	 
 /* Old Ball: Generated square box by checking if the current pixel is within a square of length
    2*Ball_Size, centered at (BallX, BallY).  Note that this requires unsigned comparisons.
	 
    if ((DrawX >= BallX - Ball_size) &&
       (DrawX <= BallX + Ball_size) &&
       (DrawY >= BallY - Ball_size) &&
       (DrawY <= BallY + Ball_size))

     New Ball: Generates (pixelated) circle by using the standard circle formula.  Note that while 
     this single line is quite powerful descriptively, it causes the synthesis tool to use up three
     of the 12 available multipliers on the chip!  Since the multiplicants are required to be signed,
	  we have to first cast them from logic to int (signed by default) before they are multiplied). */
	 logic [7:0] RGB_data, RGB_data_right, RGB_data_top, RGB_data_bottom, ghost_red_data, ghost_green_data, ghost_aqua_data, game_over_data, pac_data_closed, fruit1_data, fruit2_data, fruit3_data, dot_data, lives_data;
    logic [10:0] game_over_addr, lives_addr;
	 int DistX, DistY;



	assign DistX = DrawX - pacmanX;
    assign DistY = DrawY - pacmanY;
	  
    logic isEaten;

    always_comb
    begin:pacman_on_proc
        pacman_on = 1'b0;
        if ( DistX < 8 && DistX >= 0 && DistY < 8 && DistY >= 0)
		  pacman_on = 1'b1;
  
        
		
     end
     
       


    always_comb
    begin:RGB_Display

        Red = 0;
        Blue = 0;
        Green = 0;
		  game_over_addr = 0;
          lives_addr = 0;

			if (death == 0)
			begin

                Red = 0;
                Blue = 0;
                Green = 0;

                if (DrawX >= 456 && DrawX < 520 && DrawY >= 96 && DrawY < 112)
                begin

                    case(((DrawX - 456) >> 3))
                         0: lives_addr= (8'h6c *16 + DrawY -96); //L
                         1: lives_addr = (8'h69 * 16 + DrawY - 96); //I
                         2: lives_addr = (8'h76 * 16 + DrawY - 96); //V
                         3: lives_addr = (8'h65 * 16 + DrawY - 96); //E
                         4: lives_addr = (8'h73 * 16 + DrawY - 96); //S 
                         5: lives_addr = (8'h3a * 16 + DrawY - 96); //:
								 6: lives_addr = (8'h00 * 16 + DrawY - 96); // 
                         7: lives_addr = ((lives + 8'h30) * 16 + DrawY - 96); //#
                         default: lives_addr = 0;

                    endcase

                    if (lives_data[7-((DrawX - 456)%8)] == 1)
                    begin
                        Red = 8'hff;
			            Blue = 8'hff;
			            Green = 8'hff; 
                    end

                end

                if (DrawX >= 56 && DrawX <= 392 && DrawY >= 56 && DrawY <= 392)
                begin
                    if (dots[(DrawX-56)/8][(DrawY-56)/8] == 1)
                    begin
                        if (dot_data[((DrawX - 56)%8)] == 1)
                        begin
                            Red = 8'hff;
                            Green = 8'hb2;
                            Blue = 8'h66;
                        end

                    end

                end

                if (first_on == 1)
        begin
            if (((DrawX - fruit_location[0]) >= 0) && ((DrawX - fruit_location[0]) < 8) && ((DrawY - fruit_location[1]) >= 0) && ((DrawY - fruit_location[1]) < 8))
            begin 
                if (fruit1_data[7-(DrawX - fruit_location[4])] == 1)
                begin
                Red = 8'h7f;

                Blue = 8'hff;


                Green = 0;

                end

            end

        end



        if (second_on == 1)
        begin
            if (((DrawX - fruit_location[2]) >= 0) && ((DrawX - fruit_location[2]) < 8) && ((DrawY - fruit_location[3]) >= 0) && ((DrawY - fruit_location[3]) < 8))
            begin 
                
                if (fruit2_data[7-(DrawX - fruit_location[4])] == 1)
                begin
                Red = 8'h7f;

                Blue = 8'hff;


                Green = 0;

                end

            
            end
        end


        if (third_on == 1)
        begin
            if (((DrawX - fruit_location[4]) >= 0) && ((DrawX - fruit_location[4]) < 8) && ((DrawY - fruit_location[5]) >= 0) && ((DrawY - fruit_location[5]) < 8))
            begin 

                if (fruit3_data[7-(DrawX - fruit_location[4])] == 1)
                begin
                Red = 8'h7f;

                Blue = 8'hff;


                Green = 0;

                end

            end

        end



        if (wall_on == 1'b1)
        begin
            Red = 0;
            Blue = 8'hff;
            Green = 0;
        end




        else if ((pacman_on == 1'b1)) 
        begin 
		  Red = 0;
		  Blue = 0; 
		  Green = 0;


        if (closePacman == 1)
        begin

            if (pac_data_closed[7-DistX] == 1)
            begin
                Red = 8'hff;
				Blue = 8'h0;
				Green = 8'hff;
            end

        end

        else 
        begin

          if (last_keypress == 0)
          begin
            if (RGB_data_right[7-DistX] == 1'b1)
				begin
				Red = 8'hff;
				Blue = 8'h0;
				Green = 8'hff;
				end
        end

        else if (last_keypress == 1)
        begin
            if (RGB_data_bottom[7-DistX] == 1'b1)
            begin
                Red = 8'hff;
				Blue = 8'h0;
				Green = 8'hff;
            end
        end 

        else if (last_keypress == 2)
        begin
            if (RGB_data_right[DistX] == 1'b1)
				begin
				Red = 8'hff;
				Blue = 8'h0;
				Green = 8'hff;
				end
        end

        else if (last_keypress == 3)
        begin
            if (RGB_data_top[7-DistX] == 1'b1)
				begin
				Red = 8'hff;
				Blue = 8'h0;
				Green = 8'hff;
			end


        end

    end

end
    
    else if (ghost_red_on == 1'b1 && red_enable == 1)

    begin
        Red = 0;
        Green = 0;
        Blue = 0;
        if (ghost_red_data[7-(DrawX-ghost_redX)] == 1'b1)
        begin
            if (reversal == 0)
            begin
            Red = 8'hff; 
            Blue = 8'h0;
            Green = 8'h0;
            end

            else
            begin
                Blue = 8'hff;
            end
        end
    end
    
    else if (ghost_green_on == 1'b1 && green_enable == 1)

    begin
        Red = 0;
        Green = 0;
        Blue = 0;
        if (ghost_green_data[7-(DrawX-ghost_greenX)] == 1'b1)
        begin
            if (reversal == 0)
            begin
            Red = 8'h0; 
            Blue = 8'h0;
            Green = 8'hff;
            end

            else
            Blue = 8'hff;
        end
    end
    
    else if (ghost_aqua_on == 1'b1 && aqua_enable == 1)

    begin
        Red = 0;
        Green = 0;
        Blue = 0;
        if (ghost_aqua_data[7-(DrawX-ghost_aquaX)] == 1'b1)
        begin
            if (reversal == 0)
            begin
            Red = 8'h33; 
            Blue = 8'hff;
            Green = 8'hff;
            end
            else 
            Blue = 8'hff;
        end
    end

		end
		
		else
		begin
		Red = 0; 
		Blue = 0;
		Green = 0;
		game_over_addr = 0;
		if (DrawY >= 240 && DrawY < 256 && DrawX >= 296 && DrawX < 368)
		begin
		
		case(((DrawX - 296) >> 3))
		    0: game_over_addr = (8'h67 *16 + DrawY -240); //G
			 1: game_over_addr = (8'h61 * 16 + DrawY - 240); //A
			 2: game_over_addr = (8'h6D * 16 + DrawY - 240); //M
			 3: game_over_addr = (8'h65 * 16 + DrawY - 240); //E
			 4: game_over_addr = (8'h00 * 16 + DrawY - 240); // 
			 5: game_over_addr = (8'h6F * 16 + DrawY - 240); //O
			 6: game_over_addr = (8'h76 * 16 + DrawY - 240); //V
			 7: game_over_addr = (8'h65 * 16 + DrawY - 240); //E
			 8: game_over_addr = (8'h72 * 16 + DrawY - 240); //R
			default: game_over_addr = 0;
		
		
		endcase
		
		case (game_over_data[7-((DrawX - 296)%8)])
		
		1: begin
			Red = 8'hff;
			Blue = 8'h0;
			Green = 8'hff; 
			end
			
		0: begin 
			Red = 8'h0;
			Blue = 8'h0;
			Green = 8'h0; 
			end

        default : begin
            Red = 0;
            Blue = 0;
            Green = 0;

        end
			
		endcase
		
		end
		
		
		end

    end 
    
	 
	 pacman_rom_right pac_right(.addr(DistY), .data(RGB_data_right));
     pacman_rom_up top_pac(.addr(DistY), .data(RGB_data_top));
	pacman_rom_up pacbottom(.addr(7-DistY), .data(RGB_data_bottom));

    pacman_rom_closed pacclosed (.addr(DistY), .data(pac_data_closed));



    ghost ghost_red(.addr(DrawY - ghost_redY),  .data(ghost_red_data));
    ghost ghost_green(.addr(DrawY - ghost_greenY),  .data(ghost_green_data));
    ghost ghost_aqua(.addr(DrawY - ghost_aquaY), .data(ghost_aqua_data));

    ghost_on go (.*);

    check_wall cw(.DrawX, .DrawY, .wallEnable(wall_on));
	 
	 font_rom game_over (.addr(game_over_addr), .data(game_over_data));

     font_rom lives_rom (.addr(lives_addr), .data(lives_data));


     fruit f1 (.addr(DrawY - fruit_location[1]), .data(fruit1_data));


     fruit f2 (.addr(DrawY - fruit_location[3]), .data(fruit2_data));

     fruit f3 (.addr(DrawY - fruit_location[5]), .data(fruit3_data));


     dot d1 (.addr((DrawY - 56)%8), .data(dot_data));
	 
endmodule


module ghost_on (input [9:0] DrawX, DrawY, ghost_redX, ghost_redY,ghost_greenX, ghost_greenY, ghost_aquaX, ghost_aquaY, output ghost_red_on, ghost_aqua_on, ghost_green_on);

    always_comb begin

        ghost_red_on = 1'b0;
        ghost_green_on = 1'b0;
        ghost_aqua_on = 1'b0;

        if (DrawX - ghost_redX >= 0 && DrawX - ghost_redX < 8 && DrawY - ghost_redY >=0 && DrawY - ghost_redY < 8)
        ghost_red_on = 1'b1;

        if (DrawX - ghost_greenX >= 0 && DrawX - ghost_greenX < 8 && DrawY - ghost_greenY >=0 && DrawY - ghost_greenY < 8)
        ghost_green_on = 1'b1;


        if (DrawX - ghost_aquaX >= 0 && DrawX - ghost_aquaX < 8 && DrawY - ghost_aquaY >=0 && DrawY - ghost_aquaY < 8)
        ghost_aqua_on = 1'b1;


    end


endmodule





//-------------------------------------------------------------------------
//    Ball.sv                                                            --
//    Viral Mehta                                                        --
//    Spring 2005                                                        --
//                                                                       --
//    Modified by Stephen Kempf 03-01-2006                               --
//                              03-12-2007                               --
//    Translated by Joe Meng    07-07-2013                               --
//    Fall 2014 Distribution                                             --
//                                                                       --
//    For use with ECE 298 Lab 7                                         --
//    UIUC ECE Department                                                --
//-------------------------------------------------------------------------


module  pacman ( input Reset, frame_clk, isDefeated, death,
					input [7:0] keycode,
               output [9:0]  BallX, BallY, output logic [1:0] last_keypress, output logic hasMoved);
    
    logic [9:0] Ball_X_Pos, Ball_X_Motion, Ball_Y_Pos, Ball_Y_Motion;
	 
    parameter [9:0] Ball_X_Center=304;  // Center position on the X axis
    parameter [9:0] Ball_Y_Center=248;  // Center position on the Y axis
    parameter [9:0] Ball_X_Min=0;       // Leftmost point on the X axis
    parameter [9:0] Ball_X_Max=639;     // Rightmost point on the X axis
    parameter [9:0] Ball_Y_Min=0;       // Topmost point on the Y axis
    parameter [9:0] Ball_Y_Max=479;     // Bottommost point on the Y axis
    parameter [9:0] Ball_X_Step=1;      // Step size on the X axis
    parameter [9:0] Ball_Y_Step=1;      // Step size on the Y axis

	int ball_size = 8;
	
	logic stop_motion;

   
    always_ff @ (posedge Reset or posedge frame_clk)
    begin: Move_Pacman
        if (Reset)  // Asynchronous Reset
        begin 
            	Ball_Y_Motion <= 10'b0; //Ball_Y_Step;
				Ball_X_Motion <= 10'b0; //Ball_X_Step;
				Ball_Y_Pos <= Ball_Y_Center;
				Ball_X_Pos <= Ball_X_Center;
				last_keypress <= 0; 
				hasMoved <= 0;
        end

		else if (death == 1)

		begin
			Ball_X_Motion <= 0;
			Ball_Y_Motion <= 0;
		end


		else if (isDefeated == 1) //life lost

		begin


			Ball_Y_Motion <= 10'b0; //Ball_Y_Step;
			Ball_X_Motion <= 10'b0; //Ball_X_Step;
			Ball_Y_Pos <= Ball_Y_Center;
			Ball_X_Pos <= Ball_X_Center;
			hasMoved <= 0;
		    last_keypress <= 0; 

		end


		else if (stop_motion == 1'b1)
		begin
									Ball_X_Motion <= 0;
									Ball_Y_Motion <= 0;
		end
           
        // else 
        // begin 
		// 		 if ( (Ball_Y_Pos + ball_size) >= Ball_Y_Max )  // Ball is at the bottom edge, BOUNCE!
		// 			  begin
		// 			  Ball_Y_Motion <= -1;  // 2's complement.
		// 			  Ball_X_Motion <= 0;
		// 			  last_keypress <= 3;
					  
		// 			  end
		// 		 else if ( (Ball_Y_Pos - ball_size) <= Ball_Y_Min )  // Ball is at the top edge, BOUNCE!
		// 			  begin
		// 			  Ball_Y_Motion <= 1;
		// 			  Ball_X_Motion <= 0;
					  
		// 			  last_keypress <= 1;
					  
					  
		// 			  end
		// 		  else if ( (Ball_X_Pos + ball_size) >= Ball_X_Max )  // Ball is at the Right edge, BOUNCE!
		// 			  begin
		// 			  Ball_X_Motion <= -1;  // 2's complement.
		// 			  Ball_Y_Motion <= 0; 
		// 			  last_keypress <= 2;
					  
					  
		// 			  end
		// 		 else if ( (Ball_X_Pos - ball_size) <= Ball_X_Min )  // Ball is at the Left edge, BOUNCE!
		// 			  begin
		// 			  Ball_X_Motion <= 1;
		// 			  Ball_Y_Motion <= 0; 
		// 			  last_keypress <= 0;
					  
					  
					  
					  
		// 			  end
				 else 
					  begin // Ball is somewhere in the middle, don't bounce, just keep moving
				 unique case (keycode)
					8'h04 : begin

								
								Ball_X_Motion <= -1;//A
								Ball_Y_Motion<= 0;
								hasMoved <= 1;
								last_keypress <= 2;
							  end
					        
					8'h07 : begin

							
								
					          Ball_X_Motion <= 1;//D
							  Ball_Y_Motion <= 0;
							  last_keypress <= 0;
							  hasMoved <= 1;
							  end

					8'h16 : begin

					          Ball_Y_Motion <= 1;//S
							  Ball_X_Motion <= 0;
							  last_keypress <= 1;
							  hasMoved <= 1;
							 end
							  
					8'h1A : begin
					          Ball_Y_Motion <= -1;//W
							  Ball_X_Motion <= 0;
							  last_keypress <= 3;
							  hasMoved <= 1;
							 end	  
					default: ;
			   endcase
				 Ball_Y_Pos <= (Ball_Y_Pos + Ball_Y_Motion);  // Update ball position
				 Ball_X_Pos <= (Ball_X_Pos + Ball_X_Motion);
					  end
			
	  /**************************************************************************************
	    ATTENTION! Please answer the following quesiton in your lab report! Points will be allocated for the answers!
		 Hidden Question #2/2:
          Note that Ball_Y_Motion in the above statement may have been changed at the same clock edge
          that is causing the assignment of Ball_Y_pos.  Will the new value of Ball_Y_Motion be used,
          or the old?  How will this impact behavior of the ball during a bounce, and how might that 
          interact with a response to a keypress?  Can you fix it?  Give an answer in your Post-Lab.
      **************************************************************************************/
      
			
		end  
       
    assign BallX = Ball_X_Pos;
   
    assign BallY = Ball_Y_Pos;
    

	sprite_wall sw(.X(Ball_X_Pos), .Y(Ball_Y_Pos), .X_motion(Ball_X_Motion), .Y_motion(Ball_Y_Motion), .stop_motion);


	


endmodule

//-------------------------------------------------------------------------
//                                                                       --
//                                                                       --
//      For use with ECE 385 Lab 62                                       --
//      UIUC ECE Department                                              --
//-------------------------------------------------------------------------


module lab62 (

      ///////// Clocks /////////
      input     MAX10_CLK1_50, 

      ///////// KEY /////////
      input    [ 1: 0]   KEY,

      ///////// SW /////////
      input    [ 9: 0]   SW,

      ///////// LEDR /////////
      output   [ 9: 0]   LEDR,

      ///////// HEX /////////
      output   [ 7: 0]   HEX0,
      output   [ 7: 0]   HEX1,
      output   [ 7: 0]   HEX2,
      output   [ 7: 0]   HEX3,
      output   [ 7: 0]   HEX4,
      output   [ 7: 0]   HEX5,

      ///////// SDRAM /////////
      output             DRAM_CLK,
      output             DRAM_CKE,
      output   [12: 0]   DRAM_ADDR,
      output   [ 1: 0]   DRAM_BA,
      inout    [15: 0]   DRAM_DQ,
      output             DRAM_LDQM,
      output             DRAM_UDQM,
      output             DRAM_CS_N,
      output             DRAM_WE_N,
      output             DRAM_CAS_N,
      output             DRAM_RAS_N,

      ///////// VGA /////////
      output             VGA_HS,
      output             VGA_VS,
      output   [ 3: 0]   VGA_R,
      output   [ 3: 0]   VGA_G,
      output   [ 3: 0]   VGA_B,


      ///////// ARDUINO /////////
      inout    [15: 0]   ARDUINO_IO,
      inout              ARDUINO_RESET_N 

);




logic Reset_h, vssig, blank, sync, VGA_Clk;


//=======================================================
//  REG/WIRE declarations
//=======================================================
	logic SPI0_CS_N, SPI0_SCLK, SPI0_MISO, SPI0_MOSI, USB_GPX, USB_IRQ, USB_RST;
	logic [3:0] hex_num_4, hex_num_3, hex_num_1, hex_num_0; //4 bit input hex digits
	logic [1:0] signs;
	logic [1:0] hundreds;
	logic [9:0] drawxsig, drawysig, ballxsig, ballysig, ballsizesig, ghost_redX, ghost_redY, ghost_greenX, ghost_greenY, ghost_aquaX, ghost_aquaY;
	logic [7:0] Red, Blue, Green;
	logic [7:0] keycode;
	logic [1:0] last_keypress;

//=======================================================
//  Structural coding
//=======================================================
	// assign ARDUINO_IO[10] = SPI0_CS_N;
	// assign ARDUINO_IO[13] = SPI0_SCLK;
	// assign ARDUINO_IO[11] = SPI0_MOSI;
	// assign ARDUINO_IO[12] = 1'bZ;
	// assign SPI0_MISO = ARDUINO_IO[12];
	
	// assign ARDUINO_IO[9] = 1'bZ; 
	// assign USB_IRQ = ARDUINO_IO[9];
		
	// //Assignments specific to Circuits At Home UHS_20
	// assign ARDUINO_RESET_N = USB_RST;
	// assign ARDUINO_IO[7] = USB_RST;//USB reset 
	// assign ARDUINO_IO[8] = 1'bZ; //this is GPX (set to input)
	// assign USB_GPX = 1'b0;//GPX is not needed for standard USB host - set to 0 to prevent interrupt
	
	// //Assign uSD CS to '1' to prevent uSD card from interfering with USB Host (if uSD card is plugged in)
	// assign ARDUINO_IO[6] = 1'b1;
	
	// //HEX drivers to convert numbers to HEX output
	// HexDriver hex_driver4 (score[3:0], HEX4[6:0]);
	// assign HEX4[7] = 1'b1;
	
	// HexDriver hex_driver3 (score[5:4], HEX3[6:0]);
	// assign HEX3[7] = 1'b1;
	
	// HexDriver hex_driver1 (hex_num_1, HEX1[6:0]);
	// assign HEX1[7] = 1'b1;
	
	// HexDriver hex_driver0 (hex_num_0, HEX0[6:0]);
	// assign HEX0[7] = 1'b1;
	
	// //fill in the hundreds digit as well as the negative sign
	// assign HEX5 = {1'b1, ~signs[1], 3'b111, ~hundreds[1], ~hundreds[1], 1'b1};
	// assign HEX2 = {1'b1, ~signs[0], 3'b111, ~hundreds[0], ~hundreds[0], 1'b1};
	
	logic [4:0] command_channel, response_channel;

	logic [11:0] response_data, y_val, x_val; 

	logic command_ready, response_valid, response_endofpacket, response_startofpacket, sys_clk;
	
	//Assign one button to reset
	assign {Reset_h}=~ (KEY[0]);

	//Our A/D converter is only 12 bit
	assign VGA_R = Red[7:4];
	assign VGA_B = Blue[7:4];
	assign VGA_G = Green[7:4];
	
	
	lab62soc u0 (
		
		.clk_clk                              (MAX10_CLK1_50),                              //                    clk.clk
        .reset_reset_n                        (1'b1),                        //                  reset.reset_n
        .modular_adc_0_command_valid          (1'b1),          //  modular_adc_0_command.valid
        .modular_adc_0_command_channel        (command_channel),        //                       .channel
        .modular_adc_0_command_startofpacket  (1'b1),  //                       .startofpacket
        .modular_adc_0_command_endofpacket    (1'b1),    //                       .endofpacket
        .modular_adc_0_command_ready          (command_ready),          //                       .ready
        .modular_adc_0_response_valid         (response_valid),         // modular_adc_0_response.valid
        .modular_adc_0_response_channel       (response_channel),       //                       .channel
        .modular_adc_0_response_data          (response_data),          //                       .data
        .modular_adc_0_response_startofpacket (response_startofpacket), //                       .startofpacket
        .modular_adc_0_response_endofpacket   (response_endofpacket),    //                       .endofpacket
        .clock_bridge_sys_out_clk_clk         (sys_clk)          // clock_bridge_sys_out_clk.clk
	 );

	 always_ff @ (posedge sys_clk or posedge Reset_h)

	 begin
		if (Reset_h)
		begin
			command_channel <= 5'b00000;
		end

		else if (command_channel == 2)
		begin
			command_channel <= 5'b00001;

		end

		else
		begin
			command_channel <= (command_channel + 1);
		end 



	 end

	 always_ff @ (posedge sys_clk)
	 begin
		if (response_valid)
		begin
			if (response_channel == 1)
			begin

				y_val <= response_data;
			end

			else if (response_channel == 2)
			x_val <= response_data;

		end

	 end

	assign LEDR[9] = response_channel;

	 logic [19:0] distance_red, distance_green, distance_aqua, distance1, distance2, distance3;

	 logic [1:0] lives;

	 logic hasMoved, isDefeated, predator, death, closePacman, reversal;

	 logic red_enable, green_enable, aqua_enable;

	logic first_on, second_on, third_on;

	 logic [9:0] fruit_location [6] = '{184, 80, 208, 256, 232, 352};

	 logic [9:0] reversal_counter;

	 always_ff @ (posedge VGA_VS or posedge Reset_h)
	 begin

		if (Reset_h)
		begin
			lives <= 2;
			death <= 0;
			aqua_enable <= 1;
			red_enable <= 1;
			green_enable <= 1;
		end


		else if (lives <= 0)
		death <= 1;

		else if (isDefeated == 1)
		begin
			if (lives > 0)
			lives <= (lives-1);

		end

		else if (predator == 1)
		begin

				if (distance_red < 64)
				red_enable <= 0;

				if (distance_green < 64)
				green_enable <= 0; 

				if (distance_aqua < 64)
				aqua_enable <= 0;


		end




		end

	 assign distance1 = (ballxsig - 184)*(ballxsig-184) + (ballysig - 80)*(ballysig - 80);
	 assign distance2 = (ballxsig - 208)*(ballxsig-208) + (ballysig - 256)*(ballysig - 256);
	 assign distance3 = (ballxsig - 232)*(ballxsig-232) + (ballysig - 352)*(ballysig - 352);


	 always_ff@ (posedge VGA_VS or posedge Reset_h)


	 begin
		if (Reset_h)
		begin
			first_on <= 1'b1;
			second_on <= 1'b1;
			third_on <= 1'b1;
			reversal_counter <= 0;
		end 

		else if (reversal_counter == 540)
		begin
			reversal <= 0;
			reversal_counter <= 0;
		end 


		else if (reversal == 1)
		begin
			reversal_counter <= (reversal_counter + 1);
		end

		else if (distance1 < 64)
		// enable_fruit[0] <= 0;
		begin



		if (first_on == 1)
		begin
		first_on <= 1'b0;
		reversal <= 1'b1;
		end


		end

		else if (distance2 < 64)
		// enable_fruit[1] <= 0;

		begin



		if (second_on == 1)
		begin
		second_on <= 1'b0;
		reversal <= 1'b1;
		end


		end
		else if (distance3 < 64)
		begin
		// enable_fruit[2] <= 0;

		if (third_on == 1)
		begin
		third_on <= 1'b0;
		reversal <= 1'b1;
		end

		end
		
		

	 end


	 
	 
	 always_comb begin
		isDefeated = 0;
		predator = 0;
	 	if (reversal == 0 && ((distance_red < 64 && red_enable == 1)|| (distance_green < 64 && green_enable == 1) || (distance_aqua < 64 && aqua_enable == 1)))
			isDefeated = 1;

		if (reversal == 1 && ((distance_red < 64 && red_enable == 1)|| (distance_green < 64 && green_enable == 1) || (distance_aqua < 64 && aqua_enable == 1)))
			predator = 1;
		
	 
	 end



	 logic [41:0][41:0] dots = '1;
	 //
	 logic [10:0] score;

	 always_ff @ (posedge Reset_h or posedge VGA_VS)
	 begin
	 if (Reset_h)
	 begin
	 dots <= '1;
	 score <= 0;
	 end

	 else if (ballxsig >= 56 && ballxsig <= 392 && ballysig >= 56 && ballysig <= 392)
		begin
			if (dots[(ballxsig-56+4)/8][(ballysig-56+4)/8] == 1)
			begin
				dots[(ballxsig-56+4)/8][(ballysig-56+4)/8] <= 0;
				score <= (score+1);
			end
		end

	 end




	 logic victory;


	 always_comb begin
		 victory = 0;
		if ((dots == '0 || score >= 500) && (death == 0)) //score 150 to win
			victory = 1;

	 end 
//DrawY = 42 blocks, from 56 to Draw X = 392
//DrawX = 42, from 56 to 392
	//  always_comb
	//  begin
	// 	death = 0;
	// 	if (lives == 0)
	// 	death = 1;


	//  end

	//  always_comb begin

	// 	death = 0;
	// 	if (lives == 0)
	// 		death = 1;

	//  end


	 ghost_pacman_distance pdr (.pacmanX(ballxsig), .pacmanY(ballysig), .ghostX(ghost_redX), .ghostY(ghost_redY), .distance(distance_red));


	 ghost_pacman_distance pdg (.pacmanX(ballxsig), .pacmanY(ballysig), .ghostX(ghost_greenX), .ghostY(ghost_greenY), .distance(distance_green));


	 ghost_pacman_distance pda (.pacmanX(ballxsig), .pacmanY(ballysig), .ghostX(ghost_aquaX), .ghostY(ghost_aquaY), .distance(distance_aqua));



//instantiate a vga_controller, ball, and color_mapper here with the ports.

	vga_controller vgc(.Clk(MAX10_CLK1_50), .Reset(Reset_h), .hs(VGA_HS), .vs(VGA_VS), .DrawX(drawxsig), .DrawY(drawysig), .pixel_clk(VGA_Clk), .blank, .sync);
	

	ghost_red gr (.Reset(Reset_h), .frame_clk(VGA_VS), .pacmanX(ballxsig), .pacmanY(ballysig), .hasMoved, .reversal, .isDefeated, .death, .ghost_redX, .ghost_redY);

	ghost_green gg (.Reset(Reset_h), .frame_clk(VGA_VS), .pacmanX(ballxsig), .pacmanY(ballysig), .hasMoved, .reversal, .isDefeated, .death, .ghost_greenX, .ghost_greenY);


	ghost_aqua ga (.Reset(Reset_h), .frame_clk(VGA_VS), .pacmanX(ballxsig), .pacmanY(ballysig), .hasMoved, .reversal, .isDefeated, .death, .ghost_aquaX, .ghost_aquaY);


	pacman pacman_sprite(.Reset(Reset_h), .frame_clk(VGA_VS), .keycode(keycode), .BallX(ballxsig), .BallY(ballysig), .last_keypress, .y_val, .x_val, .victory, .reversal, .isDefeated, .hasMoved, .death);
	
	color_mapper cm(.Clk(MAX10_CLK1_50), .pacmanX(ballxsig), .pacmanY(ballysig), .DrawX(drawxsig), .DrawY(drawysig), .reversal_counter, .isDefeated, .death, .lives, .closePacman, .first_on, .dots, .reversal, .second_on, .third_on, .score, .green_enable, .red_enable, .aqua_enable, .fruit_location, .ghost_redX, .ghost_redY, .ghost_greenX, .ghost_greenY, .ghost_aquaX, .ghost_aquaY, .last_keypress, .Red, .Green, .Blue, .victory);

	pacman_counter pc (.frame_clk(VGA_VS), .Reset(Reset_h), .hasMoved, .closePacman);

endmodule

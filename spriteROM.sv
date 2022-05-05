module pacman_rom_right ( input [2:0]	addr,
    output [7:0]	data
 );

parameter ADDR_WIDTH = 3;
parameter DATA_WIDTH =  8;
logic [ADDR_WIDTH-1:0] addr_reg;

// ROM definition				
parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] ROM = {
8'b00011000,
8'b00111100,
8'b01111110,
8'b01111100,
8'b01111000,
8'b01111100,
8'b00111110,
8'b00011100
};

assign data = ROM[addr];


endmodule

module pacman_rom_closed ( input [2:0]	addr,
    output [7:0]	data
 );

parameter ADDR_WIDTH = 3;
parameter DATA_WIDTH =  8;
logic [ADDR_WIDTH-1:0] addr_reg;

// ROM definition				
parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] ROM = {
8'b00011000,
8'b00111100,
8'b11111110,
8'b11111111,
8'b11111111,
8'b11111111,
8'b00111110,
8'b00011100
};

assign data = ROM[addr];


endmodule


module pacman_rom_up ( input [2:0]	addr,
    output [7:0]	data
 );

parameter ADDR_WIDTH = 3;
parameter DATA_WIDTH =  8;
logic [ADDR_WIDTH-1:0] addr_reg;

// ROM definition				
parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] ROM = {
    8'b10000001,
    8'b11000011,
    8'b11100111,
    8'b11111111,
    8'b11111111,
    8'b11111111,
    8'b01111110,
    8'b00011000
};

assign data = ROM[addr];


endmodule


module ghost ( input [2:0]	addr,
    output [7:0]	data
 );

parameter ADDR_WIDTH = 3;
parameter DATA_WIDTH =  8;
logic [ADDR_WIDTH-1:0] addr_reg;

// ROM definition				
parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] ROM = {
    8'b00011000,
    8'b00111100,
    8'b01001010,
    8'b11001001,
    8'b11111111,
    8'b11100111,
    8'b11000011,
    8'b10000001
};

assign data = ROM[addr];


endmodule


module fruit ( input [2:0]	addr,
    output [7:0]	data
 );

parameter ADDR_WIDTH = 3;
parameter DATA_WIDTH =  8;
logic [ADDR_WIDTH-1:0] addr_reg;

// ROM definition				
parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] ROM = {
    8'b00000000,
    8'b01111110,
    8'b01111110,
    8'b01100110,
    8'b01100110,
    8'b01111110,
    8'b01111110,
    8'b00000000
};

assign data = ROM[addr];


endmodule


module dot ( input [2:0] addr,
    output [7:0]	data
 );

parameter ADDR_WIDTH = 3;
parameter DATA_WIDTH =  8;
logic [ADDR_WIDTH-1:0] addr_reg;

// ROM definition				
parameter [0:2**ADDR_WIDTH-1][DATA_WIDTH-1:0] ROM = {
    8'b00000000,
    8'b00000000,
    8'b01111110,
    8'b01111110,
    8'b01111110,
    8'b01111110,
    8'b00000000,
    8'b00000000
};

assign data = ROM[addr];


endmodule
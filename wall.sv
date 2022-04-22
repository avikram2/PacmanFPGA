module check_wall(input [9:0] DrawX, DrawY, output logic wallEnable);

int wall_size = 56;

always_comb
begin
wallEnable = 0;


if (DrawX < 8 && DrawX >= 0 || DrawX > 632 && DrawX <= 640 || DrawY < 8  && DrawY >= 0|| DrawY > 472 && DrawY <= 480) //outerboundary wall
wallEnable = 1;


if (DrawX >= 80 && DrawX < (80 + wall_size) && DrawY >= 80 && DrawY < (80+2*wall_size))
wallEnable = 1;

if (DrawX >= 480 && DrawX < (480 + 2*wall_size) && DrawY >= 240 && DrawY < (240 + wall_size))
wallEnable = 1;


if (DrawX >= 320 && DrawX < 328 && ((DrawY >= 120 && DrawY < 256) || (DrawY >= 272 && DrawY < 456)))
wallEnable = 1;

if (DrawX >= 328 && DrawX < 480 && DrawY >= 240 & DrawY < 248)
wallEnable = 1;

if (DrawX >= 0 && DrawX < 80 && DrawY >= 64 && DrawY < 72)
wallEnable = 1;

if (DrawX >= 224 && DrawX < 232 && DrawY >= 8 && DrawY < 104)
wallEnable = 1;


if (DrawX >= 152 && DrawX < 160 && DrawY >= 360)
wallEnable = 1;


end

endmodule


module sprite_wall (input [9:0] X, Y, X_motion, Y_motion, output stop_motion);

    logic [9:0] posX, posY, minPosX, minPosY;
    logic wall1, wall2;
    always_comb
    begin

        posX = X;
        posY = Y;
		  minPosX = X + 8;
		  minPosY = Y+8;
        if (X_motion == 1 && Y_motion == 0) //right
        begin
            posX = (X + 9);
            minPosX = (X+9);
            minPosY = (Y + 8);
        end
        else if (X_motion != 0)
            begin
            posX = X - 2;
            minPosY = Y + 8;
            minPosX = X -2;
            end
        if (Y_motion == 1)
            begin
            posY = Y + 9;
            minPosX = X + 8;
            minPosY = Y+9;
            end 
        else if (Y_motion != 0)
            begin
            posY = Y - 2;
            minPosX = X + 8;
            minPosY = Y -2;
            end

    end

    assign stop_motion = wall1 || wall2;

    check_wall cw(.DrawX(posX), .DrawY(posY), .wallEnable(wall1));


    check_wall cw2(.DrawX(minPosX), .DrawY(minPosY), .wallEnable(wall2));

endmodule
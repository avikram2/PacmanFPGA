module pacman_counter(input frame_clk, Reset, hasMoved, output closePacman); //counter for the pacman sprite animation


logic [3:0] counter;


always_ff @ (posedge Reset or posedge frame_clk)
begin

if (Reset)
begin
closePacman <= 0;
counter <= 0;
end

else if (counter == 10)
begin
closePacman <= (~closePacman);
counter <= 0;
end


else if (hasMoved == 1)
counter <= (counter +1);

end

endmodule
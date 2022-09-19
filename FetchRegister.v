`timescale 1ns / 1ps






module FetchRegister (input CLK, CLR, EN,
                      input [31:0] PCp1FIn, InstrFIn,
                      output reg [31:0] PCp1FOut, InstFOut);

always @(posedge CLK) begin

if (CLR) begin
PCp1FOut <= 32'b00000000000000000000000000000000;
InstFOut <= 32'b00000000000000000000000000000000;
end

else if (EN) begin
PCp1FOut <= PCp1FIn;
InstFOut <= InstrFIn;
end

end
endmodule
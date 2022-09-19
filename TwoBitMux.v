`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
// 
//////////////////////////////////////////////////////////////////////////////////


module TwoBitMux#(WL=32)
           (input[1:0] sel,
            input [WL-1:0] a,b,c,d,
            output reg [WL-1:0] out);
always @(sel,a,b,c,d) begin
    case(sel)
    2'b00: out = a;
    2'b01: out = b;
    2'b10: out = c;
    2'b11: out = d;
    default: out = 32'b00000000000000000000000000000000;
    endcase
end
endmodule

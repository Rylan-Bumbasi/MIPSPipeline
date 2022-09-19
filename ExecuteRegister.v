`timescale 1ns / 1ps

module ExecuteRegister(input CLK, 
                             RFWEEdin,
                             MtoRFSelEdin,
                             DMWEEdin,
                 input[31:0] DMdinEdin,
                             ALUOutEdin,
                  input[4:0] RFAEdin,
                  output reg RFWEEdout,
                             MtoRFSelEdout,
                             DMWEEdout,
           output reg [31:0] DMdindout,
                             ALUOutEdout,
            output reg [4:0] RFWAEdout);
              
always @(posedge CLK) begin
RFWEEdout <= RFWEEdin;
MtoRFSelEdout <= MtoRFSelEdin;
DMWEEdout <= DMWEEdin;
DMdindout <= DMdinEdin;
ALUOutEdout <= ALUOutEdin;
RFWAEdout <= RFAEdin;
end   

endmodule
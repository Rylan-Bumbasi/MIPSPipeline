`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// 
//////////////////////////////////////////////////////////////////////////////////


module WriteBackRegister(input CLK, 
                               RFWEWdin,
                               MtoRFSelWdin,
                   input[31:0] DMOutWdin,
                               ALUOutWdin,
                    input[4:0] RFAWdin,
                    output reg RFWEWdout,
                               MtoRFSelWdout,
             output reg [31:0] DMOutWdout,
                               ALUOutWdout,
             output reg [4:0]  RFAWdout);
     
always @(posedge CLK) begin
RFWEWdout <= RFWEWdin;
MtoRFSelWdout <= MtoRFSelWdin;
DMOutWdout <= DMOutWdin;
ALUOutWdout <= ALUOutWdin;
RFAWdout <= RFAWdin;
end
                            
endmodule

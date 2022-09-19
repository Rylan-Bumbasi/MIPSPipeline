`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////////


module DecodeRegister(input CLK, CLR,
                      input RFWEDIn,
                            MtoRFSelDIn, 
                            DMWEDIn, 
 
                            ALUInSelDIn, 
                            RFDSelDIn, 


                 input[3:0] ALUSelDIn,
                input[31:0] RFRD1DIn, RFRD2DIn, 
                 input[4:0] RsDIn, RtDIn, RdDIn, shamtDIn,
                input[31:0] SImmDIn,
                 output reg RFWEDOut,
                            MtoRFSelDOut, 
                            DMWEDOut, 
                            ALUInSelDOut, 
                            RFDSelDOut, 
           output reg [3:0] ALUSelDOut,
          output reg [31:0] RFRD1DOut, RFRD2DOut, 
           output reg [4:0] RsDOut, RtDOut, RdDOut, shamtDOut,
          output reg [31:0] SImmDOut);

always @(posedge CLK) begin
if (CLR) begin 
RFWEDOut <= 1'b0;
MtoRFSelDOut <= 1'b0; 
DMWEDOut <= 1'b0;
ALUInSelDOut <= 1'b0;
RFDSelDOut <= 1'b0;
ALUSelDOut <= 4'b0000;
RFRD1DOut <= 32'd0;
RFRD2DOut <= 32'd0;
RsDOut <= 5'd0;
RtDOut <= 5'd0;
RdDOut <= 5'd0;
shamtDOut <= 5'd0;
SImmDOut <= 5'd0;
end

else begin 
RFWEDOut <= RFWEDIn;
MtoRFSelDOut <= MtoRFSelDIn; 
DMWEDOut <= DMWEDIn;
ALUInSelDOut <= ALUInSelDIn;
RFDSelDOut <= RFDSelDIn;
ALUSelDOut <= ALUSelDIn;
RFRD1DOut <= RFRD1DIn;
RFRD2DOut <= RFRD2DIn;
RsDOut <= RsDIn;
RtDOut <= RtDIn;
RdDOut <= RdDIn;
shamtDOut <= shamtDIn;
SImmDOut <= SImmDIn;
end 

end              
endmodule

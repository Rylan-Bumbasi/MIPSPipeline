`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////


module HazardUnit(input RST,
                        RFWEE, RFWEM, RFWEW,
                        MtoRFSelE, MtoRFSelM,
                        BranchD,
                  input [4:0] rsD, rtD,
                              rsE, rtE,
                              rtdE,
                              rtdM,
                              rtdW,
                   output reg LWStall, BRStall,
              output reg[1:0] ForwardAE, ForwardBE, ForwardAD, ForwardBD);

always @(RST) begin
LWStall = 1'b0;
BRStall = 1'b0;
end
                             
always @* begin

// Forward Logic for ForwardAE
if ((rsE != 0) & RFWEM & (rsE == rtdM)) ForwardAE = 2'b10;
else if ((rsE != 0) & RFWEW & (rsE == rtdW)) ForwardAE = 2'b01;
else ForwardAE = 2'b00;

// Forward Logic for ForwardBE
if ((rtE != 0) & RFWEM & (rtE == rtdM)) ForwardBE = 2'b10;
else if ((rtE != 0) & RFWEW & (rtE == rtdW)) ForwardBE = 2'b01;
else ForwardBE = 2'b00;

// LWStall Logc
if (MtoRFSelE & ((rtE == rsD) | (rtE == rtD)) ) LWStall = 1'b1;
else LWStall = 1'b0;

// Forward Logic for FowardAD
if ((rsD != 0) & (rsD == rtdM) & RFWEM) ForwardAD = 1'b1;
else ForwardAD = 1'b0;

// Forward Logic for ForwardBD
if ((rtD != 0) & (rtD == rtdM) & RFWEM) ForwardBD = 1'b1;
else ForwardBD = 1'b0;

// Branch Stall Logic
if ( (rsD == rtdE | rtD == rtdE) & BranchD & RFWEE | (rsD == rtdM | rtD == rtdM) & BranchD & MtoRFSelM ) BRStall = 1'b1;
else BRStall = 1'b0;



end
endmodule

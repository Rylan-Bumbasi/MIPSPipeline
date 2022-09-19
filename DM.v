`timescale 1ns / 1ps                                                                                
//////////////////////////////////////////////////////////////////////////////////                  
// Name: Rylan Bumbasi                                                                              
// Course: COMPE 475                                                                                
// Module Description: Data Memory                                                           
//////////////////////////////////////////////////////////////////////////////////                                                                                                                   
module DM#(parameter WL = 32)                                                                       
        (input CLK, DMWE,
         input [WL-1:0] DMA, DMWD,                                                                        
         output [WL-1:0] DMRD);                                                                 
                                                                                                    
     
                                                                                                    
initial $readmemb("dataMemory.mem", ROM);      

reg [WL-1:0] ROM [2**10-1:0]; // Decalre an array to hold all of the values from the .mem file                                                        

always @(posedge CLK) begin
    if(DMWE) begin
    ROM[DMA] <= DMWD;
    end
end

                                                                                  
assign DMRD = ROM[DMA];                                                                                    
                                                                                           
endmodule                                                                                           
                                                                                                    
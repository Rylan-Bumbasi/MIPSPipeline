`timescale 1ns / 1ps                                                                                
//////////////////////////////////////////////////////////////////////////////////                  
// Name: Rylan Bumbasi                                                                              
// Course: COMPE 475                                                                                
// Module Description: Instruction Memory                                                           
//////////////////////////////////////////////////////////////////////////////////                  
                                                                                                    
                                                                                                    
                                                                                                    
module IM#(parameter WL = 32)                                                                       
        (input [WL-1:0] IMA,                                                                        
         output [WL-1:0] IMRD);                                                                 
                                                                                                    
reg [WL-1:0] ROM [2**8:0]; // Decalre an array to hold all of the values from the .mem file         
                                                                                                    
initial $readmemb("IMmem.mem", ROM);                                                          
                                                                                  

assign IMRD = ROM[IMA];                                                                                    
                                                                                             
endmodule                                                                                           
                                                                                                    
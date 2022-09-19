`timescale 1ns / 1ps


module ControlUnit(input [5:0] opcode, Funct,
                         output reg RFWE,
                                    MtoRFSel, 
                                    DMWE,  
                                    ALUInSel,
                                    RFDSel,
                                    Branch,  
                                    Jump,
                   output reg [1:0] ALUOp,
                   output reg [3:0] ALUSel);
always@(*) begin
    
    case(opcode) // Case block for opcode
    6'b000000: begin // R-Type Instruction
    RFWE = 1'b1;
    RFDSel = 1'b1;
    ALUInSel = 1'b0;
    Branch = 1'b0;
    DMWE = 1'b0; 
    MtoRFSel = 1'b0; 
    ALUOp = 2'b10;
    Jump = 1'b0;
    end
    
    6'b100011: begin // lw
    RFWE = 1'b1;
    RFDSel = 1'b0;
    ALUInSel = 1'b1;
    Branch = 1'b0;
    DMWE = 1'b0; 
    MtoRFSel = 1'b1; 
    ALUOp = 2'b00;
    Jump = 1'b0;
    end
    
    6'b101011: begin // sw
    RFWE = 1'b0;
    RFDSel = 1'bX;
    ALUInSel = 1'b1;
    Branch = 1'b0;
    DMWE = 1'b1; 
    MtoRFSel = 1'bx; 
    ALUOp = 2'b00;
    Jump = 1'b0;
    end
    
    6'b000100: begin // beq
    RFWE = 1'b0;
    RFDSel = 1'bX;
    ALUInSel = 1'b0;
    Branch = 1'b1;
    DMWE = 1'b0; 
    MtoRFSel = 1'bx; 
    ALUOp = 2'b01;
    Jump = 1'b0;
    end
    
    6'b001000: begin // addi
    RFWE = 1'b1;
    RFDSel = 1'b0;
    ALUInSel = 1'b1;
    Branch = 1'b0;
    DMWE = 1'b0; 
    MtoRFSel = 1'bx; 
    ALUOp = 2'b00;
    Jump = 1'b0;
    end
    
    6'b000010: begin // Jump Instruction
    RFWE = 1'b0;
    RFDSel = 1'bX;
    ALUInSel = 1'bX;
    Branch = 1'bX;
    DMWE = 1'b0; 
    MtoRFSel = 1'bX; 
    ALUOp = 2'bXX;
    Jump = 1'b1;
    end
endcase
    
    case(ALUOp)// Case block for ALUOp
    2'b00: ALUSel = 4'b0000; // Add
    2'b01: ALUSel = 4'b0001; // Subtract
    2'b10: begin // Look at Func
    if(Funct == 6'b100000) ALUSel =  4'b0000; // add function
    else if(Funct == 6'b100010) ALUSel = 4'b0001; // subtract function
    else if(Funct == 6'b100100) ALUSel = 4'b0111; // And Function
    else if(Funct == 6'b100101) ALUSel = 4'b1000; // Or Function
    else if(Funct == 6'b000000) ALUSel = 4'b0010; // SLL Function
    else if(Funct == 6'b000100) ALUSel = 4'b0100; // SLLV Function
    else if(Funct == 6'b000111) ALUSel = 4'b1011; // SRAV Function
    // else if(Funct == 6'b101010) ALUSel = 4' // Set Less than function must fix late
    end
    default: ALUSel = 4'bXXXX; // Default, set ALU Sel to 15
    endcase
  
end

endmodule

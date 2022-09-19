`timescale 1ns / 1ps

module PipelineTop(input CLK, RST);

//////////////////////////////////////Fetch Stage Wires
wire [31:0] PCSelDOut; // PCSelMux Wires
wire [31:0] PCOut; //PC Wires
wire [31:0] IMRDOut; // IM wires

wire [31:0] PCp1AdderOut; // Output of pcp1 adder

// Fetch Register Wires
wire [31:0] PCp1FOut; // Output of Fetch Register
wire [31:0] InstFOut; 

//////////////////////////////////////Decode Stage Wires

// Instruction Decoder Wires
wire [5:0] opcode, Funct;
wire [4:0] rs, rt, rd, shamt;
wire [15:0] imm;
wire [25:0] jumpt;
wire [31:0] SImmOut;

//Register FIle Wires
wire [31:0] RFRD1Out;
wire [31:0] RFRD2Out;

// Control Unit Wires
wire MtoRFSel, DMWE, Branch, ALUInSel, RFDSel, RFWE, Jump;
wire [1:0] ALUOp;
wire [3:0] ALUSel;

// MUX Wires
wire [31:0] ForwardADOut, ForwardBDOut;
wire [31:0] JumpMuxOut;

//Jumpaddr Wires
wire [31:0] Jaddr;
assign Jaddr = {PCOut[31:26], jumpt};


//PCp1D adder Wires
wire [31:0] PCp1DAdderOut;

// Decode Register Wires
wire RFWEDOut,
     MtoRFSelDOut,
     DMWEDOut, 
     ALUInSelDOut, 
     RFDSelDOut;
wire [3:0] ALUSelDOut;
wire [31:0] RFRD1DOut, RFRD2DOut;
wire [4:0] RsDOut, RtDOut, RdDOut, shamtDOut;
wire [31:0] SImmDOut;

////////////////////////////////////////////Execute Stage Wires

// Two - Bit Multiplexers
wire [31:0] ForwardAEMuxOut;
wire [31:0] ForwardBEMuxOut;


// Mux
wire [31:0] ALUInSelEMuxOut;
wire [4:0] RFDSelEOut;

//ALU Wires
wire [31:0] ALUOut;
wire OVF, zero;

//Execute Register Wires;
wire RFWEEdout, MtoRFSelEdout, DMWEEdout;
wire [31:0] DMdindout, ALUOutEdout;
wire [4:0] RFWAEdout;

////////////////////////////////////////////Data Memory Stage Wires

// Data Memory Wires
wire [31:0] DMRDOut;

// WriteBackRegister Wires
wire RFWEWdout, MtoRFSelWdout;
wire [31:0] DMOutWdout, ALUOutWdout;
wire [4:0]  RFAWdout;

///////////////////////////////////////////Writeback State Wires

wire [31:0] ResultW;

//////////////////////////////////////////Hazard Unit Wires
wire LWStall, BRStall;
wire [1:0] ForwardAE, ForwardBE, ForwardAD, ForwardBD;

////////////////////////////////////////////////////////////////////////////////////////////////// Fetch Stage

mux PCSelDMUX (.a(PCp1AdderOut), .b(PCp1DAdderOut), .sel((ForwardADOut == ForwardBDOut) & Branch),
           .out(PCSelDOut));
           
mux jumpMUX(.a(PCSelDOut), .b(Jaddr), .sel(Jump),
            .out(JumpMuxOut));

register PC1(.CLK(CLK), .RST(RST), .EN(!LWStall), .Din(JumpMuxOut),
             .Dout(PCOut));

IM IM1(.IMA(PCOut),
       .IMRD(IMRDOut));
       
adder PCp1(.in1(PCOut), .in2(1),
           .out(PCp1AdderOut));
           
FetchRegister FR1(.CLK(CLK), .CLR((ForwardADOut == ForwardBDOut) & Branch), .EN(!LWStall), .PCp1FIn(PCp1AdderOut), .InstrFIn(IMRDOut),
                  .PCp1FOut(PCp1FOut), .InstFOut(InstFOut));
           
///////////////////////////////////////////////////////////////////////////////////////////////////// Decode Stage

// Instruction Decoder
InstructionDecoder ID1(.Inst(InstFOut),
                       .opcode(opcode), .Funct(Funct), .rs(rs), .rt(rt), .rd(rd), 
                       .shamt(shamt), .imm(imm), .jumpt(jumpt));

// Control Unit 
ControlUnit CU1(.opcode(opcode), .Funct(Funct), 
                .MtoRFSel(MtoRFSel), .DMWE(DMWE),
                .Branch(Branch), .ALUInSel(ALUInSel), .RFDSel(RFDSel), .RFWE(RFWE), .ALUOp(ALUOp), 
                .ALUSel(ALUSel), .Jump(Jump));

RF RF1(.CLK(!CLK), .RFWE(RFWEWdout), .RFRA1(rs), .RFRA2(rt), .RFWA(RFAWdout), .RFWD(ResultW),
       .RFRD1(RFRD1Out), .RFRD2(RFRD2Out));

mux ForwardADMUX (.a(RFRD1Out), .b(ALUOutEdout), .sel(ForwardAD),
              .out(ForwardADOut));
              
mux ForwardBDMUX (.a(RFRD2Out), .b(ALUOutEdout), .sel(ForwardBD),
              .out(ForwardBDOut));

SE SEDecode (.Imm(imm),
             .SImm(SImmOut));
              
adder PCp1D(.in1(SImmOut), .in2(PCFOut),
            .out(PCp1DAdderOut));
            
DecodeRegister DeR1(.CLK(CLK), .CLR(LWStall | BRStall), .RFWEDIn(RFWE), .MtoRFSelDIn(MtoRFSel), .DMWEDIn(DMWE), .ALUSelDIn(ALUSel), .ALUInSelDIn(ALUInSel), .RFDSelDIn(RFDSel),
                   .RFRD1DIn(ForwardADOut), .RFRD2DIn(ForwardBDOut), 
                   .RsDIn(rs), .RtDIn(rt), .RdDIn(rd), .shamtDIn(shamt),
                   .SImmDIn(SImmOut),
                                                   
                   .RFWEDOut(RFWEDOut), .MtoRFSelDOut(MtoRFSelDOut), .DMWEDOut(DMWEDOut), .ALUSelDOut(ALUSelDOut), .ALUInSelDOut(ALUInSelDOut), .RFDSelDOut(RFDSelDOut),
                   .RFRD1DOut(RFRD1DOut), .RFRD2DOut(RFRD2DOut), 
                   .RsDOut(RsDOut), .RtDOut(RtDOut), .RdDOut(RdDOut), .shamtDOut(shamtDOut), 
                   .SImmDOut(SImmDOut));
                 
///////////////////////////////////////////////////////////////////////////////////////////////////// Execute Stage

TwoBitMux ForwardAEMux (.sel(ForwardAE), .a(RFRD1DOut), .b(ResultW), .c(ALUOutEdout), .d(0),
                        .out(ForwardAEMuxOut));

TwoBitMux ForwardBEMux (.sel(ForwardBE), .a(RFRD2DOut), .b(ResultW), .c(ALUOutEdout), .d(0),
                        .out(ForwardBEMuxOut));
                        
mux ALUInSelEMUX(.sel(ALUInSelDOut), .a(ForwardBEMuxOut), .b(SImmDOut),
                .out(ALUInSelEMuxOut));
                                   
mux RFDSelMux(.sel(RFDSelDOut), .a(RtDOut), .b(RdDOut), 
              .out(RFDSelEOut));
              
ALU ALU1(.ALUin1(ForwardAEMuxOut), .ALUin2(ALUInSelEMuxOut), .shamt(shamtDOut), .sel(ALUSelDOut),
         .ALUOut(ALUOut), .OVF(OVF), .zero(zero));
         
ExecuteRegister ER1(.CLK(CLK), .RFWEEdin(RFWEDOut), .MtoRFSelEdin(MtoRFSelDOut), .DMWEEdin(DMWEDOut), .ALUOutEdin(ALUOut), .DMdinEdin(ForwardBEMuxOut), .RFAEdin(RFDSelEOut),
                    .RFWEEdout(RFWEEdout), .MtoRFSelEdout(MtoRFSelEdout), .DMWEEdout(DMWEEdout), .DMdindout(DMdindout), .ALUOutEdout(ALUOutEdout), .RFWAEdout(RFWAEdout));                                          

///////////////////////////////////////////////////////////////////////////////////////////////////// Data Memory Stage

DM DM1(.CLK(CLK), .DMWE(DMWEEdout), .DMA(ALUOutEdout), .DMWD(DMdindout),
       .DMRD(DMRDOut));
       
WriteBackRegister WBR1(.CLK(CLK), .RFWEWdin(RFWEEdout), .MtoRFSelWdin(MtoRFSelEdout), .DMOutWdin(DMRDOut), 
                       .ALUOutWdin(ALUOutEdout), .RFAWdin(RFWAEdout),
                       
                       .RFWEWdout(RFWEWdout), .MtoRFSelWdout(MtoRFSelWdout), .DMOutWdout(DMOutWdout), 
                       .ALUOutWdout(ALUOutWdout), .RFAWdout(RFAWdout));

///////////////////////////////////////////////////////////////////////////////////////////////////// Writeback Stage
mux MtoRFSelWMUX(.a(ALUOutWdout), .b(DMOutWdout), .sel(MtoRFSelWdout), 
                 .out(ResultW));
                 
///////////////////////////////////////////////////////////////////////////////////////////////////// Hazard Stage

HazardUnit HU1(.RST(RST),
               .RFWEE(RFWEDOut), .RFWEM(RFWEEdout), .RFWEW(RFWEWdout), 
               .MtoRFSelE(MtoRFSelDOut), .MtoRFSelM(MtoRFSelEdout),
               .BranchD(Branch),
               .rsD(rs), .rtD(rt),
               .rsE(RsDOut), .rtE(RtDOut),
               .rtdE(RFDSelEOut), 
               .rtdM(RFWAEdout),
               .rtdW(RFAWdout),
               
               .LWStall(LWStall),
               .BRStall(BRStall),
               .ForwardAE(ForwardAE), .ForwardBE(ForwardBE), .ForwardAD(ForwardAD), .ForwardBD(ForwardBD));
                 
endmodule

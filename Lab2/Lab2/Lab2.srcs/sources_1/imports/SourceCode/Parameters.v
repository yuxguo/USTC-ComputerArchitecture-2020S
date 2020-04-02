`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Parameters
// Tool Versions: Vivado 2017.4.1
// Description: Const Parameters
// 
//////////////////////////////////////////////////////////////////////////////////

// 功能说明
    // 为了代码可读性，定义了常量值
// 实验要求  
    // 无需修改

`ifndef CONST_VALUES
`define CONST_VALUES
// ALU_func[3:0]
    `define SLL  4'd0
    `define SRL  4'd1
    `define SRA  4'd2
    `define ADD  4'd3
    `define SUB  4'd4
    `define XOR  4'd5
    `define OR  4'd6
    `define AND  4'd7
    `define SLT  4'd8
    `define SLTU  4'd9
    `define LUI  4'd10
    `define OP1 4'd11
    `define OP2 4'd12
// br_type[2:0]
    `define NOBRANCH  3'd0
    `define BEQ  3'd1
    `define BNE  3'd2
    `define BLT  3'd3
    `define BLTU  3'd4
    `define BGE  3'd5
    `define BGEU  3'd6
// imm_type[2:0]
    `define RTYPE  3'd0
    `define ITYPE  3'd1
    `define STYPE  3'd2
    `define BTYPE  3'd3
    `define UTYPE  3'd4
    `define JTYPE  3'd5  
// load_type[2:0]  six kind of ways to save values to Register
    `define NOREGWRITE  3'b0	//	Do not write Register
    `define LB  3'd1			//	load 8bit from Mem then signed extended to 32bit
    `define LH  3'd2			//	load 16bit from Mem then signed extended to 32bit
    `define LW  3'd3			//	write 32bit to Register
    `define LBU  3'd4			//	load 8bit from Mem then unsigned extended to 32bit
    `define LHU  3'd5			//	load 16bit from Mem then unsigned extended to 32bit
// instruction encode
    // U-Type
    `define U_LUI 7'b0110111
    `define U_AUIPC 7'b0010111
    // J-Type
    `define J_JAL 7'b1101111
    `define J_JALR 7'b1100111
    // B-Type
    `define B_TYPE 7'b1100011
    `define B_BEQ 3'b000
    `define B_BNE 3'b001
    `define B_BLT 3'b100
    `define B_BGE 3'b101
    `define B_BLTU 3'b110
    `define B_BGEU 3'b111
    // I-Type (not contain CSR)
    // I-Type-Load
    `define I_LOAD 7'b0000011
    `define I_LB 3'b000
    `define I_LH 3'b001
    `define I_LW 3'b010
    `define I_LBU 3'b100
    `define I_LHU 3'b101
    // I-Type-Arithmetic
    `define I_ARI 7'b0010011
    `define I_ADDI 3'b000
    `define I_SLTI 3'b010
    `define I_SLTIU 3'b011
    `define I_XORI 3'b100
    `define I_ORI 3'b110
    `define I_ANDI 3'b111
    `define I_SLLI 3'b001
    `define I_SR 3'b101
    `define I_SRAI 7'b0100000
    `define I_SRLI 7'b0000000
    // S-Type
    `define S_TYPE 7'b0100011
    `define S_SB 3'b000
    `define S_SH 3'b001
    `define S_SW 3'b010
    // R-Type
    `define R_TYPE 7'b0110011
    `define R_AS 3'b000
    `define R_ADD 7'b0000000
    `define R_SUB 7'b0100000
    `define R_SLL 3'b001
    `define R_SLT 3'b010
    `define R_SLTU 3'b011
    `define R_XOR 3'b100
    `define R_SR 3'b101
    `define R_SRL 7'b0000000
    `define R_SRA 7'b0100000
    `define R_OR 3'b110
    `define R_AND 3'b111
    // I-CSR
    `define I_CSR 7'b1110011
    `define I_CSRRC 3'b011
    `define I_CSRRCI 3'b111
    `define I_CSRRS 3'b010
    `define I_CSRRSI 3'b110
    `define I_CSRRW 3'b001
    `define I_CSRRWI 3'b101

`endif


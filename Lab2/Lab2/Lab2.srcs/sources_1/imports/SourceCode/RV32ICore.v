`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: RV32I Core
// Tool Versions: Vivado 2017.4.1
// Description: Top level of our CPU Core
//////////////////////////////////////////////////////////////////////////////////



module RV32ICore(
    input wire CPU_CLK,
    input wire CPU_RST,
    input wire [31:0] CPU_Debug_DataCache_A2,
    input wire [31:0] CPU_Debug_DataCache_WD2,
    input wire [3:0] CPU_Debug_DataCache_WE2,
    output wire [31:0] CPU_Debug_DataCache_RD2,
    input wire [31:0] CPU_Debug_InstCache_A2,
    input wire [31:0] CPU_Debug_InstCache_WD2,
    input wire [ 3:0] CPU_Debug_InstCache_WE2,
    output wire [31:0] CPU_Debug_InstCache_RD2,
    // debug signals
    output wire [31:0] debug_PC_IF, 
    output wire [31:0] debug_jal_target, debug_jalr_target,
    output wire [31:0] debug_PC_ID, debug_inst_ID,
    output wire [31:0] debug_PC_EX, debug_br_target, debug_reg1_EX, debug_reg2_EX, debug_imm_EX,
    output wire [4:0] debug_reg1_src_EX, debug_reg2_src_EX, debug_reg_dest_EX,
    output wire debug_jalr_EX,
    output wire [3:0] debug_ALU_func_EX,
    output wire [2:0] debug_br_type_EX,
    output wire debug_load_npc_EX,
    output wire debug_wb_select_EX,
    output wire [2:0] debug_load_type_EX,
    output wire debug_reg_write_en_EX,
    output wire [3:0] debug_cache_write_en_EX,
    output wire debug_op1_src_EX, debug_op2_src_EX,
    output wire [2:0]debug_imm_type,
    output wire debug_jal,
    output wire debug_br,
    output wire [31:0] debug_result_MEM, debug_reg2_MEM,
    output wire [4:0] debug_reg_dest_MEM,
    output wire debug_wb_select_MEM,
    output wire [2:0] debug_load_type_MEM,
    output wire debug_reg_write_en_MEM,
    output wire [3:0] debug_cache_write_en_MEM,
    output wire [31:0] debug_data_WB,
    output wire [4:0] debug_reg_dest_WB,
    output wire debug_reg_write_en_WB
    );
    
	//wire values definitions
    wire bubbleF, flushF, bubbleD, flushD, bubbleE, flushE, bubbleM, flushM, bubbleW, flushW;
    wire [31:0] jal_target, br_target;
    wire jal, br;
    wire jalr_ID, jalr_EX;
    wire [31:0] NPC, PC_IF, PC_4, PC_ID, PC_EX;
    wire [31:0] inst_ID;
    wire reg_write_en_ID, reg_write_en_EX, reg_write_en_MEM, reg_write_en_WB;
    wire [4:0] reg1_src_EX;
    wire [4:0] reg2_src_EX;
    wire [4:0] reg_dest_EX, reg_dest_MEM, reg_dest_WB;
    wire [31:0] data_WB;
    wire [31:0] reg1, reg1_EX;
    wire [31:0] reg2, reg2_EX, reg2_MEM;
    wire [31:0] reg_or_imm;
    wire op1_src, op2_src; // Yuxuan Guo Modified
    wire [3:0] ALU_func_ID, ALU_func_EX;
    wire [2:0] br_type_ID, br_type_EX;
    wire load_npc_ID, load_npc_EX;
    wire wb_select_ID, wb_select_EX, wb_select_MEM;
    wire [2:0] load_type_ID, load_type_EX, load_type_MEM;
    wire [3:0] cache_write_en_ID, cache_write_en_EX, cache_write_en_MEM;
    wire [2:0] imm_type;
    wire [31:0] imm;
    wire [31:0] ALU_op1, ALU_op2, ALU_out;
    wire [31:0] result, result_MEM;
    wire [1:0] op1_sel, op2_sel;

    // Author Yuxuan Guo defined
    wire [31:0] imm_EX;
    wire [31:0] reg1_forwarding, reg2_forwarding;
    wire op1_src_EX, op2_src_EX;
    
    
    // Yuxuan Guo debug wires
    assign debug_PC_IF = PC_IF;
    assign debug_jal_target = jal_target;
    assign debug_jalr_target = ALU_out;
    assign debug_PC_ID = PC_ID;
    assign debug_inst_ID = inst_ID;
    assign {debug_PC_EX, debug_br_target, debug_reg1_EX, debug_reg2_EX, debug_imm_EX} = {PC_EX, br_target, reg1_EX, reg2_EX, imm_EX};
    assign {debug_reg1_src_EX, debug_reg2_src_EX, debug_reg_dest_EX} = {reg1_src_EX, reg2_src_EX, reg_dest_EX};
    assign debug_jalr_EX = jalr_EX;
    assign debug_ALU_func_EX = ALU_func_EX;
    assign debug_br_type_EX = br_type_EX;
    assign debug_load_npc_EX = load_npc_EX;
    assign debug_wb_select_EX = wb_select_EX;
    assign debug_load_type_EX = load_type_EX;
    assign debug_reg_write_en_EX = reg_write_en_EX;
    assign debug_cache_write_en_EX = cache_write_en_EX;
    assign {debug_op1_src_EX, debug_op2_src_EX} = {op1_src_EX, op2_src_EX};
    assign debug_imm_type = imm_type;
    assign debug_jal = jal;
    assign debug_br = br;
    assign {debug_result_MEM, debug_reg2_MEM} = {result_MEM, reg2_MEM};
    assign debug_reg_dest_MEM = reg_dest_MEM;
    assign debug_wb_select_MEM = wb_select_MEM;
    assign debug_load_type_MEM = load_type_MEM;
    assign debug_reg_write_en_MEM = reg_write_en_MEM;
    assign debug_cache_write_en_MEM = cache_write_en_MEM;
    assign debug_data_WB = data_WB;
    assign debug_reg_dest_WB = reg_dest_WB;
    assign debug_reg_write_en_WB = reg_write_en_WB;
    
    


    // Adder to compute PC + 4
    assign PC_4 = PC_IF + 4;


    // Adder to compute PC_ID + Imm - 4
    assign jal_target = PC_ID + imm - 4;
    // MUX for reg1 forwarding
    assign reg1_forwarding =  (op1_sel == 2'b00) ? reg1_EX : 
                                         ((op1_sel == 2'b01) ? result_MEM : data_WB);

    // MUX for reg2 forwarding
    assign reg2_forwarding = (op2_sel == 2'b00) ? reg2_EX : 
                                             ((op2_sel == 2'b01) ? result_MEM : data_WB);
                                             
    
    // MUX for ALU op1                                         
    assign ALU_op1 = (op1_src_EX == 1'b0) ? reg1_forwarding : (PC_EX - 4);
    
    
    // MUX for ALU op1                                         
    assign ALU_op2 = (op2_src_EX == 1'b0) ? reg2_forwarding : imm_EX;
    

    // MUX for Reg2
//    assign dealt_reg2 = (reg2_sel == 2'h0) ? result_MEM :
//                                            ((reg2_sel == 2'h1) ? data_WB : reg2_EX);


    // MUX for result (ALU or PC_EX)
    assign result = load_npc_EX ? PC_EX : ALU_out;



    //Module connections
    // ---------------------------------------------
    // PC-Generator
    // ---------------------------------------------


    NPC_Generator NPC_Generator1(
        .PC(PC_4),
        .jal_target(jal_target),
        .jalr_target(ALU_out),
        .br_target(br_target),
        .jal(jal),
        .jalr(jalr_EX),
        .br(br),
        .NPC(NPC)
    );


    PC_IF PC_IF1(
        .clk(CPU_CLK),
        .bubbleF(bubbleF),
        .flushF(flushF),
        .NPC(NPC),
        .PC(PC_IF)
    );



    // ---------------------------------------------
    // IF stage
    // ---------------------------------------------

    PC_ID PC_ID1(
        .clk(CPU_CLK),
        .bubbleD(bubbleD),
        .flushD(flushD),
        .PC_IF(PC_4),
        .PC_ID(PC_ID)
    );


    IR_ID IR_ID1(
        .clk(CPU_CLK),
        .bubbleD(bubbleD),
        .flushD(flushD),
        .write_en(|CPU_Debug_InstCache_WE2),
        .addr(PC_IF[31:2]),
        .debug_addr(CPU_Debug_InstCache_A2[31:2]),
        .debug_input(CPU_Debug_InstCache_WD2),
        .inst_ID(inst_ID),
        .debug_data(CPU_Debug_InstCache_RD2)
    );



    // ---------------------------------------------
    // ID stage
    // ---------------------------------------------


    RegisterFile RegisterFile1(
        .clk(CPU_CLK),
        .rst(CPU_RST),
        .write_en(reg_write_en_WB),
        .addr1(inst_ID[19:15]),
        .addr2(inst_ID[24:20]),
        .wb_addr(reg_dest_WB),
        .wb_data(data_WB),
        .reg1(reg1),
        .reg2(reg2)
    );


    ControllerDecoder ControllerDecoder1(
        .inst(inst_ID),
        .jal(jal),
        .jalr(jalr_ID),
        .op1_src(op1_src),
        .op2_src(op2_src),
        .ALU_func(ALU_func_ID),
        .br_type(br_type_ID),
        .load_npc(load_npc_ID),
        .wb_select(wb_select_ID),
        .load_type(load_type_ID),
        .reg_write_en(reg_write_en_ID),
        .cache_write_en(cache_write_en_ID),
        .imm_type(imm_type)
    );

    ImmExtend ImmExtend1(
        .inst(inst_ID[31:7]),
        .imm_type(imm_type),
        .imm(imm)
    );


    PC_EX PC_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .PC_ID(PC_ID),
        .PC_EX(PC_EX)
    );

    BR_Target_EX BR_Target_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .address(jal_target),
        .address_EX(br_target)
    );

    Op1_EX Op1_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .reg1(reg1),
        .reg1_EX(reg1_EX)
    );
    
    Imm_EX Imm_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .imm_in(imm),
        .imm_out(imm_EX)
    );

    Reg2_EX Reg2_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .reg2(reg2),
        .reg2_EX(reg2_EX)
    );

    Addr_EX Addr_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .reg1_src_ID(inst_ID[19:15]),
        .reg2_src_ID(inst_ID[24:20]),
        .reg_dest_ID(inst_ID[11:7]),
        .reg1_src_EX(reg1_src_EX),
        .reg2_src_EX(reg2_src_EX),
        .reg_dest_EX(reg_dest_EX)
    );



    Ctrl_EX Ctrl_EX1(
        .clk(CPU_CLK),
        .bubbleE(bubbleE),
        .flushE(flushE),
        .jalr_ID(jalr_ID),
        .ALU_func_ID(ALU_func_ID),
        .br_type_ID(br_type_ID),
        .load_npc_ID(load_npc_ID),
        .wb_select_ID(wb_select_ID),
        .load_type_ID(load_type_ID),
        .reg_write_en_ID(reg_write_en_ID),
        .cache_write_en_ID(cache_write_en_ID),
        .jalr_EX(jalr_EX),
        .ALU_func_EX(ALU_func_EX),
        .br_type_EX(br_type_EX),
        .load_npc_EX(load_npc_EX),
        .wb_select_EX(wb_select_EX),
        .load_type_EX(load_type_EX),
        .reg_write_en_EX(reg_write_en_EX),
        .cache_write_en_EX(cache_write_en_EX),
        .op1_src_ID(op1_src),
        .op2_src_ID(op2_src),
        .op1_src_EX(op1_src_EX),
        .op2_src_EX(op2_src_EX)
    );


    // ---------------------------------------------
    // EX stage
    // ---------------------------------------------

    ALU ALU1(
        .op1(ALU_op1),
        .op2(ALU_op2),
        .ALU_func(ALU_func_EX),
        .ALU_out(ALU_out)
    );

    BranchDecision BranchDecision1(
        .reg1(reg1_forwarding),
        .reg2(reg2_forwarding),
        .br_type(br_type_EX),
        .br(br)
    );


    Result_MEM Result_MEM1(
        .clk(CPU_CLK),
        .bubbleM(bubbleM),
        .flushM(flushM),
        .result(result),
        .result_MEM(result_MEM)
    );

    Reg2_MEM Reg2_MEM1(
        .clk(CPU_CLK),
        .bubbleM(bubbleM),
        .flushM(flushM),
        .reg2_EX(reg2_forwarding),
        .reg2_MEM(reg2_MEM)
    );

    Addr_MEM Addr_MEM1(
        .clk(CPU_CLK),
        .bubbleM(bubbleM),
        .flushM(flushM),
        .reg_dest_EX(reg_dest_EX),
        .reg_dest_MEM(reg_dest_MEM)
    );



    Ctrl_MEM Ctrl_MEM1(
        .clk(CPU_CLK),
        .bubbleM(bubbleM),
        .flushM(flushM),
        .wb_select_EX(wb_select_EX),
        .load_type_EX(load_type_EX),
        .reg_write_en_EX(reg_write_en_EX),
        .cache_write_en_EX(cache_write_en_EX),
        .wb_select_MEM(wb_select_MEM),
        .load_type_MEM(load_type_MEM),
        .reg_write_en_MEM(reg_write_en_MEM),
        .cache_write_en_MEM(cache_write_en_MEM)
    );



    // ---------------------------------------------
    // MEM stage
    // ---------------------------------------------


    WB_Data_WB WB_Data_WB1(
        .clk(CPU_CLK),
        .bubbleW(bubbleW),
        .flushW(flushW),
        .wb_select(wb_select_MEM),
        .load_type(load_type_MEM),
        .write_en(cache_write_en_MEM),
        .debug_write_en(CPU_Debug_DataCache_WE2),
        .addr(result_MEM),
        .debug_addr(CPU_Debug_DataCache_A2),
        .in_data(reg2_MEM),
        .debug_in_data(CPU_Debug_DataCache_WD2),
        .debug_out_data(CPU_Debug_DataCache_RD2),
        .data_WB(data_WB)
    );


    Addr_WB Addr_WB1(
        .clk(CPU_CLK),
        .bubbleW(bubbleW),
        .flushW(flushW),
        .reg_dest_MEM(reg_dest_MEM),
        .reg_dest_WB(reg_dest_WB)
    );

    Ctrl_WB Ctrl_WB1(
        .clk(CPU_CLK),
        .bubbleW(bubbleW),
        .flushW(flushW),
        .reg_write_en_MEM(reg_write_en_MEM),
        .reg_write_en_WB(reg_write_en_WB)
    );


    // ---------------------------------------------
    // WB stage
    // ---------------------------------------------



    // ---------------------------------------------
    // Harzard Unit
    // ---------------------------------------------
    HarzardUnit HarzardUnit1(
        .rst(CPU_RST),
        .reg1_srcD(inst_ID[19:15]),
        .reg2_srcD(inst_ID[24:20]),
        .reg1_srcE(reg1_src_EX),
        .reg2_srcE(reg2_src_EX),
        .reg_dstE(reg_dest_EX),
        .reg_dstM(reg_dest_MEM),
        .reg_dstW(reg_dest_WB),
        .br(br),
        .jalr(jalr_EX),
        .jal(jal),
        .wb_select(wb_select_EX),
        .reg_write_en_MEM(reg_write_en_MEM),
        .reg_write_en_WB(reg_write_en_WB),
        .flushF(flushF),
        .bubbleF(bubbleF),
        .flushD(flushD),
        .bubbleD(bubbleD),
        .flushE(flushE),
        .bubbleE(bubbleE),
        .flushM(flushM),
        .bubbleM(bubbleM),
        .flushW(flushW),
        .bubbleW(bubbleW),
        .op1_sel(op1_sel),
        .op2_sel(op2_sel)
    );  
    	         
endmodule
`timescale 1ns / 1ps

module cpu_tb();
    reg clk = 1'b1;
    reg rst = 1'b1;
    
    always  #1 clk = ~clk;
    initial #8 rst = 1'b0;
    
    wire [31:0] debug_PC_IF;
    /*    wire [31:0] debug_jal_target, debug_jalr_target;
        wire [31:0] debug_PC_ID, debug_inst_ID;
        wire [31:0] debug_PC_EX, debug_br_target, debug_reg1_EX, debug_reg2_EX, debug_imm_EX;
        wire [4:0] debug_reg1_src_EX, debug_reg2_src_EX, debug_reg_dest_EX;
        wire debug_jalr_EX;
        wire [3:0] debug_ALU_func_EX;
        wire [2:0] debug_br_type_EX;
        wire debug_load_npc_EX;
        wire debug_wb_select_EX;
        wire [2:0] debug_load_type_EX;
        wire debug_reg_write_en_EX;
        wire [3:0] debug_cache_write_en_EX;
        wire debug_op1_src_EX, debug_op2_src_EX;
        wire [2:0]debug_imm_type;
        wire debug_jal;
        wire debug_br;
        wire [31:0] debug_result_MEM, debug_reg2_MEM;
        wire [4:0] debug_reg_dest_MEM;
        wire debug_wb_select_MEM;
        wire [2:0] debug_load_type_MEM;
        wire debug_reg_write_en_MEM;
        wire [3:0] debug_cache_write_en_MEM;
        wire [31:0] debug_data_WB;
        wire [4:0] debug_reg_dest_WB;
        wire debug_reg_write_en_WB;*/
        wire debug_miss;
        wire debug_ref_signal;
    
    RV32ICore RV32ICore_tb_inst(
        .CPU_CLK    ( clk          ),
        .CPU_RST    ( rst          ),
        .debug_PC_IF(debug_PC_IF),
        /*        .debug_jal_target(debug_jal_target),
                .debug_jalr_target(debug_jalr_target),
                .debug_PC_ID(debug_PC_ID),
                .debug_inst_ID(debug_inst_ID),
                .debug_PC_EX(debug_PC_EX),
                .debug_br_target(debug_br_target),
                .debug_reg1_EX(debug_reg1_EX),
                .debug_reg2_EX(debug_reg2_EX),
                .debug_imm_EX(debug_imm_EX),
                .debug_reg1_src_EX(debug_reg1_src_EX),
                .debug_reg2_src_EX(debug_reg2_src_EX),
                .debug_reg_dest_EX(debug_reg_dest_EX),
                .debug_jalr_EX(debug_jalr_EX),
                .debug_ALU_func_EX(debug_ALU_func_EX),
                .debug_br_type_EX(debug_br_type_EX),
                .debug_load_npc_EX(debug_load_npc_EX),
                .debug_wb_select_EX(debug_wb_select_EX),
                .debug_load_type_EX(debug_load_type_EX),
                .debug_reg_write_en_EX(debug_reg_write_en_EX),
                .debug_cache_write_en_EX(debug_cache_write_en_EX),
                .debug_op1_src_EX(debug_op1_src_EX),
                .debug_op2_src_EX(debug_op2_src_EX),
                .debug_imm_type(debug_imm_type),
                .debug_jal(debug_jal),
                .debug_br(debug_br),
                .debug_result_MEM(debug_result_MEM),
                .debug_reg2_MEM(debug_reg2_MEM),
                .debug_reg_dest_MEM(debug_reg_dest_MEM),
                .debug_wb_select_MEM(debug_wb_select_MEM),
                .debug_load_type_MEM(debug_load_type_MEM),
                .debug_reg_write_en_MEM(debug_reg_write_en_MEM),
                .debug_cache_write_en_MEM(debug_cache_write_en_MEM),
                .debug_data_WB(debug_data_WB),
                .debug_reg_dest_WB(debug_reg_dest_WB),
                .debug_reg_write_en_WB(debug_reg_write_en_WB),*/
                .debug_miss(debug_miss),
                .debug_ref_signal(debug_ref_signal)
    );
    
    reg [31:0]ref_count, miss_count,clk_count;
    always @ (posedge clk or posedge rst)
    begin
        if(rst)
        begin
            clk_count <=0;
        end 
        else
        begin
            clk_count <= clk_count + 1;
        end
    end
    initial 
    begin
        ref_count = 0;
        miss_count = 0;
    end
    always @ (posedge debug_miss)
    begin
        miss_count <= miss_count+1;
    end
    
    always @ (posedge debug_ref_signal)
    begin
        ref_count <= ref_count+1;
    end
    
endmodule

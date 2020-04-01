`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Instruction Seg Reg
// Tool Versions: Vivado 2017.4.1
// Description: Instruction seg reg for IF\ID
// 
//////////////////////////////////////////////////////////////////////////////////

//  功能说明
    // IF\ID的指令段寄存器
// 输入
    // clk               时钟信号
    // write_en          Instruction Cache的debug写使能
    // addr              Instruction Cache的读指令地址
    // debug_addr        Instruction Cache的debug读指令地址
    // debug_input       Instruction Cache的debug写入数据
    // bubbleD           ID阶段的bubble信号
    // flushD            ID阶段的flush信号
// 输出
    // inst_ID           传给下一流水段的指令
    // debug_data        Instruction Cache的debug读出指令
// 实验要求  
    // 无需修改


module IR_ID(
    input wire clk, bubbleD, flushD,
    input wire write_en,
    input wire [31:2] addr, debug_addr,
    input wire [31:0] debug_input,
    output wire [31:0] inst_ID,
    output wire [31:0] debug_data
    );




    wire [31:0] inst_ID_raw;


    InstructionCache InstructionCache1(
        .clk(clk),
        .write_en(write_en),
        .addr(addr),
        .debug_addr(debug_addr),
        .debug_input(debug_input),
        .data(inst_ID_raw),
        .debug_data(debug_data)
    );

    // Add flush and bubble support
    // if chip not enabled, output output last read result
    // else if chip clear, output 0
    // else output values from cache
    reg bubble_ff = 1'b0;
    reg flush_ff = 1'b0;
    reg [31:0] inst_ID_old = 32'b0;

    always@(posedge clk)
    begin
        bubble_ff <= bubbleD;
        flush_ff <= flushD;
        inst_ID_old <= inst_ID_raw;
    end

    assign inst_ID = bubble_ff ? inst_ID_old : (flush_ff ? 32'b0 : inst_ID_raw);

    
endmodule
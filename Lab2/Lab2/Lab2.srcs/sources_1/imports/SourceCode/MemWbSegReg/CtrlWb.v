`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: Ctrl_WB
// Module Name: Control Signal Seg Reg
// Tool Versions: Vivado 2017.4.1
// Description: Control signal seg reg for MEM\WB
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    // MEM\WB的控制信号段寄存器
// 输入
    // clk                  时钟信号
    // reg_write_en_MEM     通用寄存器写使能
    // bubbleW              WB阶段的bubble信号
    // flushW               WB阶段的flush信号
// 输出
    // reg_write_en_WB      传给下一流水段的通用寄存器写使能

// 实验要求  
    // 无需修改



module Ctrl_WB(
    input wire clk, bubbleW, flushW,
    input wire reg_write_en_MEM,
    output reg reg_write_en_WB
    );

    initial reg_write_en_WB = 0;
    
    always@(posedge clk)
        if (!bubbleW) 
        begin
            if (flushW)
                reg_write_en_WB <= 0;
            else 
                reg_write_en_WB <= reg_write_en_MEM;
        end
    
endmodule
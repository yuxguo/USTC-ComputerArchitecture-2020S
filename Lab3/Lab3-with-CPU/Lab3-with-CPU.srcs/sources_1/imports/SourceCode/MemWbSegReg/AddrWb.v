`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: Addr_WB
// Module Name: Register Address seg reg
// Tool Versions: Vivado 2017.4.1
// Description: Register address seg reg for MEM\WB
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    // MEM\WB的寄存器地址段寄存器，包括两个源寄存器和一个目标寄存器的地址
// 输入
    // clk               时钟信号
    // reg_dest_MEM      MEM阶段的目标寄存器地址
    // bubbleW           WB阶段的bubble信号
    // flushW            WB阶段的flush信号
// 输出
    // reg_dest_WB       传给下一流水段的目标寄存器地址
// 实验要求  
    // 无需修改

module Addr_WB(
    input wire clk, bubbleW, flushW,
    input wire [4:0] reg_dest_MEM,
    output reg [4:0] reg_dest_WB
    );

    initial reg_dest_WB = 4'h0;
    
    always@(posedge clk)
        if (!bubbleW) 
        begin
            if (flushW)
                reg_dest_WB <= 4'h0;
            else 
                reg_dest_WB <= reg_dest_MEM;
        end
    
endmodule
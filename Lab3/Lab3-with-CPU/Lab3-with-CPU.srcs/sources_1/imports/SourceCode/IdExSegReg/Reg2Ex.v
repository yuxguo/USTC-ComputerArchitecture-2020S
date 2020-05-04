`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Register 2 Seg Reg
// Tool Versions: Vivado 2017.4.1
// Description: Register 2 Seg Reg for ID\EX
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    // ID\EX的寄存器段寄存器
// 输入
    // clk               时钟信号
    // reg2              General Register File读取的寄存器2内容
    // bubbleE           EX阶段的bubble信号
    // flushE            EX阶段的flush信号
// 输出
    // reg2_EX           传给下一流水段的寄存器2内容
// 实验要求  
    // 无需修改


module Reg2_EX(
    input wire clk, bubbleE, flushE,
    input wire [31:0] reg2,
    output reg [31:0] reg2_EX
    );

    initial reg2_EX = 0;
    
    always@(posedge clk)
        if (!bubbleE) 
        begin
            if (flushE)
                reg2_EX <= 0;
            else 
                reg2_EX <= reg2;
        end
    
endmodule
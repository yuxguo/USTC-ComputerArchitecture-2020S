`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: BR Target Seg Reg
// Tool Versions: Vivado 2017.4.1
// Description: Jal\Branch Target Seg Reg for ID\EX
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    // Jal\Branch跳转地址的段寄存器
    // Jal的跳转地址在ID阶段计算好并返回NPC_Generator
    // Branch的跳转地址在ID阶段计算好，下一阶段返回NPC_Generator
// 输入
    // clk               时钟信号
    // address           跳转地址(Jal或Branch)
    // bubbleE           EX阶段的bubble信号
    // flushE            EX阶段的flush信号
// 输出
    // address_EX        传给下一流水段的跳转地址(Branch)
// 实验要求  
    // 无需修改


module BR_Target_EX(
    input wire clk, bubbleE, flushE,
    input wire [31:0] address,
    output reg [31:0] address_EX
    );

    initial address_EX = 0;
    
    always@(posedge clk)
        if (!bubbleE) 
        begin
            if (flushE)
                address_EX <= 0;
            else 
                address_EX <= address;
        end
    
endmodule
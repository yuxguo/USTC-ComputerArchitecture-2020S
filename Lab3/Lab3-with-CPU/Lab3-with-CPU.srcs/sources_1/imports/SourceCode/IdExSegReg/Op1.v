`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Operator 1 Seg Reg
// Tool Versions: Vivado 2017.4.1
// Description: Operator 1 Seg Reg for ID\EX
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    // ID\EX的操作数1段寄存器
// 输入
    // clk               时钟信号
    // reg1              General Register File读取的寄存器1内容
    // bubbleE           EX阶段的bubble信号
    // flushE            EX阶段的flush信号
// 输出
    // reg1_EX           传给下一流水段的寄存器1内容
// 实验要求  
    // 无需修改

module Op1_EX(
    input wire clk, bubbleE, flushE,
    input wire [31:0] reg1,
    output reg [31:0] reg1_EX
    );

    initial reg1_EX = 0;
    
    always@(posedge clk)
        if (!bubbleE) 
        begin
            if (flushE)
                reg1_EX <= 0;
            else 
                reg1_EX <= reg1;
        end
    
endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Register Address seg reg
// Tool Versions: Vivado 2017.4.1
// Description: Register address seg reg for EX\MEM
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    // EX\MEM的寄存器地址段寄存器，包括两个源寄存器和一个目标寄存器的地址
// 输入
    // clk               时钟信号
    // reg_dest_EX       EX阶段的目标寄存器地址
    // bubbleM           MEM阶段的bubble信号
    // flushM            MEM阶段的flush信号
// 输出
    // reg_dest_MEM       传给下一流水段的目标寄存器地址
// 实验要求  
    // 无需修改

module Addr_MEM(
    input wire clk, bubbleM, flushM,
    input wire [4:0] reg_dest_EX,
    output reg [4:0] reg_dest_MEM
    );

    initial reg_dest_MEM = 0;
    
    always@(posedge clk)
        if (!bubbleM) 
        begin
            if (flushM)
                reg_dest_MEM <= 0;
            else 
                reg_dest_MEM <= reg_dest_EX;
        end
    
endmodule
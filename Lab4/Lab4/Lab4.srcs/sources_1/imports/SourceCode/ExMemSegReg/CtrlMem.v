`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: Ctrl_MEM
// Module Name: Control Signal Seg Reg
// Tool Versions: Vivado 2017.4.1
// Description: Control signal seg reg for EX\MEM
// 
//////////////////////////////////////////////////////////////////////////////////


//  功能说明
    // EX\MEM的控制信号段寄存器?
// 输入
    // clk                  时钟信号
    // wb_select_EX         写回寄存器的值的来源（Cache内容或者ALU计算结果）
    // load_type_EX         load类型
    // reg_write_en_EX      通用寄存器写使能
    // cache_write_en_EX    按字节写入data cache
    // bubbleM              EX阶段的bubble信号
    // flushM               EX阶段的flush信号
// 输出
    // wb_select_MEM        传给下一流水段的写回寄存器的值的来源（Cache内容或者ALU计算结果）
    // load_type_MEM        传给下一流水段的load类型
    // reg_write_en_MEM     传给下一流水段的通用寄存器写使能
    // cache_write_en_MEM   传给下一流水段的按字节写入data cache

// 实验要求  
    // 无需修改



module Ctrl_MEM(
    input wire clk, bubbleM, flushM,
    input wire wb_select_EX,
    input wire [2:0] load_type_EX,
    input wire reg_write_en_EX,
    input wire [3:0] cache_write_en_EX,
    output reg wb_select_MEM,
    output reg [2:0] load_type_MEM,
    output reg reg_write_en_MEM,
    output reg [3:0] cache_write_en_MEM
    );

    initial 
    begin
        wb_select_MEM = 0;
        load_type_MEM = 2'h0;
        reg_write_en_MEM = 0;
        cache_write_en_MEM = 3'h0;
    end
    
    always@(posedge clk)
        if (!bubbleM) 
        begin
            if (flushM)
            begin
                wb_select_MEM <= 0;
                load_type_MEM <= 2'h0;
                reg_write_en_MEM <= 0;
                cache_write_en_MEM <= 3'h0;
            end
            else
            begin
                wb_select_MEM <= wb_select_EX;
                load_type_MEM <= load_type_EX;
                reg_write_en_MEM <= reg_write_en_EX;
                cache_write_en_MEM <= cache_write_en_EX;
            end
        end
    
endmodule
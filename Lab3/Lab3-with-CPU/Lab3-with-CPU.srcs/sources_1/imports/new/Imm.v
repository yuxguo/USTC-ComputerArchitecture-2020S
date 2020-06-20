`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC
// Engineer: Yuxuan Guo
// 
// Design Name: Imm_EX
// 
//////////////////////////////////////////////////////////////////////////////////

// ¹¦ÄÜ: ID/EX.Imm ¶Î¼Ä´æÆ÷



module Imm_EX(
    input wire clk, bubbleE, flushE,
    input wire [31:0] imm_in,
    output reg [31:0] imm_out
    );

    initial imm_out = 0;
    
    always@(posedge clk)
        if (!bubbleE) 
        begin
            if (flushE)
                imm_out <= 0;
            else 
                imm_out <= imm_in;
        end
    
endmodule
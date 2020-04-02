`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2020 03:12:10 PM
// Design Name: 
// Module Name: CSR_EX
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module CSR_EX(
    input wire clk, bubbleE, flushE,
    input wire [31:0] CSR_data_ID,
    input wire [11:0] CSR_addr_ID,
    input wire [31:0] CSR_zimm_ID,
    input wire CSR_zimm_or_reg_ID,
    input wire CSR_write_en_ID,
    output reg [31:0] CSR_data_EX,
    output reg [11:0] CSR_addr_EX,
    output reg [31:0] CSR_zimm_EX,
    output reg CSR_zimm_or_reg_EX,
    output reg CSR_write_en_EX
    );
    initial
    begin
        CSR_data_EX = 0;
        CSR_addr_EX = 0;
        CSR_write_en_EX = 0;
        CSR_zimm_EX = 0;
        CSR_zimm_or_reg_EX = 0;
    end    
    always@(posedge clk)
    begin
        if (!bubbleE) 
        begin
            if (flushE)
            begin
                CSR_data_EX <= 0;
                CSR_addr_EX <= 0;
                CSR_write_en_EX <= 0;
                CSR_zimm_EX <= 0;
                CSR_zimm_or_reg_EX <= 0;
            end
            else
            begin
                CSR_data_EX <= CSR_data_ID;
                CSR_addr_EX <= CSR_addr_ID;
                CSR_write_en_EX <= CSR_write_en_ID;
                CSR_zimm_EX <= CSR_zimm_ID;
                CSR_zimm_or_reg_EX <= CSR_zimm_or_reg_ID;
            end
        end
    end
endmodule

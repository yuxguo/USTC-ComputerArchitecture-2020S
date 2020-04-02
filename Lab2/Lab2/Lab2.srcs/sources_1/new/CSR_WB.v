`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2020 03:26:06 PM
// Design Name: 
// Module Name: CSR_WB
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


module CSR_WB(
    input wire clk, bubbleW, flushW,
    input wire [31:0] CSR_data_MEM,
    input wire [11:0] CSR_addr_MEM,
    input wire CSR_write_en_MEM,
    output reg [31:0] CSR_data_WB,
    output reg [11:0] CSR_addr_WB,
    output reg CSR_write_en_WB
    );
    initial
    begin
        CSR_data_WB = 0;
        CSR_addr_WB = 0;
        CSR_write_en_WB = 0;
    end    
    always@(posedge clk)
    begin
        if (!bubbleW) 
        begin
            if (flushW)
            begin
                CSR_data_WB <= 0;
                CSR_addr_WB <= 0;
                CSR_write_en_WB <= 0;
            end
            else
            begin
                CSR_data_WB <= CSR_data_MEM;
                CSR_addr_WB <= CSR_addr_MEM;
                CSR_write_en_WB <= CSR_write_en_MEM;
            end
        end
    end
endmodule

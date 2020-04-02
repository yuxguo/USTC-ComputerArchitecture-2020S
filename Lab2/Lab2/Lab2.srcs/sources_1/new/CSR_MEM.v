`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2020 03:21:27 PM
// Design Name: 
// Module Name: CSR_MEM
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


module CSR_MEM(
    input wire clk, bubbleM, flushM,
    input wire [31:0] CSR_data_EX,
    input wire [11:0] CSR_addr_EX,
    input wire CSR_write_en_EX,
    output reg [31:0] CSR_data_MEM,
    output reg [11:0] CSR_addr_MEM,
    output reg CSR_write_en_MEM
    );
    initial
    begin
        CSR_data_MEM = 0;
        CSR_addr_MEM = 0;
        CSR_write_en_MEM = 0;
    end    
    always@(posedge clk)
    begin
        if (!bubbleM) 
        begin
            if (flushM)
            begin
                CSR_data_MEM <= 0;
                CSR_addr_MEM <= 0;
                CSR_write_en_MEM <= 0;
            end
            else
            begin
                CSR_data_MEM <= CSR_data_EX;
                CSR_addr_MEM <= CSR_addr_EX;
                CSR_write_en_MEM <= CSR_write_en_EX;
            end
        end
    end
endmodule

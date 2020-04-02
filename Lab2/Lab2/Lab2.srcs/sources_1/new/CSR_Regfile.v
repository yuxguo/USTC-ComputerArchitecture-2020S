`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2020 03:10:25 PM
// Design Name: 
// Module Name: CSR_Regfile
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


// XLEN = 32

module CSR_Regfile(
    input wire clk,
    input wire rst,
    input wire CSR_write_en,
    input wire [11:0] CSR_write_addr,
    input wire [11:0] CSR_read_addr,
    input wire [31:0] CSR_data_write,
    output wire [31:0] CSR_data_read
    );
    parameter CSR = 2**12;
    parameter XLEN = 32;
    reg [XLEN-1:0] reg_file[CSR-1:0];
    integer i;

    // init register file
    initial
    begin
        for(i = 0; i < CSR; i = i + 1) 
            reg_file[i][XLEN-1:0] <= 32'b0;
    end

    // write in clk negedge, reset in rst posedge
    // if write register in clk posedge,
    // new wb data also write in clk posedge,
    // so old wb data will be written to register
    always@(negedge clk or posedge rst) 
    begin 
        if (rst)
            for (i = 1; i < CSR; i = i + 1) 
                reg_file[i][XLEN-1:0] <= 32'b0;
        else if(CSR_write_en)
            reg_file[CSR_write_addr] <= CSR_data_write;   
    end

    // read data changes when address changes
    assign CSR_data_read = reg_file[CSR_read_addr];




endmodule

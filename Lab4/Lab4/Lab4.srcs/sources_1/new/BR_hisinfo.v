`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2020 11:19:44 PM
// Design Name: 
// Module Name: BR_hisinfo
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


module BR_hisinfo(
    input clk, rst,
    input Br_pred_in,
    input [31:0] PC_in, 
    output Br_pred_out,
    output [31:0] PC_out
    );
    localparam LEN = 2;
    reg [31:0] PC_buffer [LEN-1:0];
    reg Br_pred_buffer [LEN-1:0];
    integer i;
    
    assign PC_out = PC_buffer[LEN-1];
    assign Br_pred_out = Br_pred_buffer[LEN-1];
    
    always @ (posedge clk or posedge rst)
    begin
        if (rst)
        begin
            for (i = 0; i < LEN; i = i + 1)
            begin
                PC_buffer[i] <= 0;
                Br_pred_buffer[i] <= 0;
            end
        end
        else 
        begin
            PC_buffer[0] <= PC_in;
            Br_pred_buffer[0] <= Br_pred_in;
            for (i = 1; i < LEN; i = i + 1)
            begin
                PC_buffer[i] <= PC_buffer[i-1];
                Br_pred_buffer[i] <= Br_pred_buffer[i-1];
            end
        end
    end
    
endmodule

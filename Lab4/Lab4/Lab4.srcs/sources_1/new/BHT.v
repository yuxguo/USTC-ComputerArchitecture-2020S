`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2020 08:39:10 PM
// Design Name: 
// Module Name: BHT
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


module BHT #(
    parameter SET_LEN = 12,
    parameter BITS = 2
)
(
    input clk, rst,
    input [31:0] PC_query,  PC_update,
    input BR, update,
    output BHT_br
    );
    localparam SET_SIZE = 1 << SET_LEN;
    localparam MAX_VAL = (1 << BITS) - 1;
    localparam THRESHOD = MAX_VAL / 2;
    
    reg [BITS-1 : 0] STATE [0 : SET_SIZE-1];
    
    
    wire [SET_LEN-1 : 0] query_addr, update_addr;
    assign query_addr = PC_query[SET_LEN-1 : 0];
    assign update_addr = PC_update[SET_LEN-1 : 0];
    integer i;
    always @ (posedge clk or posedge rst)
    begin
        if (rst)
        begin
            for (i = 0; i < SET_SIZE; i = i + 1)
            begin
                STATE[i] <= 0;
            end
        end
        else
        begin
            if (update)
            begin
                if (BR == 1)
                begin
                    STATE[update_addr] <= (STATE[update_addr] == MAX_VAL) ? STATE[update_addr] : STATE[update_addr] + 1;
                end
                else
                begin
                    STATE[update_addr] <= (STATE[update_addr] == 0) ? STATE[update_addr] : STATE[update_addr] - 1;
                end
            end
        end
    end
    
    assign BHT_br = (STATE[query_addr] > THRESHOD) ? 1'b1 : 1'b0;
endmodule

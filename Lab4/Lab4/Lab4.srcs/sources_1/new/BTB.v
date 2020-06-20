`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2020 08:07:58 PM
// Design Name: 
// Module Name: BTB
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


module BTB #(
    parameter SET_LEN = 12,
    parameter TAG_LEN = 20
)
(
    input clk, rst,
    input [31:0] PC_query, PC_update, update_data,
    input update, BR,
    output BTB_hit, BTB_br,
    output [31:0] PC_pred
    );
    localparam SET_SIZE = 1 << SET_LEN;
    wire [SET_LEN-1 : 0]query_addr, update_addr;
    wire [TAG_LEN-1 : 0]query_tag, update_tag;
    
    reg [TAG_LEN-1 : 0] TAG [0 : SET_SIZE-1];
    reg [31:0] DATA [0 : SET_SIZE-1];
    reg VALID [0 : SET_SIZE-1];
    reg STATE [0 : SET_SIZE-1];
    
    assign {query_tag, query_addr} = PC_query;
    assign {update_tag, update_addr} = PC_update;
    integer i;
    always @ (posedge clk or posedge rst)
    begin
        if (rst)
        begin
            for (i = 0; i < SET_SIZE; i = i+1)
            begin
                TAG[i] <= 0;
                DATA[i] <= 0;
                VALID[i] <= 0;
                STATE[i] <= 0;
            end
        end
        else 
        begin
            if (update)
            begin
                if (BR)
                begin
                    TAG[update_addr] <=  update_tag;
                    DATA[update_addr] <= update_data;
                    VALID[update_addr] <= 1'b1;
                    STATE[update_addr] <= 1'b1;
                end
                else
                begin
                    TAG[update_addr] <=  update_tag;
                    DATA[update_addr] <= update_data;
                    VALID[update_addr] <= 1'b1;
                    STATE[update_addr] <= 1'b0;
                end
            end
        end
    end
    
    assign BTB_hit = ( (TAG[query_addr] == query_tag) && (VALID[query_addr] == 1'b1) ) ? 1'b1 : 1'b0;
    assign BTB_br = ( (TAG[query_addr] == query_tag) && (VALID[query_addr] == 1'b1) && (STATE[query_addr] == 1'b1) ) ? 1'b1 : 1'b0;
    assign PC_pred = DATA[query_addr];
    
endmodule

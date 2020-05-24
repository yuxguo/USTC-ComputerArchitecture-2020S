`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/22/2020 10:31:56 PM
// Design Name: 
// Module Name: BTBandBHT
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


module BranchPrediction # (
    parameter SET_LEN = 12,
    parameter TAG_LEN = 20
)
(
    input clk, rst,
    input [31:0] PC_query, PC_update, PC_target,
    input update, BR,
    output reg branch_prediction_miss,
    output reg [31:0] NPC,
    output debug_BR_pred
    );
    
    localparam stage = 2;
    
    wire onlyBTB_hit, onlyBTB_br;
    wire BTB_hit, BTB_br;
    wire [31:0] BTB_PC_pred;
    wire BHT_br;
    wire [31:0] PC_next;
    
    assign PC_next = PC_query + 4;
    
    wire [31:0]onlyBTB_PC_pred;
    wire Br_pred_in, Br_pred_out;
    wire [31:0] PC_out, PC_pred;
    
    // only BTB predict
    assign Br_pred_in = (stage == 1) ? onlyBTB_br : (BTB_hit & BHT_br);
    assign PC_pred = (stage == 1) ? onlyBTB_PC_pred : BTB_PC_pred;
    // assign PC_pred = onlyBTB_br ? onlyBTB_PC_pred : PC_query;
    
    assign debug_BR_pred = Br_pred_in;
    
    always @ (*)
    begin
        if (update)
        begin
            // if is EX Branch instruction
            if (Br_pred_out == BR)
            begin
                // branch predict successfully
                NPC = Br_pred_in ? PC_pred : PC_next;
                branch_prediction_miss = 0;
            end
            else
            begin
                // branch predict failed at  2 cycles before
                // if current is branch so NPC is br_target, else is PC_EX + 4
                NPC = BR ? PC_target : PC_out;
                branch_prediction_miss = 1;
            end
        end
        else
        begin
            // EX is not Branch Instruction
            NPC = Br_pred_in ? PC_pred : PC_next;
            branch_prediction_miss = 0;
        end
        
    end 
    
    
    BR_hisinfo BR_hist(
        .clk(clk),
        .rst(rst),
        .Br_pred_in(Br_pred_in),
        .PC_in(PC_next),
        .Br_pred_out(Br_pred_out),
        .PC_out(PC_out)
    );
    
    
    BTB #(
        .SET_LEN(SET_LEN),
        .TAG_LEN(TAG_LEN)
    ) onlyBTB (
        .clk(clk),
        .rst(rst),
        .PC_query(PC_query),
        .PC_update(PC_update),
        .update_data(PC_target),
        .update(update),
        .BR(BR),
        .BTB_hit(onlyBTB_hit),
        .BTB_br(onlyBTB_br),
        .PC_pred(onlyBTB_PC_pred)
    );
    
    BTB #(
        .SET_LEN(SET_LEN),
        .TAG_LEN(TAG_LEN)
    ) btb (
        .clk(clk),
        .rst(rst),
        .PC_query(PC_query),
        .PC_update(PC_update),
        .update_data(PC_target),
        .update(update),
        .BR(BR),
        .BTB_hit(BTB_hit),
        .BTB_br(BTB_br),
        .PC_pred(BTB_PC_pred)
    );
    
    BHT # (
        .SET_LEN(SET_LEN),
        .BITS(2)
    ) bht (
        .clk(clk),
        .rst(rst),
        .PC_query(PC_query),
        .PC_update(PC_update),
        .update(update),
        .BR(BR),
        .BHT_br(BHT_br)
    );
    
endmodule

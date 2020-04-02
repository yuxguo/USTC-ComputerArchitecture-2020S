`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Data Cache
// Tool Versions: Vivado 2017.4.1
// Description: RV32I Data Cache
// 
//////////////////////////////////////////////////////////////////////////////////

// 功能说明
    // 同步读写Cache
    // debug端口用于simulation时批量读写数据，可以忽略
// 输入
    // clk               输入时钟
    // write_en          写使�?
    // debug_write_en    debug写使�?
    // addra             读写地址
    // debug_addr        debug读写地址
    // in_data           写入数据
    // debug_in_data     debug写入数据
    // out_data          输出数据
    // debug_out_data    debug输出数据
// 输出
    // douta             a口读数据
    // doutb             b口读数据
// 实验要求  
    // 无需修改


module DataCache(
    input wire clk,
    input wire [3:0] write_en, debug_write_en,
    input wire [31:2] addr, debug_addr,
    input wire [31:0] in_data, debug_in_data,
    output reg [31:0] out_data, debug_out_data
);


    // local variable
    wire addr_valid = (addr[31:14] == 18'h0);
    wire debug_addr_valid = (debug_addr[31:14] == 18'h0);
    wire [11:0] dealt_addr = addr[13:2];
    wire [11:0] dealt_debug_addr = debug_addr[13:2];
    // cache content
    reg [31:0] data_cache[0:15];

    initial begin
        out_data = 32'h0;
        debug_out_data = 32'h0;
        // you can add simulation instructions here
        data_cache[0] = 32'h0;
        // ......
    end

    always@(posedge clk)
    begin
        out_data <= addr_valid ? data_cache[dealt_addr] : 32'h0;
        debug_out_data <= debug_addr_valid ? data_cache[dealt_debug_addr] : 32'h0;
        // write data in bytes
        if (write_en[0] & addr_valid)
            data_cache[dealt_addr][7: 0] <= in_data[7:0];
        if (write_en[1] & addr_valid)
            data_cache[dealt_addr][15: 8] <= in_data[15:8];
        if (write_en[2] & addr_valid)
            data_cache[dealt_addr][23:16] <= in_data[23:16];
        if (write_en[3] & addr_valid)
            data_cache[dealt_addr][31:24] <= in_data[31:24];
        // write debug data in bytes
        if (debug_write_en[0] & debug_addr_valid)
            data_cache[dealt_debug_addr][7: 0] <= debug_in_data[7:0];
        if (debug_write_en[1] & debug_addr_valid)
            data_cache[dealt_debug_addr][15: 8] <= debug_in_data[15:8];
        if (debug_write_en[2] & debug_addr_valid)
            data_cache[dealt_debug_addr][23:16] <= debug_in_data[23:16];
        if (debug_write_en[3] & debug_addr_valid)
            data_cache[dealt_debug_addr][31:24] <= debug_in_data[31:24];
    end

endmodule


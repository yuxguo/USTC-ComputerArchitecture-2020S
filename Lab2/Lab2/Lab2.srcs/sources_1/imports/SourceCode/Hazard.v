`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: USTC ESLAB
// Engineer: Huang Yifan (hyf15@mail.ustc.edu.cn)
// 
// Design Name: RV32I Core
// Module Name: Hazard Module
// Tool Versions: Vivado 2017.4.1
// Description: Hazard Module is used to control flush, bubble and bypass
// 
//////////////////////////////////////////////////////////////////////////////////

//  功能说明
    //  识别流水线中的数据冲突，控制数据转发，和flush、bubble信号
// 输入
    // rst               CPU的rst信号
    // reg1_srcD         ID阶段的源reg1地址
    // reg2_srcD         ID阶段的源reg2地址
    // reg1_srcE         EX阶段的源reg1地址
    // reg2_srcE         EX阶段的源reg2地址
    // reg_dstE          EX阶段的目的reg地址
    // reg_dstM          MEM阶段的目的reg地址
    // reg_dstW          WB阶段的目的reg地址
    // br                是否branch
    // jalr              是否jalr
    // jal               是否jal
    // wb_select         ����EX�ε�WBselect���ж�exָ���Ƿ�Ϊloadָ��
    // reg_write_en_MEM  MEM阶段的寄存器写使能信�?
    // reg_write_en_WB   WB阶段的寄存器写使能信�?
// 输出
    // flushF            IF阶段的flush信号
    // bubbleF           IF阶段的bubble信号
    // flushD            ID阶段的flush信号
    // bubbleD           ID阶段的bubble信号
    // flushE            EX阶段的flush信号
    // bubbleE           EX阶段的bubble信号
    // flushM            MEM阶段的flush信号
    // bubbleM           MEM阶段的bubble信号
    // flushW            WB阶段的flush信号
    // bubbleW           WB阶段的bubble信号
    // op1_sel           00 is reg1, 01 is mem stage forwarding, 01 is wb stage forwarding
    // op2_sel           00 is reg2, 01 is mem stage forwarding, 01 is wb stage forwarding


`include "Parameters.v"   
module HarzardUnit(
    input wire rst,
    input wire [4:0] reg1_srcD, reg2_srcD, reg1_srcE, reg2_srcE, reg_dstE, reg_dstM, reg_dstW,
    input wire br, jalr, jal,
    input wire wb_select,
    input wire reg_write_en_MEM,
    input wire reg_write_en_WB,
    output reg flushF, bubbleF, flushD, bubbleD, flushE, bubbleE, flushM, bubbleM, flushW, bubbleW,
    output reg [1:0] op1_sel, op2_sel
    );

    // TODO: Complete this module
    // generate op1_sel
    always @ (*)
    begin 
        if (reg1_srcE == reg_dstM && reg_write_en_MEM == 1 && reg1_srcE != 0)
        begin
            // mem to ex forwarding, mem forwarding first
            op1_sel = 2'b01;
        end
        else if (reg1_srcE == reg_dstW && reg_write_en_WB == 1 && reg1_srcE != 0)
        begin
            // wb to ex forwarding
            op1_sel = 2'b10;
        end
        else 
        begin
            op1_sel = 2'b00;
        end
    end
    
    // generate op2_sel
    always @ (*)
    begin
        if (reg2_srcE == reg_dstM && reg_write_en_MEM == 1 && reg2_srcE != 0)
        begin
            // mem to ex forwarding, mem forwarding first
            op2_sel = 2'b01;
        end
        else if (reg2_srcE == reg_dstW && reg_write_en_WB == 1 && reg2_srcE != 0)
        begin
            // wb to ex forwarding
            op2_sel = 2'b10;
        end
        else 
        begin
            op2_sel = 2'b00;
        end
    end
    
    // generate bubbleF and flushF and bubbleD and flushD and  bubbleE and flushE
    always @ (*)
    begin
        if (rst)
        begin
            bubbleF = 0;
            flushF = 1;
            bubbleD = 0;
            flushD = 1;
            bubbleE = 0;
            flushD = 1;
        end
        else 
        begin
            if (wb_select == 1 && (reg_dstE == reg1_srcD || reg_dstE == reg2_srcD))
            begin
                // load-use type data hazard, bubble IF, bubble ID, flush EX 
                bubbleF = 1;
                flushF = 0;
                bubbleD = 1;
                flushD = 0;
                bubbleE = 0;
                flushE = 1;
            end
            // implement branch predict with default no branch
            else if (br == 1)
            begin
                // branch instruction, flush ID, 
                bubbleF = 0;
                flushF = 0;
                bubbleD = 0;
                flushD = 1;
                bubbleE = 0;
                flushE = 1;
            end
            else if (jalr == 1)
            begin
                bubbleF = 0;
                flushF = 0;
                bubbleD = 0;
                flushD = 1;
                bubbleE = 0;
                flushE = 1;
            end
            else if (jal == 1)
            begin
                bubbleF = 0;
                flushF = 0;
                bubbleD = 0;
                flushD = 1;
                bubbleE = 0;
                flushE = 0;
            end
            else
            begin
                bubbleF = 0;
                flushF = 0;
                bubbleD = 0;
                flushD = 0;
                bubbleE = 0;
                flushE = 0;
            end
        end
    end
    
    // generate bubbleM and flushM
    always @ (*)
    begin
        if (rst)
        begin
            bubbleM = 0;
            flushM = 1;
        end
        else 
        begin
            bubbleM = 0;
            flushM = 0;
        end
    end
    
    
    // generate bubbleW and flushW
    always @ (*)
    begin
        if (rst)
        begin
            bubbleW = 0;
            flushW = 1;
        end
        else 
        begin
            bubbleW = 0;
            flushW = 0;
        end
    end

endmodule
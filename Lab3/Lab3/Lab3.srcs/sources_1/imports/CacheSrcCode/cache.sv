

module cache #(
    parameter  LINE_ADDR_LEN = 3, // line内地址长度，决定了每个line具有2^3个word, 类似于每个Block有8个字，line=block
    parameter  SET_ADDR_LEN  = 3, // 组地址长度，决定了一共有2^3=8组
    parameter  TAG_ADDR_LEN  = 6, // tag长度
    parameter  WAY_CNT       = 2  // 组相连度，决定了每组中有多少路line，这里是直接映射型cache，因此该参数没用到
)(
    input  clk, rst,
    output miss,               // 对CPU发出的miss信号
    input  [31:0] addr,        // 读写请求地址
    input  rd_req,             // 读请求信号
    output reg [31:0] rd_data, // 读出的数据，一次读一个word
    input  wr_req,             // 写请求信号
    input  [31:0] wr_data      // 要写入的数据，一次写一个word
);
// 主存按照line组织，所以line内部的地址不算
localparam MEM_ADDR_LEN    = TAG_ADDR_LEN + SET_ADDR_LEN ; // 计算主存地址长度 MEM_ADDR_LEN，主存大小=2^MEM_ADDR_LEN个line
localparam UNUSED_ADDR_LEN = 32 - TAG_ADDR_LEN - SET_ADDR_LEN - LINE_ADDR_LEN - 2 ;       // 计算未使用的地址的长度

localparam LINE_SIZE       = 1 << LINE_ADDR_LEN  ;         // 计算 line 中 word 的数量，即 2^LINE_ADDR_LEN 个word 每 line
localparam SET_SIZE        = 1 << SET_ADDR_LEN   ;         // 计算一共有多少组，即 2^SET_ADDR_LEN 个组

reg [            31:0] cache_mem    [SET_SIZE][WAY_CNT][LINE_SIZE]; // SET_SIZE个line，每个line有LINE_SIZE个word，需加上WAY_CNT,下同
reg [TAG_ADDR_LEN-1:0] cache_tags   [SET_SIZE][WAY_CNT];            // SET_SIZE个TAG
reg                    valid        [SET_SIZE][WAY_CNT];            // SET_SIZE个valid(有效位)
reg                    dirty        [SET_SIZE][WAY_CNT];            // SET_SIZE个dirty(脏位)

wire [              2-1:0]   word_addr;                   // 将输入地址addr拆分成这5个部分
wire [  LINE_ADDR_LEN-1:0]   line_addr;
wire [   SET_ADDR_LEN-1:0]    set_addr;
wire [   TAG_ADDR_LEN-1:0]    tag_addr;
wire [UNUSED_ADDR_LEN-1:0] unused_addr;

enum  {IDLE, SWAP_OUT, SWAP_IN, SWAP_IN_OK} cache_stat;    // cache 状态机的状态定义
                                                           // IDLE代表就绪，SWAP_OUT代表正在换出，SWAP_IN代表正在换入，SWAP_IN_OK代表换入后进行一周期的写入cache操作。

reg  [   SET_ADDR_LEN-1:0] mem_rd_set_addr = 0;
reg  [   TAG_ADDR_LEN-1:0] mem_rd_tag_addr = 0;
wire [   MEM_ADDR_LEN-1:0] mem_rd_addr = {mem_rd_tag_addr, mem_rd_set_addr};
reg  [   MEM_ADDR_LEN-1:0] mem_wr_addr = 0;

// add way_idx


reg  [31:0] mem_wr_line [LINE_SIZE];
wire [31:0] mem_rd_line [LINE_SIZE];

wire mem_gnt;      // 主存响应读写的握手信号

assign {unused_addr, tag_addr, set_addr, line_addr, word_addr} = addr;  // 拆分 32bit ADDR

reg cache_hit = 1'b0;
// 判断 输入的address 是否在 cache 中命中，需要改cache hit, 在这个代码块里同时实现LRU和FIFO
// 添加了way_idx 变量，当命中时，这个变量为该组中某个line的下标，当未命中时，这个变量为要换出的line的下标
reg [31:0]way_idx;
reg [31:0]selected_idx;
reg [31:0]history[SET_SIZE][WAY_CNT]; // 每个line的历史信息，对于FIFO是其被换入的时间，对于LRU是其上一次被引用到现在的时间
localparam LRU = 1'b0;




// 对输入的每个rd或wr，都只会生成一个周期的高电平信号ref_signal
// 因为rd和wr信号不止持续一个周期，经过这个状态机后的ref_signal只会有一个周期有效，可以避免在一次读写中多次改变历史信息记录
reg ref_signal, rec_signal;
always @ (posedge clk or posedge rst) 
begin
    if (rst)
    begin
        ref_signal <= 1'b0;
        rec_signal <= 1'b0;
    end
    else 
    begin
        if (rd_req | wr_req) 
        begin
            if (rec_signal == 1'b0 && ref_signal == 1'b0) 
            begin
                rec_signal <= 1'b1;
                ref_signal <= 1'b1;
            end
            else if (rec_signal == 1'b1 && ref_signal == 1'b1)
            begin
                rec_signal <= 1'b1;
                ref_signal <= 1'b0;
            end
        end
        else 
        begin
            ref_signal <= 1'b0;
            rec_signal <= 1'b0;
        end
    end
end

// 这部分是时序电路，只维护历史信息的状态机，selected_idx 信号在一个组合电路中生成
always @ (posedge clk or posedge rst) 
begin
    if (rst) 
    begin
        for(integer i = 0; i < SET_SIZE; i++) 
        begin
            for (integer j = 0; j < WAY_CNT; j++) 
            begin
                history[i][j] <= 32'b0;
            end
        end
    end else begin
        if (LRU == 1'b1) 
        begin // 若使用 LRU 策略
            if (ref_signal) 
            begin 
                // 当cache 收到读或者写信号时，更新 history[set_addr] 中的WAY_CNT个历史信息值，否则不更新值（因为相对大小关系是不变的）
                // 可以理解为 history[set_addr] 中的各个值记录的是 该set被引用到时，每个line上次被引用距现在的次数
                // 若cache命中，置history[set_addr][way_idx]为0，其余则++
                // 若cache 未命中，置history[set_addr][way_idx(selected_idx)]为0，其余则++ 
                for(integer i = 0; i < WAY_CNT; ++i) 
                begin
                    if (i == way_idx) 
                    begin
                        history[set_addr][i] <= 32'b0;
                    end 
                    else 
                    begin
                        history[set_addr][i] <= history[set_addr][i] + 1;
                    end
                end
            end
        end 
        else 
        begin // 否则使用FIFO
            if (cache_stat == SWAP_IN_OK)
            begin
                // 仅当换入成功的时候更新值
                for(integer i = 0; i < WAY_CNT; ++i) 
                begin
                    if (i == way_idx) 
                    begin
                        history[set_addr][i] <= 32'b0;
                    end 
                    else 
                    begin
                        history[set_addr][i] <= history[set_addr][i] + 1;
                    end
                end
            end
        end
    end
end

always @ (*) begin              
    cache_hit = 1'b0;
    way_idx = 32'b0;
    for(integer i = 0; i < WAY_CNT; i++) begin
        if(valid[set_addr][i] && cache_tags[set_addr][i] == tag_addr)   // 如果 cache line有效，并且tag与输入地址中的tag相等，则命中
        begin
            cache_hit = 1'b1;
            way_idx = i;
        end
    end
    if (cache_hit == 1'b0) begin
        // 统一接口，后续的状态机只会使用到way_idx变量，若cache未命中，way_idx是history中选出的最大的下标，是LRU或者FIFO状态机选出的要替换的下标
        for (integer i = 0; i < WAY_CNT; ++i)
        begin
            if(history[set_addr][way_idx] < history[set_addr][i]) 
            begin
                way_idx = i;
            end
        end
    end
end



always @ (posedge clk or posedge rst) begin     // ?? cache ???
    if(rst) begin
        cache_stat <= IDLE;
        for(integer i = 0; i < SET_SIZE; i++) begin 
            for(integer j = 0; j < WAY_CNT; j++) begin 
                dirty[i][j] = 1'b0;
                valid[i][j] = 1'b0;
            end
        end
        for(integer k = 0; k < LINE_SIZE; k++)
            mem_wr_line[k] <= 0;
        mem_wr_addr <= 0;
        {mem_rd_tag_addr, mem_rd_set_addr} <= 0;
        rd_data <= 0;
    end else begin
        case(cache_stat)
        IDLE:       begin
                        if(cache_hit) begin
                            if(rd_req) begin    // 如果cache命中，并且是读请求，
                                rd_data <= cache_mem[set_addr][way_idx][line_addr];   //则直接从cache中取出要读的数据
                            end else if(wr_req) begin // 如果cache命中，并且是写请求，
                                cache_mem[set_addr][way_idx][line_addr] <= wr_data;   // 则直接向cache中写入数据
                                dirty[set_addr][way_idx] <= 1'b1;                     // 写数据的同时置脏位
                            end 
                        end else begin
                            if(wr_req | rd_req) begin   // 如果 cache 未命中，并且有读写请求，则需要进行换入
                                if(valid[set_addr][way_idx] & dirty[set_addr][way_idx]) begin    // 如果 要换入的cache line 本来有效，且脏，则需要先将它换出
                                    cache_stat  <= SWAP_OUT;
                                    mem_wr_addr <= {cache_tags[set_addr][way_idx], set_addr};
                                    mem_wr_line <= cache_mem[set_addr][way_idx];
                                end else begin                                   // 反之，不需要换出，直接换入
                                    cache_stat  <= SWAP_IN;
                                end
                                {mem_rd_tag_addr, mem_rd_set_addr} <= {tag_addr, set_addr};
                            end
                        end
                    end
        SWAP_OUT:   begin
                        if(mem_gnt) begin           // 如果主存握手信号有效，说明换出成功，跳到下一状态
                            cache_stat <= SWAP_IN;
                        end
                    end
        SWAP_IN:    begin
                        if(mem_gnt) begin           // 如果主存握手信号有效，说明换入成功，跳到下一状态
                            cache_stat <= SWAP_IN_OK;
                        end
                    end
        SWAP_IN_OK: begin           // 上一个周期换入成功，这周期将主存读出的line写入cache，并更新tag，置高valid，置低dirty
                        for(integer i=0; i<LINE_SIZE; i++)  cache_mem[mem_rd_set_addr][way_idx][i] <= mem_rd_line[i];
                        cache_tags[mem_rd_set_addr][way_idx] <= mem_rd_tag_addr;
                        valid     [mem_rd_set_addr][way_idx] <= 1'b1;
                        dirty     [mem_rd_set_addr][way_idx] <= 1'b0;
                        cache_stat <= IDLE;        // 回到就绪状态
                    end
        endcase
    end
end

wire mem_rd_req = (cache_stat == SWAP_IN );
wire mem_wr_req = (cache_stat == SWAP_OUT);
wire [   MEM_ADDR_LEN-1 :0] mem_addr = mem_rd_req ? mem_rd_addr : ( mem_wr_req ? mem_wr_addr : 0);

assign miss = (rd_req | wr_req) & ~(cache_hit && cache_stat==IDLE) ;     // 当 有读写请求时，如果cache不处于就绪(IDLE)状态，或者未命中，则miss=1

main_mem #(     // 主存，每次读写以line 为单位
    .LINE_ADDR_LEN  ( LINE_ADDR_LEN          ),
    .ADDR_LEN       ( MEM_ADDR_LEN           )
) main_mem_instance (
    .clk            ( clk                    ),
    .rst            ( rst                    ),
    .gnt            ( mem_gnt                ),
    .addr           ( mem_addr               ),
    .rd_req         ( mem_rd_req             ),
    .rd_line        ( mem_rd_line            ),
    .wr_req         ( mem_wr_req             ),
    .wr_line        ( mem_wr_line            )
);

endmodule

# 计算机体系结构实验三-实验报告

-   PB17111568
-   郭雨轩

##简述组相联cache实现

全相联可以看作是组相联的特殊情况，K路组相联即为：在使用set定位到对应的组后，需要的cache块可能在该组中的任意一个位置上，需要并行比较cache组中的每一个块的tag和valid位，来确定最终引用的cache line地址。

首先我们需要把原来直接映射的cache块中的tag部分，valid和dirty位均扩展到way-cnt大小，同时还要添加维护每组中每个块的历史信息的寄存器：

``` verilog
reg [31:0] cache_mem [SET_SIZE][WAY_CNT][LINE_SIZE]; // SET_SIZE个line，每个line有LINE_SIZE个word，需加上WAY_CNT,下同
reg [TAG_ADDR_LEN-1:0] cache_tags   [SET_SIZE][WAY_CNT]; // SET_SIZE个TAG
reg valid [SET_SIZE][WAY_CNT]; // SET_SIZE个valid(有效位)
reg dirty [SET_SIZE][WAY_CNT]; // SET_SIZE个dirty(脏位)
reg [31:0]history[SET_SIZE][WAY_CNT]; // 每个line的历史信息，对于FIFO是其被换入的时间，对于LRU是其上一次被引用到现在的时间
```

其次，对于每次cache引用，我们需要实现一个边沿检测电路，因为实际在CPU使用中，在cache-miss的时候，cache引用信号会长时间有效，但是无论对于LRU还是FIFO策略，我们只需要在每次对内存引用的时候进行状态更新即可，不加入边沿检测电路会导致cache信息维护错误。

``` verilog
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
```

之后我对原代码中获得way-idx的部分进行了修改，当cache命中的时候，way-idx就是我们需要引用的cache块下标，若miss时，则是通过LRU或者FIFO选出的要更新的块的下标：

``` verilog
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
```

得到cache引用的边沿信号后，和组中目的块的下标后，我们就可以着手实现记录历史信息的状态机了，在这里直接贴出代码，注释中非常详细，不再赘述：

``` verilog
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
```

## Cache 性能分析

我对cpu额外添加了两个接口cache-ref和cache-miss，前者会在引用cache时有效，后者会在cachemiss时有效，在testbench中统计这两个信号的上升沿即可计算出缺失率。

### Cache 资源占用

单独对cache文件综合，测试在其余参数不变，仅改变cache组数时两种策略的资源消耗（考虑到对综合报告截图不适合对比，这里采用表格的形式列出各种参数的结果）

| 电路资源 | 1路组相联，8组  | 2路组相联，8组  | 4路组相联，8组  |
| :------: | :-------------: | :-------------: | :-------------: |
|   LRU    | LUT：2%，FF：2% | LUT：4%，FF：4% | LUT：7%，FF：8% |
|   FIFO   | LUT：2%，FF：2% | LUT：4%，FF：4% | LUT：7%，FF：8% |

固定cache 大小不变，对组相联数和组数一起调整：

| 电路资源 | 1路组相联，8组  | 2路组相联，4组  | 4路组相联，2组  |
| :------: | :-------------: | :-------------: | :-------------: |
|   LRU    | LUT：2%，FF：2% | LUT：3%，FF：3% | LUT：4%，FF：3% |
|   FIFO   | LUT：2%，FF：2% | LUT：3%，FF：3% | LUT：4%，FF：3% |

结论：在这部分为看出FIFO的方法于LRU的方法没有明显的电路资源消耗差异，可能的原因是在我对LRU和FIFO两种方法的时间都采用了计数的方式，这种实现方式中，LRU仅比FIFO多一个边沿检测电路，导致两种方法电路资源消耗接近。

### CPU Cache 缺失率统计

同样的，我们使用表格的形式（考虑到对综合报告截图不适合对比，这里采用表格的形式列出各种参数的结果）：

#### 快速排序 256

共访存6079次：

仅改变组相联数：

| 缺失率 | 1路组相联，8组 | 2路组相联，8组 | 4路组相联，8组 |
| :----: | :------------: | :------------: | :------------: |
|  LRU   |     9.54%      |     1.76%      |     1.00%      |
|  FIFO  |     9.54%      |     5.24%      |     0.77%      |

保证cache大小不变，调整组相联数和组数：

| 缺失率 | 1路组相联，8组 | 2路组相联，4组 | 4路组相联，2组 |
| :----: | :------------: | :------------: | :------------: |
|  LRU   |     9.54%      |     9.37%      |     9.27%      |
|  FIFO  |     9.54%      |     8.43%      |     9.14%      |

#### 快速排序 512

共访存13882次：

仅改变组相联数：

| 缺失率 | 1路组相联，8组 | 2路组相联，8组 | 4路组相联，8组 |
| :----: | :------------: | :------------: | :------------: |
|  LRU   |     10.35%     |     6.71%      |     1.91%      |
|  FIFO  |     10.35%     |     7.00%      |     6.06%      |

保证cache大小不变，调整组相联数和组数：

| 缺失率 | 1路组相联，8组 | 2路组相联，4组 | 4路组相联，2组 |
| :----: | :------------: | :------------: | :------------: |
|  LRU   |     10.35%     |     9.47%      |     9.08%      |
|  FIFO  |     10.35%     |     9.04%      |     8.95%      |

#### 矩阵乘法 8

共访存1088次：

仅改变组相联数：

| 缺失率 | 1路组相联，8组 | 2路组相联，8组 | 4路组相联，8组 |
| :----: | :------------: | :------------: | :------------: |
|  LRU   |     24.08%     |     18.20%     |     2.75%      |
|  FIFO  |     24.08%     |     17.18%     |     2.20%      |

保证cache大小不变，调整组相联数和组数：

| 缺失率 | 1路组相联，8组 | 2路组相联，4组 | 4路组相联，2组 |
| :----: | :------------: | :------------: | :------------: |
|  LRU   |     24.08%     |     45.86%     |     35.11%     |
|  FIFO  |     24.08%     |     27.57%     |     38.97%     |

#### 矩阵乘法 16

共访存8448次：

仅改变组相联数：

| 缺失率 | 1路组相联，8组 | 2路组相联，8组 | 4路组相联，8组 |
| :----: | :------------: | :------------: | :------------: |
|  LRU   |     60.22%     |     56.21%     |     22.53%     |
|  FIFO  |     60.22%     |     57.19%     |     20.21%     |

保证cache大小不变，调整组相联数和组数：

| 缺失率 | 1路组相联，8组 | 2路组相联，4组 | 4路组相联，2组 |
| :----: | :------------: | :------------: | :------------: |
|  LRU   |     60.22%     |     59.46%     |     55.11%     |
|  FIFO  |     60.22%     |     59.47%     |     57.95%     |



### 总结

经过上面的4分benchmark的测试，我得出了以下结论：

-   在只改变cache组相连度的时候，cache容量增大，随着组相联度增加，两个应用缺失率大幅度下降，在快速排序中，LRU的效果略好于FIFO；在矩阵乘法中，两种方法各有胜负。
-   在保证cache大小不变，调整组相联数和组数时，随着组相联度增加，两个应用的的缺失率都略有下降，但是FIFO的效果反而好于LRU。

### 结论

对于快速排序应用，建议使用“4路组相联，8组，LRU”的策略，可以有效降低cache丢失率；对于矩阵乘法，建议使用“4路组相联，8组，FIFO”的策略，因为LRU开销较FIFO大且效果不好。
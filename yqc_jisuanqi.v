module yqc_jisuanqi(
    input clk,              // 时钟信号
    input rst,              // 复位信号
    input [3:0] key,        // 按键输入，用于表示运算符和其他控制信号（如清零等）
    input [7:0] data_in,    // 输入的数据
    output wire [7:0] data_out,  // 输出的数据，用于显示结果等，修改为wire类型
    output wire [3:0] seg,   // 七段数码管段选信号，修改为wire类型
    output wire [3:0] dig    // 七段数码管位选信号，修改为wire类型
);

    wire [15:0] result;
    wire overflow;
    wire div_error;

    // 实例化运算控制模块
    operation_control u_operation_control(
     .clk(clk),
     .rst(rst),
     .key(key),
     .data_in(data_in),
     .result(result),
     .overflow(overflow),
     .div_error(div_error)
    );

    // 实例化显示控制模块，并将对应端口连接改为使用wire类型的信号
    display_control u_display_control(
     .clk(clk),
     .rst(rst),
     .data_in(result),
     .overflow(overflow),
     .data_out(data_out),
     .seg(seg),
     .dig(dig)
    );

endmodule
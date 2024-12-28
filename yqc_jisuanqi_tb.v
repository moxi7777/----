`timescale 1ns/1ps  

module tb_yqc_jisuanqi;  

    // 测试平台信号  
    reg clk;              // 时钟信号  
    reg rst;              // 复位信号  
    reg [3:0] key;       // 按键输入  
    reg [7:0] data_in;   // 输入数据  
    
    wire [7:0] data_out; // 输出数据  
    wire [3:0] seg;      // 七段数码管段选信号  
    wire [3:0] dig;      // 七段数码管位选信号  

    // 实例化被测模块 (DUT)  
    yqc_jisuanqi uut (  
        .clk(clk),  
        .rst(rst),  
        .key(key),  
        .data_in(data_in),  
        .data_out(data_out),  
        .seg(seg),  
        .dig(dig)  
    );  

    // 时钟生成  
    initial begin  
        clk = 0;  
        forever #5 clk = ~clk;  // 每5纳秒翻转一次，生成100MHz时钟  
    end  

    // 测试序列  
    initial begin  
        // 初始化输入  
        rst = 1;  // 置位复位信号  
        key = 4'b0000;  
        data_in = 8'b00000000;  
        
        // 等待几个时钟周期  
        #10;  
        rst = 0;  // 释放复位信号  
        
        // 测试用例 1: 计算 3 + 5  
        key = 4'b0000;     // 设置为输入第一个数字  
        data_in = 8'h03;   // num1 = 3  
        #10;  

        key = 4'b0001;     // 设置为输入第二个数字  
        data_in = 8'h05;   // num2 = 5  
        #10;  

        key = 4'b0010;     // 设置运算为加法  
        #10;  

        key = 4'b0011;     // 执行加法操作  
        #10;  

        // 等待并检查结果  
        #10;  // 等待结果计算完成  
        $display("Result of 3 + 5 = %h", data_out); // 打印结果  

        // --------------------------------------------------  
        
        // 测试用例 2: 计算 12 / 4  
        key = 4'b1000;     // 清零/复位  
        #10;  

        key = 4'b0000;     // 设置为输入第一个数字  
        data_in = 8'h0C;   // num1 = 12  
        #10;  

        key = 4'b0001;     // 设置为输入第二个数字  
        data_in = 8'h04;   // num2 = 4  
        #10;  

        key = 4'b0100;     // 设置运算为除法  
        #10;  

        key = 4'b0011;     // 执行除法操作  
        #10;  

        // 等待并检查结果  
        #10;  // 等待结果计算完成  
        $display("Result of 12 / 4 = %h", data_out); // 打印结果  

        // --------------------------------------------------  

        // 测试用例 3: 计算 8 - 2  
        key = 4'b1000;     // 清零/复位  
        #10;  

        key = 4'b0000;     // 设置为输入第一个数字  
        data_in = 8'h08;   // num1 = 8  
        #10;  

        key = 4'b0001;     // 设置为输入第二个数字  
        data_in = 8'h02;   // num2 = 2  
        #10;  

        key = 4'b0011;     // 设置运算为减法  
        #10;  

        key = 4'b0011;     // 执行减法操作  
        #10;  

        // 等待并检查结果  
        #10;  // 等待结果计算完成  
        $display("Result of 8 - 2 = %h", data_out); // 打印结果  

        // 结束仿真  
        $finish;  
    end  

    // 导出波形数据以供ModelSim使用  
    initial begin  
        $dumpfile("waveform.vcd");  // 指定波形输出文件名  
        $dumpvars(0, tb_yqc_jisuanqi);  // 导出当前模块的所有变量  
    end  

endmodule
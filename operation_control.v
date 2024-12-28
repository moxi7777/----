module operation_control(
    input clk,
    input rst,
    input [3:0] key,
    input [7:0] data_in,
    output reg [15:0] result,
    output reg overflow,
    output reg div_error
);

    reg [15:0] num1;
    reg [15:0] num2;
    reg [2:0] operation;  // 用3位编码表示4种运算：000 - 加法，001 - 减法，010 - 乘法，011 - 除法

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            num1 <= 0;
            num2 <= 0;
            result <= 0;
            overflow <= 0;
            div_error <= 0;
            operation <= 0;
        end
        else begin
            // 根据不同的按键输入执行相应操作
            case (key)
                4'b0000: begin  // 按下对应按键，输入第一个操作数
                    num1 <= data_in;
                end
                4'b0001: begin  // 按下对应按键，输入第二个操作数
                    num2 <= data_in;
                end
                4'b0010: begin  // 按下对应按键，设置加法运算
                    operation <= 3'b000;
                end
                4'b0011: begin  // 按下对应按键，设置减法运算
                    operation <= 3'b001;
                end
                4'b0100: begin  // 按下对应按键，设置乘法运算
                    operation <= 3'b010;
                end
                4'b0101: begin  // 按下对应按键，设置除法运算
                    operation <= 3'b011;
                end
                4'b1000: begin  // 按下对应按键，清零功能，重置所有相关变量
                    num1 <= 0;
                    num2 <= 0;
                    result <= 0;
                    overflow <= 0;
                    div_error <= 0;
                    operation <= 0;
                end
                default: ;
            endcase

            // 根据设置的运算类型进行相应计算，并处理溢出和除法错误情况
            case (operation)
                3'b000: begin  // 加法
                    result <= num1 + num2;
                    overflow <= (num1[15] == num2[15]) && (result[15]!= num1[15]);  // 简单溢出判断，同号相加进位则溢出
                end
                3'b001: begin  // 减法
                    result <= num1 - num2;
                    overflow <= (num1[15]!= num2[15]) && (result[15]!= num1[15]);  // 简单溢出判断，异号相减借位则溢出
                end
                3'b010: begin  // 乘法
                    result <= num1 * num2;
                    overflow <= (result > 16'hFFFF);  // 简单乘法溢出判断，结果超出16位表示范围则溢出
                end
                3'b011: begin  // 除法
                    if (num2 == 0) begin
                        div_error <= 1;
                        result <= 0;
                    end
                    else begin
                        result <= num1 / num2;
                        div_error <= 0;
                    end
                end
            endcase
        end
    end

endmodule
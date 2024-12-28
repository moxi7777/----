module display_control(
    input clk,
    input rst,
    input [15:0] data_in,
    input overflow,
    output reg [7:0] data_out,
    output reg [3:0] seg,
    output reg [3:0] dig
);

    reg [3:0] display_digit;
    reg [1:0] scan_count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_out <= 0;
            seg <= 0;
            dig <= 0;
            display_digit <= 0;
            scan_count <= 0;
        end
        else begin
            // 数码管扫描逻辑，以4位数码管为例，依次选择要显示的位
            case (scan_count)
                2'b00: begin
                    display_digit <= data_in[3:0];
                    dig <= 4'b0111;
                end
                2'b01: begin
                    display_digit <= data_in[7:4];
                    dig <= 4'b1011;
                end
                2'b10: begin
                    display_digit <= data_in[11:8];
                    dig <= 4'b1101;
                end
                2'b11: begin
                    display_digit <= data_in[15:12];
                    dig <= 4'b1110;
                end
            endcase

            // 根据当前要显示的数字生成七段数码管段选信号
            case (display_digit)
                4'b0000: seg <= 7'b0000001;
                4'b0001: seg <= 7'b1001111;
                4'b0010: seg <= 7'b0010010;
                4'b0011: seg <= 7'b0000110;
                4'b0100: seg <= 7'b1001100;
                4'b0101: seg <= 7'b0100100;
                4'b0110: seg <= 7'b0100000;
                4'b0111: seg <= 7'b0001111;
                4'b1000: seg <= 7'b0000000;
                4'b1001: seg <= 7'b0000100;
                default: seg <= 7'b1111111;
            endcase

            scan_count <= scan_count + 1;
            if (scan_count == 4)
                scan_count <= 0;

            // 如果有溢出情况，显示特定的提示信息（这里简单设置为全F）
            if (overflow)
                data_out <= 8'hFF;
            else
                data_out <= data_in[7:0];
        end
    end

endmodule
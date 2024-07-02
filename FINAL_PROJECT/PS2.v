`timescale 1ns / 1ps

module PS2(
    input clk,
    input rst,
    input ps2_clk,     // ����ʱ������
    input ps2_data,    // ������������
    output [9:0] data_out,  // ����ɨ�������
    output ready
);

    reg ps2_clk_flag0, ps2_clk_flag1, ps2_clk_flag2;
    wire negedge_ps2_clk;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // ��Ӧ��������
            ps2_clk_flag0 <= 1'b0;
            ps2_clk_flag1 <= 1'b0;
            ps2_clk_flag2 <= 1'b0;
        end
        else begin
            ps2_clk_flag0 <= ps2_clk;
            ps2_clk_flag1 <= ps2_clk_flag0;
            ps2_clk_flag2 <= ps2_clk_flag1;
        end
    end

    assign negedge_ps2_clk = !ps2_clk_flag1 & ps2_clk_flag2;

    reg [3:0] num;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            num <= 4'd0;
        end
        else if (num == 4'd11) begin
            num <= 4'd0;
        end
        else if (negedge_ps2_clk) begin
            num <= num + 1'b1;
        end
    end

    reg negedge_ps2_clk_shift;

    always @(posedge clk) begin
        negedge_ps2_clk_shift <= negedge_ps2_clk;
    end

    reg [7:0] temp_data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            temp_data <= 8'd0;
        end
        else if (negedge_ps2_clk_shift) begin
            // ����ʱ�������͵�ƽ��������
            case (num) // �洢�˸�����λ
                4'd2 : temp_data[0] <= ps2_data;
                4'd3 : temp_data[1] <= ps2_data;
                4'd4 : temp_data[2] <= ps2_data;
                4'd5 : temp_data[3] <= ps2_data;
                4'd6 : temp_data[4] <= ps2_data;
                4'd7 : temp_data[5] <= ps2_data;
                4'd8 : temp_data[6] <= ps2_data;
                4'd9 : temp_data[7] <= ps2_data;
                default : temp_data <= temp_data;
            endcase
        end
        else begin
            temp_data <= temp_data;
        end
    end

    reg data_break, data_done, data_expand;
    reg [9:0] data;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            data_break <= 1'b0;
            data <= 10'd0;
            data_done <= 1'b0;
            data_expand <= 1'b0;
        end
        else if (num == 4'd11) begin
            if (temp_data == 8'hE0)
                data_expand <= 1'b1;  // �������ż�
            else if (temp_data == 8'hF0)
                data_break <= 1'b1;
            else begin
                data <= {data_expand, data_break, temp_data};
                data_done <= 1'b1;  // ����������׼�������
                data_expand <= 1'b0;
                data_break <= 1'b0;
            end
        end
        else begin
            data <= data;
            data_done <= 1'b0;
            data_expand <= data_expand;
            data_break <= data_break;
        end
    end

    assign data_out = data;
    assign ready = data_done;  // �����������

endmodule

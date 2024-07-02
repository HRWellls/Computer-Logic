module vgac (
    input vga_clk, clrn,
    input [11:0] d_in,
    output reg [8:0] row_addr,
    output reg [9:0] col_addr,
    output reg [3:0] r, g, b,
    output reg rdn,
    output reg hs, vs
);

// VGA controller
reg [9:0] h_count; // VGA horizontal counter (0-799): pixels
reg [9:0] v_count; // VGA vertical counter (0-524): lines

always @ (posedge vga_clk) begin
    if (!clrn) begin
        h_count <= 10'h0;
    end else if (h_count == 10'd799) begin
        h_count <= 10'h0;
    end else begin 
        h_count <= h_count + 10'h1;
    end
end

always @ (posedge vga_clk or negedge clrn) begin
    if (!clrn) begin
        v_count <= 10'h0;
    end else if (h_count == 10'd799) begin
        if (v_count == 10'd524) begin
            v_count <= 10'h0;
        end else begin
            v_count <= v_count + 10'h1;
        end
    end
end

// Signals, will be latched for outputs
wire [9:0] row = v_count - 10'd35; // Pixel RAM row address
wire [9:0] col = h_count - 10'd143; // Pixel RAM col address
wire h_sync = (h_count > 10'd95); // 96 -> 799
wire v_sync = (v_count > 10'd1); // 2 -> 524
wire read = (h_count > 10'd142) && (h_count < 10'd783) && (v_count > 10'd34) && (v_count < 10'd515);

// VGA signals
always @ (posedge vga_clk) begin
    row_addr <= row[8:0]; // Pixel RAM row address
    col_addr <= col; // Pixel RAM col address
    rdn <= ~read; // Read pixel (active low)
    hs <= h_sync; // Horizontal synchronization
    vs <= v_sync; // Vertical synchronization
    r <= rdn ? 4'h0 : d_in[3:0]; // 3-bit red
	 g <= rdn ? 4'h0 : d_in[7:4]; // 3-bit green
    b <= rdn ? 4'h0 : d_in[11:8]; // 3-bit blue

end

endmodule

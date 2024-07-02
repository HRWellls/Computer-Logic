`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   19:12:51 12/29/2023
// Design Name:   top
// Module Name:   D:/FINAL_PROJECT/simulate.v
// Project Name:  FINAL_PROJECT
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////
module simulate;

// Inputs
reg clk;
reg rstn;
reg ps2_clk;
reg ps2_data;

// Outputs
wire hs;
wire vs;
wire [3:0] r;
wire [3:0] g;
wire [3:0] b;
wire SEGLED_CLK;
wire SEGLED_CLR;
wire SEGLED_DO;
wire SEGLED_PEN;

// Instantiate the Unit Under Test (UUT)
top uut (
    .clk(clk),
    .rstn(rstn),
    .ps2_clk(ps2_clk),
    .ps2_data(ps2_data),
    .hs(hs),
    .vs(vs),
    .r(r),
    .g(g),
    .b(b),
    .SEGLED_CLK(SEGLED_CLK),
    .SEGLED_CLR(SEGLED_CLR),
    .SEGLED_DO(SEGLED_DO),
    .SEGLED_PEN(SEGLED_PEN)
);

initial begin
    clk = 0;
    rstn = 0;
    ps2_clk = 0;
    ps2_data = 0;
    #100;
    rstn = 1; 
end

always #10 clk = ~clk; 
always @(posedge clk) begin
end

endmodule
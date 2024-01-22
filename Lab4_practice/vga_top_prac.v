module VGA_TOP(
	input clk,
	input rst,
    input [2:0] cmd,
	output vga_hs, 
	output vga_vs, 
	output [3:0] vga_r, 
	output [3:0] vga_g, 
	output [3:0] vga_b,
    output [2:0] led
);

wire clk_25mHz;
wire [9:0] hcount, vcount;

reg [18:0] addr;
wire [7:0] dout;


VGA_CTRL vga_ctrl_0(
	.clk(clk_25mHz), 
	.reset_n(rst),
    .cmd(cmd),
	.hsync(vga_hs), 
	.vsync(vga_vs), 
	.vga_r(vga_r), 
	.vga_g(vga_g), 
	.vga_b(vga_b),
    .led(led)
	);

clk_wiz_0 clk_wiz_0_0(
		.clk_in1(clk),
		.clk_out1(clk_25mHz),
		.reset(1'b0)
	);
endmodule
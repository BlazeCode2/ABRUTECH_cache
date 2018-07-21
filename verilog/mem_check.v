module mem_check(clk,p_address,wen,hex0,hex1,hex2,hex5,hex6,hex7,dv);

input clk,wen;
input [8:0] p_address;
output dv;
output [6:0] hex0;
output [6:0] hex1;
output [6:0] hex2;
output [6:0] hex5;
output [6:0] hex6;
output [6:0] hex7;
reg [31:0] din=32'd123;
wire [31:0] dout;
wire [7:0] cache_to_processor;
wire [6:0] mem_address;

RAM ram(
	.address(mem_address),
	.clock(~clk),
	.data(din),
	.wren(~wen),
	.q(dout));
	
bi2bcd bi1(
	.din(cache_to_processor),
	.dout2(hex2),
	.dout1(hex1),
	.dout0(hex0));
	
bi2bcd bi2(
	.din(dout[15:8]),
	.dout2(hex7),
	.dout1(hex6),
	.dout0(hex5));
	
//cache_controller(
//	.wren(~wen),
//	.clock(clk),
//	.p_address(p_address),
//	.mem_address(mem_address),
//	.din(dout),
//	.dout(cache_to_processor),
//	.DV(dv));
	
endmodule

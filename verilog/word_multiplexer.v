module word_multiplexer(
	data0x,
	data1x,
	data2x,
	data3x,
	sel,
	result);
	
input [7:0] data0x;
input [7:0] data1x;
input [7:0] data2x;
input [7:0] data3x;
input [1:0]  sel;
output reg [7:0] result=8'd0;

parameter d0=3'd0;
parameter d1=3'd1;
parameter d2=3'd2;
parameter d3=3'd3;

initial
	begin
		case(sel)
			d0: result <= data0x;
			d1: result <= data1x;
			d2: result <= data2x;
			d3: result <= data3x;
			default: result<=8'd0;
		endcase
	end



always @(*)
	begin
		case(sel)
			d0: result <= data0x;
			d1: result <= data1x;
			d2: result <= data2x;
			d3: result <= data3x;
			default: result<=8'd0;
		endcase
	end

endmodule

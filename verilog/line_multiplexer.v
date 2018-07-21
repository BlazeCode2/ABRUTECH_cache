module line_multiplexer(
	data0x,
	data1x,
	data2x,
	data3x,
	data4x,
	data5x,
	data6x,
	data7x,
	sel,
	result);
	
input [36:0] data0x;
input [36:0] data1x;
input [36:0] data2x;
input [36:0] data3x;
input [36:0] data4x;
input [36:0] data5x;
input [36:0] data6x;
input [36:0] data7x;
input [2:0]  sel;
output reg [36:0] result=37'd0;


parameter d0=3'd0;
parameter d1=3'd1;
parameter d2=3'd2;
parameter d3=3'd3;
parameter d4=3'd4;
parameter d5=3'd5;
parameter d6=3'd6;
parameter d7=3'd7;

initial
	begin
		case(sel)
			d0: result <= data0x;
			d1: result <= data1x;
			d2: result <= data2x;
			d3: result <= data3x;
			d4: result <= data4x;
			d5: result <= data5x;
			d6: result <= data6x;
			d7: result <= data7x;
			default: result<=37'd0;
		endcase
	end


always @(*)
	begin
		case(sel)
			d0: result <= data0x;
			d1: result <= data1x;
			d2: result <= data2x;
			d3: result <= data3x;
			d4: result <= data4x;
			d5: result <= data5x;
			d6: result <= data6x;
			d7: result <= data7x;
			default: result<=37'd0;
		endcase
	end

endmodule

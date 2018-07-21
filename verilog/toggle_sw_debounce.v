module toggle_sw_debounce #(parameter no_of_switches = 9)
	(clock,
	in,
	out);
	
input  clock;
input  [no_of_switches-1:0] in;

output reg [no_of_switches-1:0] out=0;
	
reg [3:0] counter=4'd0;	
reg [no_of_switches-1:0] temp1 = 0;
reg [no_of_switches-1:0] temp2 = 0;

always @(posedge clock)
	begin
		temp1<=in;
		temp2<=temp1;
		if(temp1!=temp2)
			begin
				counter<=4'd0;
			end
		else counter<=counter+1;
		if (counter==4'd15)
			out<=temp2;
	end 
	
endmodule 
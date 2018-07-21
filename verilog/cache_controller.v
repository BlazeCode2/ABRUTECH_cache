module cache_controller(wren,clock,p_address,mem_address,din,dout,is_Hit);

input  [8:0]  p_address;   //address requested by the processor
input  [31:0] din;			//data coming from memory
input         clock,wren;			 

output [7:0] dout;		   //selected data to send to processor
output [6:0] mem_address;  //address to send to memory
output is_Hit;                 //Data valid: for processor to identify the status of requested data

wire [36:0]selected_line;  //line of cache selected according to address requested
wire [2:0] temp;				
reg [1:0] STATE=2'd0;		
reg [3:0]  requested_tag=4'd0;	//in case of miss, requested tag is recorded here


reg [36:0] cache [7:0];   //cache of 8x37 [dv|tag|data3|data2|data1|data0]
								  //              [ 1| 4 |  8  |  8  |  8  |  8  ]
initial     //setting initial values of cache to 0
	begin
		cache[0]=37'd0;
		cache[1]=37'd0;
		cache[2]=37'd0;
		cache[3]=37'd0;
		cache[4]=37'd0;
		cache[5]=37'd0;
		cache[6]=37'd0;
		cache[7]=37'd0;
	end


assign is_Hit = (selected_line[36]&(&(p_address[8:5] ~^ selected_line[35:32])));
assign mem_address=p_address[8:2];
	
		
line_sel_mux (               //to select a cache line (a 40bit IP mux)
	.data0x({3'd0,cache[0]}),
	.data1x({3'd0,cache[1]}),
	.data2x({3'd0,cache[2]}),
	.data3x({3'd0,cache[3]}),
	.data4x({3'd0,cache[4]}),
	.data5x({3'd0,cache[5]}),
	.data6x({3'd0,cache[6]}),
	.data7x({3'd0,cache[7]}),
	.sel(p_address[4:2]),
	.result({temp,selected_line}));
	
word_sel_mux (						//to select a word from selected cache line
	.data0x(selected_line[7:0]),
	.data1x(selected_line[15:8]),
	.data2x(selected_line[23:16]),
	.data3x(selected_line[31:24]),
	.sel(p_address[1:0]),
	.result(dout));
	
always @(posedge clock)
	begin
		if (wren==1)
			begin
				cache[p_address[4:2]][36]<=0; //if the ram is getting written,make the validity of corresponding line 0
			end
		else if (is_Hit!=1)                    //if miss
			begin
				case(STATE)                  //fetch the correct data from ram
					2'd0:
						begin
							requested_tag<=p_address[8:5];
							STATE<=2'd1;
						end
					2'd1:STATE<=2'd2;
					2'd2:
						begin
							cache[p_address[4:2]]<={1'b1,requested_tag,din}; //flushing and updating the cache line
							STATE<=2'd0;
						end
					default:STATE<=2'd0;
				endcase
			end
	end

//line_multiplexer line_multiplexer(
//	.data0x(cache[0][36:0]),
//	.data1x(cache[1][36:0]),
//	.data2x(cache[2][36:0]),
//	.data3x(cache[3][36:0]),
//	.data4x(cache[4][36:0]),
//	.data5x(cache[5][36:0]),
//	.data6x(cache[6][36:0]),
//	.data7x(cache[7][36:0]),
//	.sel(p_address[4:2]),
//	.result(selected_line));
//	
//word_multiplexer word_multiplexer(
//	.data3x(selected_line[31:24]),
//	.data2x(selected_line[23:16]),
//	.data1x(selected_line[15:8]),
//	.data0x(selected_line[7:0]),
//	.sel(p_address[1:0]),
//	.result(dout));
	

	


endmodule

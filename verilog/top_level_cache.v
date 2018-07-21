module top_level_cache(
					clk,         //original 50MHz clock
					clock_sel,	 //clock mode selection button (Key2)
					manual_clk,	 //manual clock button (Key0)
					p_address,	 //address given by the processor (switches[SW17-SW9])
					wen,			 //write enable button (Key3)
					hex0,			 //3 SSDs to display the data (0-255) sent to processor after selection
					hex1,
					hex2,
					hex4,        //clock mode display [0:10MHz | 1:1Hz | 2:manual | 3:25MHz]
					hex7,        //hit miss indicator using SSD
					hit, 			 //validity of the data sent to processor 
					r_p_address);//to display the address requested by processor

input            clk,manual_clk,clock_sel,wen;
input      [8:0] p_address;

output           hit;
output  	  [6:0] hex0;
output 	  [6:0] hex1;
output     [6:0] hex2;
output     [6:0] hex4;
output     [6:0] hex7;
output reg [8:0] r_p_address=9'd0;

reg [31:0] din=32'd117893636;   //Pre load a data line to input of memory din
reg        r_wen=1;				  //initial wren (~wren is given to memory) 
reg [1:0]  clock_sel_reg=2'd0;  

wire        selected_clk;       //clock the modules running on
wire        wen_debounced,manual_clk_debounced,clock_sel_debounced;
wire [31:0] dout;               //output of memory
wire [8:0]  p_address_debounced;
wire [7:0]  cache_to_processor; //data sent from cache to processor
wire [6:0]  mem_address;        


//Button Debouncers

debouncer   manual_wen_button( //to debounce write enable button
			.button_in(wen),
			.button_out(wen_debounced),
			.clk(clk));           //give a fast clock
			
debouncer   manual_clk_button( //to debounce manual clock button
			.button_in(manual_clk),
			.button_out(manual_clk_debounced),
			.clk(clk));           //give a fast clock
			
debouncer   clock_sel_button( //to debounce clock selection button
			.button_in(clock_sel),
			.button_out(clock_sel_debounced),
			.clk(clk));           //give a fast clock
			
toggle_sw_debounce #(9) switch_debounce(
			.clock(clk),
			.in(p_address),
			.out(p_address_debounced));
			
			
			
//Ram of 512x8 size
			
RAM ram(    
	.address(mem_address),
	.clock(~selected_clk), //ram responds to negedge of clock
	.data(din),
	.wren(~r_wen),
	.q(dout));
	
	
	
//Seven Segment Displays (to display data sent from cache to processor)
	
bi2bcd bi1(
	.din(cache_to_processor),
	.dout2(hex2),
	.dout1(hex1),
	.dout0(hex0));
	

decoder clock_mode_display(   //display clock mode
	.din({2'd0,clock_sel_reg}),
	.dout(hex4));

decoder hit_miss_indicator(   //indicate hit(1) and miss (0)
	.din({3'd0,hit}),
	.dout(hex7));	
	
	
//Cache Controller	
	
cache_controller cache_ctrl(
	.wren(~r_wen),
	.clock(selected_clk),
	.p_address(r_p_address),
	.mem_address(mem_address),
	.din(dout),
	.dout(cache_to_processor),
	.is_Hit(hit));                   //validity of the data sent to processor
	

	
//Clock controler	
	
clock_control(
					.in_clock(clk), //50MHz
					.sel(clock_sel_reg),
					.mode(2'b10),  //inorder to enable the module
					.manual(manual_clk_debounced),
					.out_clock(selected_clk));  //10MHz,1Hz,Manual,25MHz

					
//To Sync address changes and wen changes with negative edge of the clock

always @(negedge selected_clk)
	begin
		r_p_address<=p_address_debounced;
		r_wen <=wen_debounced;	
	end
	
	
//Update clock mode selection	
	
always @(negedge clock_sel_debounced)
	begin
		clock_sel_reg<=clock_sel_reg+1;
	end
	
endmodule

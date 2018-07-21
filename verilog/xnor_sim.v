module xnor_sim(a,b,c,d);
input [3:0] a,b;
output [3:0]c;
output d;

assign c=a~^b;
assign d=&(a~^b);

endmodule 
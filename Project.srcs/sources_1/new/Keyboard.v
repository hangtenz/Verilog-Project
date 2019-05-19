`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: UPB
// Engineer: Sorina Lupu
// 
// Create Date:    13:45:29 04/19/2014 
// Design Name: 
// Module Name:    keyboard 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: Keyboard for PONG and Bricks
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: Enjoy:)
//
//////////////////////////////////////////////////////////////////////////////////
`define q 8'h15
`define a 8'h1C
`define s 8'h1B
`define d 8'h23

`define i 8'h43
`define j 8'h38
`define k 8'h42
`define l 8'h4B

module keyboard(
	 input clock,
    input ps2_clock,
	 input ps2_data,
    output reg done,
    output reg [7:0] tasta
);
//One player
// Q = 15 = 8'h15
// A = 1C = 8'h1C
// S = 1B = 8'h1B
// D = 23 = 8'h23
// Second Player
// I = 43 = 8'h43
// J = 38 = 8'h3B
// K = 42 = 8'h42
// L = 4B = 8'h4B


reg [3:0] count; // 11 biti
reg skip;

reg clock_new;

initial begin 
	count <= 4'h1; 
	done <= 1'b0; 
	tasta <= 8'hf0;
	skip <= 0;
end 

always @(posedge clock) begin
	if(ps2_clock == 1) begin
		clock_new <= 1;
	end else begin
		clock_new <= 0;
	end
end
 
always @(negedge clock_new) //Activating at negative edge of clock from keyboard 
begin 
 
	case(count) 
		1: done <= 0; //first bit 
		2: tasta[0]<=ps2_data; 
		3: tasta[1]<=ps2_data; 
		4: tasta[2]<=ps2_data; 
		5: tasta[3]<=ps2_data; 
		6: tasta[4]<=ps2_data; 
		7: tasta[5]<=ps2_data; 
		8: tasta[6]<=ps2_data; 
		9: tasta[7]<=ps2_data; 
		10: ; //Parity bit 
		11: begin  //Ending bit
				
				// key up
				if(tasta == 8'hF0)
					skip <= 1;
				else if (!skip)
					done <= 1; 
				else
					skip <= 0;				
			 end  
	endcase 
	
	if(count <= 10) 
		count <= count+1;  
	else if(count==11) 
		count <= 1;  
end

endmodule

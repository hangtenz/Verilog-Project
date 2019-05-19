`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2019 17:08:50
// Design Name: 
// Module Name: hexTosegment
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module hexTosegment(
    input  [3:0]x,
    output reg [7:0]z
    );
always @*
case (x)
4'b0000 :      	//Hexadecimal 0
z = 8'b11111100;
4'b0001 :    		//Hexadecimal 1
z = 8'b01100000  ;
4'b0010 :  		// Hexadecimal 2
z = 8'b11011010 ; 
4'b0011 : 		// Hexadecimal 3
z = 8'b11110010 ;
4'b0100 :		// Hexadecimal 4
z = 8'b01100110 ;
4'b0101 :		// Hexadecimal 5
z = 8'b10110110 ;  
4'b0110 :		// Hexadecimal 6
z = 8'b10111110 ;
4'b0111 :		// Hexadecimal 7
z = 8'b11100000;
4'b1000 :     		 //Hexadecimal 8
z = 8'b11111110;
4'b1001 :    		//Hexadecimal 9
z = 8'b11110110 ;
4'b1010 :  		// Hexadecimal A
z = 8'b11101110 ; 
4'b1011 : 		// Hexadecimal B
z = 8'b00111110;
4'b1100 :		// Hexadecimal C
z = 8'b10011100 ;
4'b1101 :		// Hexadecimal D
z = 8'b01111010 ;
4'b1110 :		// Hexadecimal E
z = 8'b10011110 ;
4'b1111 :		// Hexadecimal F
z = 8'b10001110 ;
endcase
 
endmodule
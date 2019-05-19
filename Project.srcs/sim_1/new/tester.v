`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.05.2019 12:56:19
// Design Name: 
// Module Name: tester
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


module tester(
    );
    reg clk,reset,ps2_clk,ps2_data;
    wire [3:0] digital_selection;
    wire [7:0] segment_selection;
    wire hsync,vsync,video_on,p_tick;
    wire [11:0] color;
    wire [9:0] x,y;
    initial
        begin
            #0;
                clk=0;
                ps2_clk=0;
                ps2_data=0;
            #10;
                reset=1;
            #20;
                reset=0;
        end
   always
        begin
            #10 clk=~clk;
            #10 ps2_clk=~ps2_clk;
        end
        
   main main(clk,ps2_data,ps2_clk,reset,hsync,vsync,color,digital_selection,segment_selection);
endmodule

module Scor(
  input [3:0] scor1,
  input [3:0] scor2,
  input clock,
  input enable,
  output  [7:0] out,
  output  [3:0] dec
  );
  
  wire [7:0] fir1;
  wire [7:0] fir2;
  wire fir3;
  
  Afisaj Afisaj1(
  .in(scor1),
  .out(fir1)
  );
  
  Afisaj Afisaj2(
  .in(scor2),
  .out(fir2)
  );

  Mux Muxs(
  .select(fir3),
  .in0(fir1),
  .in1(fir2),
  .outm(out)
  );
  
  Selector Selectors(
  .clock(clock),
  .e1(fir3),
  .e2(dec),
  .enable(enable)
  );
  
endmodule

// Display 7 segments 
module Afisaj(
    output reg[7:0] out,
    input  [3:0] in
);
always@(in) begin
  case(in)
    0: out = 8'b00000010;
    1: out = 8'b10011110;
    2: out = 8'b00100100;
    3: out = 8'b00001100;
    4: out = 8'b10011000;
    5: out = 8'b01001000;
    6: out = 8'b01000000;
    7: out = 8'b00011110;
    8: out = 8'b00000000;
    9: out = 8'b00001000;
    10: out = 8'b00010000;
    11: out = 8'b11000000;
    12: out = 8'b01100010;
    13: out = 8'b10000100;
    14: out = 8'b01100000;
    15: out = 8'b01110000;
    default: out = 8'b00001010;
  endcase
  end
  endmodule

// MUX
module Mux(
  input wire select,
  input wire [7:0] in0,
  input wire [7:0] in1,
  output reg [7:0] outm
  );
  always@(select) begin
    if(select) begin
      outm=in1;
    end else begin
      outm=in0;
    end
  end
endmodule
    

// Selector
module Selector(
  input clock,
  output e1,
  output reg [3:0] e2,
  input enable
);

reg [20:0] count;

assign e1=count[18];

always@(posedge clock) begin
  e2 <= 4'b1111;
  if(enable) begin 
    count <= count + 1;
    if(e1) begin
      e2 <= 4'b0111;
    end else begin
      e2 <= 4'b1101;
    end
  end
end
endmodule
      

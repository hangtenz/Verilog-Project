module Afisaj(
    output reg[7:0] out,
    input  [3:0] in
);
always@(in) begin
  case(in)
    0: out = 8'b11000000;
    1: out = 8'b11111001;
    2: out = 8'b10100100;
    3: out = 8'b10110000;
    4: out = 8'b10011001;
    5: out = 8'b10010010;
    6: out = 8'b10000010;
    7: out = 8'b11111000;
    8: out = 8'b10000000;
    9: out = 8'b10010000;
    default: out = 8'b00001010;
  endcase
  end
  endmodule

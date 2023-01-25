`timescale 1ns / 1ps

module LED(
    input clk,
    input [3:0] switcher,
    output reg [7:0] SEG
);

always@ (clk) begin
    case(switcher)
        4'h0: SEG <= 8'b11000000;
        4'h1: SEG <= 8'b11111001;
        4'h2: SEG <= 8'b10100100;
        4'h3: SEG <= 8'b10110000;
        4'h4: SEG <= 8'b10011001;
        4'h5: SEG <= 8'b10010010;
        4'h6: SEG <= 8'b10000010;
        4'h7: SEG <= 8'b11111000;
        4'h8: SEG <= 8'b10000000;
        4'h9: SEG <= 8'b10010000;
        4'ha: SEG <= 8'b10001000;
        4'hb: SEG <= 8'b10000011;
        4'hc: SEG <= 8'b11000110;
        4'hd: SEG <= 8'b10100001;
        4'he: SEG <= 8'b10000110;
        4'hf: SEG <= 8'b10001110;
        default: SEG <= 8'b11111111;
    endcase
end

endmodule

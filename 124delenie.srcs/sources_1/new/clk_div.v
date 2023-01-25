`timescale 1ns / 1ps

module clk_div(
    input clk,
    output new_clk
);

reg [15:0] cnt = 0;

assign new_clk = cnt[15];

always@ (posedge clk) begin
    cnt <= cnt + 1'b1;
end

endmodule

`timescale 1ns / 1ps

 module vga(
  input clk,
  input [3:0] switch,
  input [3:0] i, j,
  input [15:0] path,
  input [3:0] state,
  output hsync, vsync,
  output [2:0] rgb
);

wire display_on;
wire [10:0] hpos, vpos;

reg clkNew;
reg main_gfx;	
  
initial clkNew=0;
  
always@(posedge clk) 
begin
    clkNew=~clkNew;
    case (vpos[9:2])
        0, 1, 2, 3: main_gfx <= score_gfx;
        default: main_gfx <=0;
    endcase
end

hvsync_generator hvsync_gen(
    .clk(clkNew),
    .hsync(hsync),
    .vsync(vsync),
    .display_on(display_on),
    .hpos(hpos),
    .vpos(vpos)
);

wire score_gfx;
wire [2:0] colors;  

scoreboard_generator score_gen(
    .clk(clkNew),
    .switch(switch),
    .i(i),
    .j(j),
    .state(state),
    .path(path),
    .vpos(vpos),
    .hpos(hpos),
    .board_gfx(score_gfx),
    .colors(colors)
);

wire r = display_on && (main_gfx) && colors[2];
wire g = display_on && (main_gfx) && colors[1];
wire b = display_on && (main_gfx) && colors[0];

assign rgb = {r,g,b};

endmodule

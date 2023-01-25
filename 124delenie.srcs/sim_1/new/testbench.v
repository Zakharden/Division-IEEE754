`timescale 1ns / 1ps

module testbench();

reg clk, R_I, reset;
reg [3:0] num1, num2;

wire [1:0] state;
wire [3:0] i, j; 
wire [7:0] path;

initial begin
    clk = 0;
    reset = 0;
    R_I = 0;
    num1 = 4'b0000;
    num2 = 4'b0000;
    #10;
    
    R_I = 1;
    num2 = 4'b0011;//количество вершин
    #10;
    
    R_I = 0;
    num2 = 4'b1111;//расстояние 0-1
    #10;
    
    R_I = 1;//нажатие кнопки
    #10;
    
    R_I = 0;
    num2 = 4'b0000;//расстояние 0-2
    #10;
    
    R_I = 1;
    #10;
    
    R_I = 0;
    num2 = 4'b1111;//расстояние 1-2
    #10;
    
    R_I = 1;
    #10;
    
    R_I = 0;
    num1 = 4'b0010;//откуда - 2
    num2 = 4'b0000;//откуда - 0
    #10;
    
    R_I = 1;
    #10;
    
    R_I = 0;
    #300;
    
    /*R_I = 1;
    #20;*/
    $finish;
end

always #5 clk <= ~clk;

fsm fsm(
    .clk(clk),
    .ready(R_I),
    .reset(reset),
    .state(state),
    .number1(num1),
    .number2(num2),
    .i_out(i),
    .j_out(j),
    .path_out(path)
);

endmodule

`timescale 1ns / 1ps

module top(
    input clk_old,
    /*input set_button, //кнопка перехода в некст состояние
    input reset_button,
    input [7:0] switch, //свичеры*/ //для 1-ой лабы
    input PS2_CLK, PS2_DATA,
    output hsync, vsync,
    output [2:0] rgb
    //output reg [7:0] an, seg // для 1-2 лабы
);

reg [7:0] mask;
reg [31:0] register;
wire [7:0] catod;
wire clk;

wire [3:0] state; //Состояние автомата

initial begin
    mask = 8'b00000001;
    register = 32'b11111111111111111111111111111111;
    //an = ~1'b1;
    //seg = ~8'b0;
end

wire [2:0] counter_state;
wire set_signal;
wire set_signal_enable;
wire reset_signal;
wire reset_signal_enable;
wire [3:0] i, j;
wire [15:0] path;
wire R_O;

clk_div div(
    .clk(clk_old), 
    .new_clk(clk)
);
   
counter #(1, 8) ctr(
    .clk(clk),
    .reset(0),
    .qout(counter_state)
);
    
/*LED led(
    .clk(clk),
    .switcher(register[((counter_state+1)*4-1)-:4]),
    .SEG(catod)
); //перевод из чиселок в 0 и 1 в для катода, обновляется постоянное*/ //1-2 лаба

bounce set(
    .clk(clk),
    //.in_s(set_button),
    .in_s(set_buttonR),
    .clock_en(0'b1),
    .out_signal(set_signal),
    .out_signal_en(set_signal_enable)
);

bounce reset(
    .clk(clk),
    //.in_s(reset_button),
    .in_s(reset_buttonR),
    .clock_en(0'b1),
    .out_signal(reset_signal),
    .out_signal_en(reset_signal_enable)
);
    
/*fsm fsm(
    .clk(clk),
    .ready(set_signal_enable),
    .reset(reset_signal_enable),
    .state(state),
    //.number1(switch[7:4]),
    .number2(switch[3:0]),
    .i_out(i),
    .j_out(j),
    .path_out(path)
);*/

fsm1 fsm(
    .dataIn(switch[3:0]),
    .R_I(set_signal_enable),
    .reset(reset_signal_enable),
    .clk(clk),
    .quotient_ieee754(path),
    .state(state),
    .R_O(R_O), 
    .i_out(i)
);

/*2-я лаба*/
wire [3:0] switch;
wire set_button, reset_button;
reg set_buttonR, reset_buttonR;

keyboard keyboard(
    .PS2_CLK(PS2_CLK),
    .PS2_DATA(PS2_DATA),
    .CLK(clk),
    .out_data(switch[3:0]),
    .reset(reset_button),
    .nextState(set_button)
/*,.code1(code1)*/);

reg [3:0] temp;

/*4 лаба */
reg [3:0] iR, jR;
reg [7:0] pathR;

vga vga(
    .clk(clk_old),
    .hsync(hsync),
    .switch(switch),
    .i(i),
    .j(jR),
    .state(state),
    .path(path),
    .vsync(vsync),
    .rgb(rgb)
);

always@ (posedge clk) begin
    set_buttonR = set_button;
    reset_buttonR = reset_button;
    iR = i;
    jR = j;
    pathR = path;
end
    
/*always@ (posedge clk) begin
    set_buttonR = set_button;
    reset_buttonR = reset_button;

    an <= ~((1'd1 << counter_state) & mask);
    seg <= catod;
    
    if (state == 2'd0) begin
        mask <= 8'b00000001;
        register <= {28'b1, switch[3:0]};
    end
    
    if (state == 2'd1) begin
        mask <= 8'b10100001;
        register <= {i, 4'b1, j, 16'b1, switch[3:0]};
    end
    
    if (state == 2'd2) begin
        mask <= 8'b00000101;
        //register <= {20'b1, switch[7:4], 4'b1, switch[3:0]};
        if (i % 2 == 0) begin
            register <= {20'b1, switch[3:0], 8'b0};
            temp = switch[3:0];
        end
        else begin
            register <= {20'b1, temp, 4'b1, switch[3:0]};
        end
    end
    
    if (state == 2'd3) begin
        mask <= 8'b00000011;
        register <= {24'b1, path[7:0]};        
    end
end*/ //для индикаторов 1-2 лаба

endmodule

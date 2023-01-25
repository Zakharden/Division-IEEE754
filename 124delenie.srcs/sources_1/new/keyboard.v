`timescale 1ns / 1ps

module keyboard(
    input PS2_CLK, PS2_DATA, CLK,
    output reg[3:0] out_data,
    output reg nextState,
    output reg reset
);
 
parameter p_0=7'h45;
parameter p_1=7'h16;
parameter p_2=7'h1E;
parameter p_3=7'h26;
parameter p_4=7'h25;
parameter p_5=7'h2E;
parameter p_6=7'h36;
parameter p_7=7'h3d;
parameter p_8=7'h3E;
parameter p_9=7'h46;
parameter p_a=7'h1C;
parameter p_b=7'h32;
parameter p_c=7'h21;
parameter p_d=7'h23;
parameter p_e=7'h24;
parameter p_f=7'h2B;
    
parameter p_next=7'h1B; // S
parameter p_reset=7'h2D; // R
    
reg [7:0] code;
reg [1:0] curState;
reg [4:0] bitCount;
wire ps2Clk, ps2Data;

initial begin
    code=7'd8;
    out_data=0;
    curState=0;
    nextState=0;
    reset=0;
    bitCount=0;
end
    
wire ps2clk_signal, ps2Data_enable;
sync syncClk(.clk(CLK), .in(PS2_CLK), .out(ps2Clk));
sync syncData(.clk(CLK), .in(PS2_DATA), .out(ps2Data));    

always @(posedge ps2Clk) 
begin
  // code1=code;
    case(curState)
        2'd0: 
            begin
                reset=0;
                nextState=0;
                if(ps2Data==1)
                    curState=0;
                else
                begin
                    curState=1;
                    code=0;
                end
            end
        2'd1:
        begin
            bitCount=bitCount+1;
            code={ps2Data,code[7:1]};
            if(bitCount==4'd8)
                begin
                    curState=2'd2;
                    bitCount=0;
                end
        end
        2'd2:
            curState=2'd3;
        2'd3:
        begin
            curState=0;
            if(ps2Data==1)
            begin
                if(code==p_0)
                    out_data=4'd0;
                if(code==p_1)
                    out_data=4'd1;
                if(code==p_2)
                    out_data=4'd2;
                if(code==p_3)
                    out_data=4'd3;
                if(code==p_4)
                    out_data=4'd4;
                if(code==p_5)
                    out_data=4'd5;
                if(code==p_6)
                    out_data=4'd6;
                if(code==p_7)
                    out_data=4'd7;
                if(code==p_8)
                    out_data=4'd8;
                if(code==p_9)
                    out_data=4'd9;
                if(code==p_a)
                    out_data=4'ha;
                if(code==p_b)
                    out_data=4'hb;
                if(code==p_c)
                    out_data=4'hc;
                if(code==p_d)
                    out_data=4'hd;
                if(code==p_e)
                    out_data=4'he;
                if(code==p_f)
                    out_data=4'hf;
        
                if(code==p_next)
                    nextState=1;
                
                if(code==p_reset)
                    reset=1;        
               
            end
        end
    endcase
end
  
endmodule

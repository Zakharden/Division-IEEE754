`timescale 1ns / 1ps
module fsm1(
    input [3:0] dataIn,
    input R_I,
    input reset,
    input clk,
    output reg [15:0] quotient_ieee754,
    output reg R_O,
    output reg error,                                          
    output [15:0] ostatok,
    output reg [3:0] state,
    output [3:0] i_out
);

reg [15:0] REG_A;
reg [15:0] REG_B;
reg reset_div;
wire [15:0] REG_RES;

reg [3:0] i;

initial
begin
        R_O <= 0;    
        REG_A <= 0;
        REG_B <= 0;
        reset_div <= 0;
        state <= 0;
        i = 0; 
end
//always @(posedge R_I, posedge reset) 

//-----------//
//module divider state:2,3,4
reg [10:0] divident_divider, divider_divider;                        // ???????, ????????    
reg [21:0] quotient_divider;                     // ???????  
reg error_divider=0;                                       // ?????? ??? ??????? ?? 0                                // ?????? ???????  
reg [33:0] divident_copy1 = {(34){1'b0}};                // ??? ????? ???????? ???????????? ?? 31 ????
reg [33:0] divider_copy1 = {(34){1'b0}};                 // ??? ????? ???????? ???????????? ?? 31 ????
reg start_divider=0;                                                  // ??? ???? ??? ?????? ??????????
reg [7:0] shift_divider;
//------------------
//module divider_ieee754(
reg [21:0] quotient_copy_ieee;                                            // ??? ???? ??? ?????? ??????????
reg [15:0] divident_ieee754, divider_ieee754;                          // ???????, ???????? ? ??????? IEEE754 
reg warning_NaN;                                         // ?????? ??? ??????? ?? 0
reg error_divider_ziro;
reg warning_infinity;                                                // ?????? ???????  
reg [15:0] ostatok;  
reg start;       //???????? ???? ?? ?????                                           // ??? ???? ??? ?????? ??????????
reg [21:0] vspomogatelnaya_peremennaya;
reg [7:0] shift_ieee;                                            // ??????? ?????? ????? ? ????? ????????
reg [5:0] exponenta;

assign i_out = i;
//------------------
always@(posedge clk)
begin
    if(reset)
        begin
            state<=0;
            error<=0;
        end
    case (state)
        0:
            begin
                if(R_I)
                    begin
                    if (i == 0) begin
                        REG_A[15:12]<=dataIn;
                        i <= i+1;
                        end
                        else if (i == 1) begin
                        REG_A[11:8]<=dataIn;
                        i <= i+1;
                        end
                        else if (i == 2) begin
                        REG_A[7:4]<=dataIn;
                        i <= i+1;
                        end
                        else if (i == 3) begin
                        REG_A[3:0]<=dataIn;
                        i <= 0;
                        state<=1;
                        end
                        
                    end
            end
        1:
            begin
                if(R_I)
                    begin
                    if (i == 0) begin
                        REG_B[15:12]<=dataIn;
                        i <= i+1;
                        end
                        else if (i == 1) begin
                        REG_B[11:8]<=dataIn;
                        i <= i+1;
                        end
                        else if (i == 2) begin
                        REG_B[7:4]<=dataIn;
                        i <= i+1;
                        end
                        else if (i == 3) begin
                        REG_B[3:0]<=dataIn;
                        i <= 0;
                        state<=2;
                        end
                        
                    end
            end
        2:
            begin
                if((REG_A==15'h7c00||REG_A==15'hfc00)&&(REG_B==15'h7c00||REG_B==15'hfc00))
                    begin
                        error<=1;
                        state<=15;
                    end
                else if((REG_B==1'b0)|(REG_B==16'h8000))
                    begin
                        error<=1;
                        state<=15;
                    end
                else if((REG_A==15'h7c00)||(REG_A==16'hfc00)||(REG_B==15'h7c00)||(REG_B==16'hfc00))
                    begin
                        error<=1;
                        state<=15;
                    end
                else
                    state<=3;         
            end
        3:
            begin
                //??? IEEE
                divident_ieee754<=REG_A;
                divider_ieee754<=REG_B;
                //??? Divider'?
                divident_divider <= REG_A[10:0];
                divident_divider[10] <= 1;
                divider_divider <= REG_B[10:0];
                divider_divider[10] <= 1;
                state<=4;
            end
        4:
            begin
                divident_copy1 = {(34){1'b0}};
                divider_copy1 <= {(34){1'b0}};
                quotient_divider <= {22{1'b0}};                                // ??????? = 32'b00000000000000000000000000000000     
                divident_copy1 <= divident_divider << 22;                      // ? ????? ???????? ???????? ????????, ????????? ?? 20 ??? ?????    
                divider_copy1 <= divider_divider;                               // ? ????? ???????? ???????? ???????     
                shift_divider <= 0;                                             // ??????? ?????? ????? ? ????????
                error_divider <= 0;                                             // ?????? ?????? 0     
                start_divider <= 1;
                state<=5;  
            end    
        5:
            begin
                if(divider_divider == 0)
                    state<=6;                                        // ???? ???????? ????? ????, ?? ?? ?????? error ????????? ?????? ?????? (1)
                if(start_divider)
                    begin
                        divider_copy1 <= divider_copy1 << 1;                   // ????? ????? ?? ??????? ? ????????
                        shift_divider <= shift_divider+1;
                        state<=6;
                    end 
                else
                    begin
                        state<=8;
                    end
                           
            end
        6:  
            begin
                if(divider_copy1 > divident_copy1)                    // ???? ????? ?????? ???????? ???? ?????? ????????, ?? ????????? ???????? ? ???????
                    begin
                        divider_copy1 <= divider_copy1 >> 1;               // ???????? ??????? ? ????? ????????
                        shift_divider <= shift_divider-1;
                        state<=7;                                // ??????? ?????? ????? ? ???????? ????????? ?? 1  
                    end
                else
                    begin
                        state<=5;
                    end    
            end 
        7:
            begin               
                divident_copy1 <= divident_copy1 - divider_copy1;   // ????????? ????????
                quotient_divider [shift_divider-11] <= 1'b1;                      // ? ??????????????? ??? ???????? ???????? ???????                        
                if(shift_divider == 0)
                    begin
                        start_divider <= 0;
                        state<=8;                                  // ?????? ???? ?????? ????? ????? ????? ????                          
                    end     // ?????? ???????
                shift_divider <= 0;                                      // ???????? ??????? ?????? ????? ? ????????
                divider_copy1 <= divider_divider;
                state<=5;                        // ? ????? ???????? ???????? ????????      
            end        
        8:
            begin
                error_divider_ziro <= 0;
                warning_NaN <= 0;
                warning_infinity <= 0;    
                exponenta <= 0;
                shift_ieee <= 0;
                vspomogatelnaya_peremennaya <= 1;
                quotient_ieee754[15] <= (divident_ieee754[15])^(divider_ieee754[15]);
                state<=9;
            end    
        9:
            begin
                quotient_copy_ieee <= quotient_divider;
                //reset_div = 0;            
                state <= 10;
            end            
        10:
            begin
                if(!(vspomogatelnaya_peremennaya>quotient_copy_ieee))
                    begin
                        vspomogatelnaya_peremennaya <= vspomogatelnaya_peremennaya << 1;
                        shift_ieee <= shift_ieee+1;
                    end
                else 
                    begin    
                        quotient_copy_ieee <= quotient_copy_ieee << (22 - shift_ieee);
                        state<=11;
                    end
            end 
        11:
            begin
                quotient_copy_ieee <= quotient_copy_ieee + 12'b10000000000;           
                state<=12;
            end
        12:
            begin
                quotient_ieee754[9:0] <= quotient_copy_ieee[20:11];
                exponenta <= (divident_ieee754[14:10] - divider_ieee754[14:10]) + shift_ieee + 3'b11;
                state<=13;
            end 
        13:
            begin
                quotient_ieee754[14:10] <= exponenta;
                R_O<=1;
                state<=14;
            end
        14:
            begin
                if(R_I)
                    begin
                        state<=0;
                    end
            end
        15:
            begin
                if(R_I)
                    begin
                        state<=0;
                        error<=1;
                    end
            end            
    endcase
end     
endmodule

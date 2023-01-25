`timescale 1ns / 1ps

module scoreboard_generator(
    input clk,
    input [10:0] vpos, hpos,
    input [3:0] switch,
    input [3:0] i, j,
    input [15:0] path,
    input [3:0] state,
    output board_gfx,
    output reg [2:0] colors
); 
  
reg [5:0] score_digit;
wire [7:0] score_bits;
  
reg [3:0] temp1, temp2, temp0, temp3;
  
always @(posedge clk) begin
    case (hpos[9:4])
        9:        
            begin
                case (state)
                    /*0: score_digit=21;
                    1: score_digit=i;
                    2: 
                        if (i % 2 == 0) begin
                            score_digit = switch[3:0];
                            temp = switch[3:0];
                        end
                        else begin
                            score_digit=temp;
                        end
                    3: score_digit=21;*/
                    0: 
                        begin
                            if (i == 0)
                            begin
                                score_digit<=switch[3:0];
                                temp3<=switch[3:0];                    
                            end
                            else score_digit <= temp3;
                        end
                    1: 
                        begin
                        if (i == 0)
                            begin
                                score_digit<=switch[3:0];
                                temp3<=switch[3:0];                    
                            end
                            else score_digit <= temp3;
                        end
                endcase
                colors[2]<=0;
                colors[1]<=1;
                colors[0]<=0;
            end
        10:        
            begin
                case (state)
                    /*0: score_digit=21;
                    1: score_digit=i;
                    2: 
                        if (i % 2 == 0) begin
                            score_digit = switch[3:0];
                            temp = switch[3:0];
                        end
                        else begin
                            score_digit=temp;
                        end
                    3: score_digit=21;*/
                    0: 
                        begin
                            if (i == 1)
                            begin
                                score_digit<=switch[3:0];
                                temp2<=switch[3:0];                    
                            end
                            else score_digit <= temp2;
                        end
                    1: 
                        begin
                        if (i == 1)
                            begin
                                score_digit<=switch[3:0];
                                temp2<=switch[3:0];                    
                            end
                            else score_digit <= temp2;
                        end
                endcase
                colors[2]<=0;
                colors[1]<=1;
                colors[0]<=0;
            end    
        11:
            begin
                case (state)
                    /*0: score_digit=21;
                    1: score_digit=i;
                    2: 
                        if (i % 2 == 0) begin
                            score_digit = switch[3:0];
                            temp = switch[3:0];
                        end
                        else begin
                            score_digit=temp;
                        end
                    3: score_digit=21;*/
                    0: 
                        begin
                            if (i == 2)
                            begin
                                score_digit<=switch[3:0];
                                temp1<=switch[3:0];                    
                            end
                            else score_digit <= temp1;
                        end
                    1: 
                        begin
                        if (i == 2)
                            begin
                                score_digit<=switch[3:0];
                                temp1<=switch[3:0];                    
                            end
                            else score_digit <= temp1;
                        end
                endcase
                colors[2]<=0;
                colors[1]<=1;
                colors[0]<=0;
            end     
        12:
            begin
                case (state)
                    /*0: score_digit=21;
                    1: score_digit=i;
                    2: 
                        if (i % 2 == 0) begin
                            score_digit = switch[3:0];
                            temp = switch[3:0];
                        end
                        else begin
                            score_digit=temp;
                        end
                    3: score_digit=21;*/
                    0: 
                        begin
                            if (i == 3)
                            begin
                                score_digit<=switch[3:0];
                                temp0<=switch[3:0];                    
                            end
                            else score_digit <= temp0;
                        end
                    1: 
                        begin
                        if (i == 3)
                            begin
                                score_digit<=switch[3:0];
                                temp0<=switch[3:0];                    
                            end
                            else score_digit <= temp0;
                        end           
                endcase
                colors[2]<=0;
                colors[1]<=1;
                colors[0]<=0;
            end           
        /*13:
            begin
                case (state)
                    0: score_digit=21;
                    1: score_digit=j;
                    2: 
                        if (i % 2 == 0) begin
                            score_digit = 0;
                        end
                        else begin
                            score_digit = switch[3:0];
                        end
                    3: score_digit = 21;
                endcase
                colors[2]<=0;
                colors[1]<=1;
                colors[0]<=0;
            end
        19: //W
            begin
                case (state)
                    0: score_digit=21;
                    1: score_digit=21;
                    2: score_digit=21;
                    3: score_digit=16;
                endcase
                colors[2]<=0;
                colors[1]<=1;
                colors[0]<=1;
            end
        20: //A
            begin
                case (state)
                    0: score_digit=21;
                    1: score_digit=21;
                    2: score_digit=21;
                    3: score_digit=10;
                endcase
                colors[2]<=0;
                colors[1]<=1;
                colors[0]<=1;
            end
        21: //Y
            begin
                case (state)
                    0: score_digit=21;
                    1: score_digit=21;
                    2: score_digit=21;
                    3: score_digit=17;
                endcase
                colors[2]<=0;
                colors[1]<=1;
                colors[0]<=1;
            end    
        22: //:
            begin
                case (state)
                    0: score_digit=21;
                    1: score_digit=21;
                    2: score_digit=21;
                    3: score_digit=18;
                endcase
                colors[2]<=0;
                colors[1]<=1;
                colors[0]<=1;
            end*/
        22:
            begin
                case (state)
                    0,1,2,3,4,5,6,7,8,9,10,11,12,13: score_digit <= 21;
                    14: score_digit <= path[15:12];
                    15: score_digit <=14;
                endcase
                colors[2]<=1;
                colors[1]<=1;
                colors[0]<=0;
            end
        23:
            begin
                case (state)
                    0,1,2,3,4,5,6,7,8,9,10,11,12,13: score_digit <= 21;
                    14: score_digit <= path[11:8];
                    15: score_digit <= 22;
                endcase
                colors[2]<=1;
                colors[1]<=1;
                colors[0]<=0;
            end    
        24:
            begin
                case (state)
                    0,1,2,3,4,5,6,7,8,9,10,11,12,13: score_digit <= 21;
                    14: score_digit <= path[7:4];
                    15: score_digit <= 22;
                endcase
                colors[2]<=1;
                colors[1]<=1;
                colors[0]<=0;
            end
        25:
            begin
                case (state)
                    0,1,2,3,4,5,6,7,8,9,10,11,12,13: score_digit <= 21;
                    14: score_digit <= path[3:0];
                    15: score_digit <=0;
                endcase
                colors[2]<=1;
                colors[1]<=1;
                colors[0]<=0;
            end
        26:
            begin
                case (state)
                    0,1,2,3,4,5,6,7,8,9,10,11,12,13: score_digit <= 21;
                    14: score_digit <= 21;
                    15: score_digit <=22;
                endcase
                colors[2]<=1;
                colors[1]<=1;
                colors[0]<=0;
            end
        default: score_digit <= 21; // no digit
    endcase
end
  
digits10 digits(
    .clk(clk),
    .digit(score_digit),
    .yofs(vpos[/*5:3*/3:1]),
    .bits(score_bits)
);

assign board_gfx = score_bits[hpos[3:1] ^ 3'b111];
  
endmodule

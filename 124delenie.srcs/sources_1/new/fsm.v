`timescale 1ns / 1ps

module fsm(
    input clk, ready, reset,
    output reg [1:0] state,
    //input wire [3:0] number1,
    input wire [3:0] number2,
    output reg [3:0] i_out, j_out,
    output reg [7:0] path_out
);

parameter S0 = 2'd0, S1 = 2'd1, S2 = 2'd2, S3 = 2'd3;

reg [3:0] size, i, j, k;
reg [3:0] _start, _end;
reg [7:0] GR[0:15][0:15];
reg [7:0] path;

initial begin
    size = 0;
    _start = 0;
    _end = 0; 
    i = 0;
    j = 0;
    k = 0;
    path = 0;
    state = S0;   
    i_out = i;
    j_out = j;
    path_out = path;
end

always @(posedge clk) 
begin
    if (reset)
        state = S0;
    else
        case (state)
            S0: if (ready)
                begin
                    for (i = 0; i < size; i = i + 1) begin
                        for (j = 0; j < size; j = j + 1) begin                        
                            GR[i][j] = 0;                   
                        end
                    end
                    size = number2;
                    i = 0;
                    j = 1;
                    path = 0;
                    if (size == 0 || size == 1) state = S0;
                    else state = S1;
                end            
            S1: if (ready)
                begin 
                    GR[i][j] = number2;
                    GR[j][i] = number2;                
                    j = j + 1;            
                    if (i == j) begin
                        GR[i][j] = 0;
                        j = j + 1;
                    end            
                    if (j == size) begin
                        i = i + 1;
                        j = i + 1;
                    end            
                    if (i == size - 1) begin
                        i = 0;
                        state = S2;
                    end
                end            
            S2: if (ready)
                begin                                    
                    if (i % 2 == 0) _start = number2;
                    else _end = number2;
                    i = i + 1;
                
                    if (i == 2) begin
                        //_start = number1;
                        //_end = number2;
                        k = 0;
                        i = 0;
                        j = 0;
                        state = S3;
                    end
                end            
            S3: 
                begin
                    if (GR[i][k] && GR[k][j] && i != j) begin
                        if (GR[i][k] + GR[k][j] < GR[i][j] || GR[i][j] == 0) begin
                            GR[i][j] = GR[i][k] + GR[k][j];
                        end
                    end     
                    if (k != size - 1) begin       
                        j = j + 1;            
                        if (j == size) begin
                            i = i + 1;
                            j = 0;
                        end            
                        if (i == size) begin
                            k = k + 1;
                            i = 0;
                        end
                    end            
                    if (k == size - 1) begin                    
                        path = GR[_start][_end];
                    end            
                    if (ready) state = S0;
                end                        
        endcase        
    i_out = i;
    j_out = j;
    path_out = path;
end

endmodule

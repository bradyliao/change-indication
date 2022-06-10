`include "def.v"
module score_ctl(
    clk, rst, snake_len, state,
    pixel_x, pixel_y, score, digit,
    score_region,score_shape_region, digit_shape_region, decimal_shape_region);
    input clk, rst;
    input [1:0] state;
    input [4:0]snake_len;
    input [9:0] pixel_x;
    input [9:0] pixel_y;
    input [99:0] score [5:0];
    input [99:0] digit [9:0];
    output reg [5:0] score_region;
    output reg [5:0] score_shape_region;
    output reg digit_shape_region, decimal_shape_region;
    
    wire [5:0] score_region;
    wire [5:0] score_shape_region;
    wire digit_shape_region, decimal_shape_region;
    reg  digital, decimal;
    
    assign score_shape_region[0]=score[0][pixel_y[9:1]*10+(pixel_x[9:1]%10)];
    assign score_shape_region[1]=score[1][pixel_y[9:1]*10+(pixel_x[9:1]%10)];
    assign score_shape_region[2]=score[2][pixel_y[9:1]*10+(pixel_x[9:1]%10)];
    assign score_shape_region[3]=score[3][pixel_y[9:1]*10+(pixel_x[9:1]%10)];
    assign score_shape_region[4]=score[4][pixel_y[9:1]*10+(pixel_x[9:1]%10)];
    assign score_shape_region[5]=score[5][pixel_y[9:1]*10+(pixel_x[9:1]%10)];
    
    assign score_region[0]= pixel_x[9:1]<=9  && pixel_x[9:1]>=0  && pixel_y[9:1]>=0 && pixel_y[9:1]<=9;
    assign score_region[1]= pixel_x[9:1]<=19 && pixel_x[9:1]>=10 && pixel_y[9:1]>=0 && pixel_y[9:1]<=9;
    assign score_region[2]= pixel_x[9:1]<=29 && pixel_x[9:1]>=20 && pixel_y[9:1]>=0 && pixel_y[9:1]<=9;
    assign score_region[3]= pixel_x[9:1]<=39 && pixel_x[9:1]>=30 && pixel_y[9:1]>=0 && pixel_y[9:1]<=9;
    assign score_region[4]= pixel_x[9:1]<=49 && pixel_x[9:1]>=40 && pixel_y[9:1]>=0 && pixel_y[9:1]<=9;
    assign score_region[5]= pixel_x[9:1]<=59 && pixel_x[9:1]>=50 && pixel_y[9:1]>=0 && pixel_y[9:1]<=9;
    
    assign digit_shape_region=digit[digital][pixel_y[9:1]*10+(pixel_x[9:1]%10)];
    assign decimal_shape_region=digit[decimal][pixel_y[9:1]*10+(pixel_x[9:1]%10)];
    
    assign decimal_region=pixel_x[9:1]>=60 && pixel_x[9:1]<=69 && pixel_y[9:1]>=0 && pixel_y[9:1]<=9;
    assign digit_region=pixel_x[9:1]>=70 && pixel_x[9:1]<=79 && pixel_y[9:1]>=0 && pixel_y[9:1]<=9;
    
    always @(posedge clk) begin
        if(~rst) begin
            digital <= 0;
            decimal <= 0;
        end
        else if(state==`MAIN_START)begin
            digital <= 0;
            decimal <= 0;
        end
        else if(state==`MAIN_GAME1 || state==`MAIN_GAME2 || state==`MAIN_GAME3 || state==`MAIN_WIN || state==`MAIN_LOSE)begin
            digital <= (snake_len-5)%10;
            decimal <= (snake_len-5)/10;
        end
    end
endmodule

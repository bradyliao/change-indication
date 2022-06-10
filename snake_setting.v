`include "def.v"
module snake_setting(rst_global, accelerate, ate, dir_next,state,snake_clock,finish, death,dir,snake_len,xsnake, ysnake);
    input rst_global, accelerate, ate;
    input [1:0] dir_next;
    input [2:0] state;
    input [31:0] snake_clock;
    output reg finish, death;
    output reg [1:0] dir;
    output reg [4:0] snake_len;
    output reg [19:0] xsnake, ysnake;
    
    reg [5:0] acc_clock;
    wire snakeclk;
    integer i;
    
    assign snakeclk = snake_clock[acc_clock];
    
    always @(posedge snakeclk) begin
        if(rst_global) begin
            snake_len <= 5;
            finish <= 0;
            death <= 0;
            acc_clock <= 24;
            dir <= `RIGHT;
        end
        if(state == `MAIN_START) begin
            dir <= `RIGHT;
            death <= 0;
            snake_len <= 5;
            acc_clock <= 24;
            xsnake[0] <= `INITIAL_X;
            xsnake[1] <= `INITIAL_X - 1;
            xsnake[2] <= `INITIAL_X - 2;
            xsnake[3] <= `INITIAL_X - 3;
            xsnake[4] <= `INITIAL_X - 4;
            ysnake[0] <= `INITIAL_Y;
            ysnake[1] <= `INITIAL_Y;
            ysnake[2] <= `INITIAL_Y;
            ysnake[3] <= `INITIAL_Y;
            ysnake[4] <= `INITIAL_Y;
            finish <= 1;
        end
        else if (state == `MAIN_GAME1 || state == `MAIN_GAME2 || state == `MAIN_GAME3) begin
            dir <= dir_next;
            if(!hit_obstacle) begin
                xsnake[0] <= head_next_x;
                ysnake[0] <= head_next_y;
                for(i = 1; i < snake_len; i = i + 1) begin
                    xsnake[i] <= xsnake[i-1];
                    ysnake[i] <= ysnake[i-1];
                end
                if(ate) begin
                    if(snake_len < 20)
                        snake_len <= snake_len + 1;
                        xsnake[snake_len] <= xsnake[snake_len-1];
                        ysnake[snake_len] <= ysnake[snake_len-1];
                end      
                if(accelerate) acc_clock <= acc_clock - 1;
            end
            else begin
                if(snake_len <= 5) death <= 1;
                else snake_len <= snake_len - 1;
            end
        end
        else if(state == `MAIN_WIN || state == `MAIN_LOSE) finish <= 0;
    end
    
endmodule

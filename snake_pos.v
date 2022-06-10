`include "def.v"
module snake_pos(
    clk, dir_next, state, head_x, head_y,
    head_next_x, head_next_y 
    );
    input clk;
    input [1:0] dir_next;    
    input [2:0] state;
    input [4:0] head_x, head_y;
    output reg [4:0] head_next_x, head_next_y;
    
    always @(posedge clk) begin
        if(state == `MAIN_WAIT) begin
            head_next_x <= `INITIAL_X + 1;
            head_next_y <= `INITIAL_Y;
        end
        else if(state == `MAIN_GAME1 || state == `MAIN_GAME2 || state == `MAIN_GAME3) begin
            if(dir_next == `RIGHT) begin
                if(head_at_right) begin
                    head_next_x <= `MIN_X;
                    head_next_y <= head_y;
                end
                else begin 
                    head_next_x <= head_x + 1;
                    head_next_y <= head_y;
                end
            end
            else if(dir_next == `LEFT) begin
                if(head_at_left) begin
                    head_next_x <= `MAX_X;
                    head_next_y <= head_y;
                end
                else begin 
                    head_next_x <= head_x - 1;
                    head_next_y <= head_y; 
                end
            end
            else if(dir_next == `UP) begin
                if(head_at_top) begin
                  head_next_x <= head_x;
                  head_next_y <= `MAX_Y;
                end
                else begin
                  head_next_x <= head_x;
                  head_next_y <= head_y - 1;
                end
            end
            else if(dir_next == `DOWN) begin
                if(head_at_down) begin
                    head_next_x <= head_x;
                    head_next_y <= `MIN_Y;
                end
                else begin  
                    head_next_x <= head_x;
                    head_next_y <= head_y + 1;
                end
            end
        end
    end
    
    assign head_at_right = (head_x == `MAX_X ) && (head_y == `MIDDLE_Y) && (dir_next == `RIGHT);  
    assign head_at_left = (head_x == `MIN_X) && (head_y == `MIDDLE_Y) && (dir_next == `LEFT);
    assign head_at_top =  (head_x == `MIDDLE_X) && (head_y == `MIN_Y) && (dir_next == `UP); 
    assign head_at_down = (head_x == `MIDDLE_X) && (head_y == `MAX_Y) && (dir_next == `DOWN);

endmodule

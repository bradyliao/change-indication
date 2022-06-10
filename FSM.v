`include "def.v"

module FSM(clk, rst, BTNL, BTNC, BTNR, BTNU, hit_wall, hit_body, death, win, finish, state);

    input clk, rst, BTNL, BTNC, BTNR, BTNU, hit_wall, hit_body, death, win, finish;
    output reg [2:0] state ;
    reg [2:0] next_state;

    always @(posedge clk) begin
      if(~rst) state <= `MAIN_START;
      else state <= next_state;
    end
    
    always @(*) begin 
      case(state)
        `MAIN_START: begin
          if(finish) next_state <= `MAIN_WAIT;
          else next_state <= `MAIN_START;
        end
        `MAIN_WAIT:
          if(BTNL) next_state <= `MAIN_GAME1;
          else if(BTNC) next_state <= `MAIN_GAME2;
          else if(BTNR) next_state <= `MAIN_GAME3;
          else next_state <= `MAIN_WAIT;
        `MAIN_GAME1:
          if(hit_wall || hit_body || death) next_state <= `MAIN_LOSE;
          else if(win) next_state <= `MAIN_WIN;
          else next_state <= `MAIN_GAME1;
        `MAIN_GAME2:
          if(hit_wall || hit_body || death) next_state <= `MAIN_LOSE;
          else if(win) next_state <= `MAIN_WIN;
          else next_state <= `MAIN_GAME2;
        `MAIN_GAME3:
          if(hit_wall || hit_body || death) next_state <= `MAIN_LOSE;
          else if(win) next_state <= `MAIN_WIN;
          else next_state <= `MAIN_GAME3;
        `MAIN_WIN:
          if(BTNU) next_state <= `MAIN_START;
          else next_state <= `MAIN_WIN; 
        `MAIN_LOSE: begin
          if(BTNU) next_state <= `MAIN_START;
          else next_state <= `MAIN_LOSE; 
        end
        default:
          next_state <= `MAIN_START;
      endcase
    end
    
endmodule

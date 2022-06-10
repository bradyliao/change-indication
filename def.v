`define MAIN_START  3'd0
`define MAIN_WAIT   3'd1
`define MAIN_GAME1  3'd2
`define MAIN_GAME2  3'd3
`define MAIN_GAME3  3'd4
`define MAIN_WIN    3'd5
`define MAIN_LOSE   3'd6

// 65~68
`define LEFT        3'd0
`define UP          3'd1
`define RIGHT       3'd2
`define DOWN        3'd3

`define INITIAL_X   4'd10 //edit
`define INITIAL_Y   4'd10 //edit

`define MAX_X       5'd31 //edit
`define MAX_Y       5'd22 //edit
`define MIDDLE_X    5'd15 //edit
`define MIDDLE_Y    5'd11 //edit
`define MIN_X       5'd0 //edit
`define MIN_Y       5'd0 //edit

`define GRID_X      6'd32 //edit
`define GRIN_Y      6'd31 //edit

// image_ctrl
//62 63
`define MAPX        0
`define MAPY        10
//70~71
`define GRIDXNUM    32
`define GRIDYNUM    23

`define score[0]   {10'b0000000000,
                 10'b0011111100,
                10'b0100000000,
                10'b0100000000,
                10'b0100000000,
                10'b0011111100,
                10'b0000000010,
                10'b0000000010,
                10'b0000000010,
                10'b0011111100
                }
                
`define score[1]={
                10'b0000000000,
                10'b0011111100,
                10'b0100000100,
                10'b0100000100,
                10'b0100000000,
                10'b0100000000,
                10'b0100000000,
                10'b0100000100,
                10'b0100000100,
                10'b0011111100};
                
                //O
                score[2]={
                10'b0000000000,
                10'b0011111100,
                10'b0100000010,
                10'b0100000010,
                10'b0100000010,
                10'b0100000010,
                10'b0100000010,
                10'b0100000010,
                10'b0100000010,
                10'b0011111100};
                
                //R
                score[3]={
                10'b0000000000,
                10'b0011111100,
                10'b0100000010,
                10'b0100000010,
                10'b0100000010,
                10'b0111111100,
                10'b0100000100,
                10'b0100000010,
                10'b0100000010,
                10'b0100000010};
                
                //E
                score[4]={
                10'b0000000000,
                10'b0011111100,
                10'b0100000000,
                10'b0100000000,
                10'b0100000000,
                10'b0011111100,
                10'b0100000000,
                10'b0100000000,
                10'b0100000000,
                10'b0011111100};
                
                score[5]={
                10'b0000000000,
                10'b0000000000,
                10'b0000000000,
                10'b0000110000,
                10'b0000000000,
                10'b0000000000,
                10'b0000110000,
                10'b0000000000,
                10'b0000000000,
                10'b0000000000};
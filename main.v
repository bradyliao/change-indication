`include "def.v"
module main(clk_crystal, SW, BTNC, BTNU, BTND, BTNL, BTNR, LEDs, SSN_out, SSD_out, PS2_DATA, PS2_CLK, vgaRed, vgaGreen, vgaBlue, hsync, vsync);
    input clk_crystal ;
    input [15:0] SW ;
    input BTNC ;
    input BTNU ;
    input BTND ;
    input BTNL ;
    input BTNR ;
    output [15:0] LEDs ;
    output [7:0] SSN_out ;
    output [3:0] SSD_out ;
    // keyboard
    inout PS2_DATA ;
	  inout PS2_CLK ;
    // VGA
    output [3:0] vgaRed ;
    output [3:0] vgaGreen ;
    output [3:0] vgaBlue ;
    output hsync ;
    output vsync ;
    
    // interface
    // ----------------------------------------------------------------------------------------------------------------------------------
    // main structure


    // project internal signal
    // clock
    wire clk_1Hz ;
    wire clk_2Hz ;
    wire clk_25MHz ;
    // button (debounce, output)
    wire BTNL_d_o ;
    wire BTNC_d_o ;
    wire BTNR_d_o ;
    wire BTNU_d_o ;
    // keyboard
    wire kb_up ;
    wire kb_down ;
    wire kb_left ;
    wire kb_right ;
     // reset global (SW[15])
    wire rst_global ;
    

    
    input_handler(
    clk_crystal, SW, BTNC, BTNL, BTNR, BTNU, BTND,      // interface signal
    PS2_DATA, PS2_CLK,                                  //interface signal - keyboard
    // project internal signal
    clk_1Hz, clk_25MHz,                        // clock                                             //186~190
    BTNL_d_o, BTNC_d_o, BTNR_d_o, BTNU_d_o,             // button debounce, output
    kb_up, kb_down, kb_left, kb_right,                  // keyboard
    rst_global,                                          // reset global (SW[15])
    snake_clock
    ) ;

    // <X> no need
    // 51~55
    // 167~171 -> fish
    // 195~204
    // <X> no need
    
    // ----------------------------------------------------------------------------------------------------------------------------------
    

    
    //686~727
    wire win, death, finish;
    reg [4:0]snake_len;
    assign win = (snake_len == 20);
    wire [2:0] state;
    FSM(.clk(clk_crystal), .rst(rst_global),
     .BTNL(BTNL_d_o), .BTNC(BTNC_d_o), .BTNR(BTNR_d_o),.BTNU(BTNU_d_o),
     .hit_wall(hit_wall), .hit_body(hit_body), .death(death),
     .finish(finish), .win(win),
     .state(state[2:0])) ;
     
    //666~684 & 729~742 
    // score_ctl syntax needs to check
    reg [9:0] pixel_x, pixel_y;
    reg [0:10*10-1] score [0:5];
    reg [0:10*10-1] digit [0:9];
    wire score_region [0:5];
    wire score_shape_region [0:5];
    wire score_shape_region [0:5];
    wire score_region [0:5];
    score_ctl (
    .clk(clk_crystal), .rst(rst_global),.snake_len(snake_len), .state(state[1:0]),
    .pixel_x(pixel_x [9:0]), .pixel_y(pixel_y [9:0]),
    .score(score), .digit(digit),
    score_region,score_shape_region, digit_shape_region, decimal_shape_region);
    

    // input: dir, state
    // output: dir_next
    //744~766
    reg [1:0] dir, dir_next;
    always @(posedge clk_crystal) begin 
        if(rst_global)  dir_next <= `RIGHT; 
        else if(state == `MAIN_START) dir_next <= `RIGHT;
        else if(state == `MAIN_GAME1 || state == `MAIN_GAME2 || state == `MAIN_GAME3) begin
            if( kb_right && dir != `LEFT) dir_next <= `RIGHT;
            else if( kb_up && dir != `DOWN)  dir_next <= `UP;
            else if( kb_left && dir != `RIGHT) dir_next <= `LEFT;
            else if( kb_down && dir != `UP)  dir_next <= `DOWN;
        end
    end


    // input : dir_next, state (P), head_x(xsnake[0]), head_y(ysnake[0])
    // internal: head_at_right, left, up, down
    // output: head_next_x, head_next_y
    //768~820
    reg [19:0] xsnake, ysnake;
    reg [4:0] head_next_x, head_next_y;
    snake_pos(.clk(clk_crystal), .dir_next(dir_next),.state(state[2:0]),
     .head_x(xsnake[0]), .head_y(ysnake[0]),
     .head_next_x(head_next_x), .head_next_y(head_next_y));


    // input: snake_clock. state, head_next_x, head_next_y, dir_next
    // output: dir, snakerlength, finished, death, acc_clock, dir, xsnake, ysnake
    // 821, 842~899
    snake_setting(.rst(rst_global), .accelerate(accelerate), .ate(ate),
        .dir_next(dir_next),.state(state),.snake_clock(snake_clock),
        .finish(finish), .death(death),.dir(dir),
        .snake_len(snake_len),.xsnake(xsnake), .ysnake(ysnake));

    //----------------------------------------------------------------------------



    image_ctl(
    // input
    clk_crystal, rst_global, state, pixel_x, pixel_y, xsnake, ysnake, dir_next, head_next_x, head_next_y, enablepart, snakelength,
    // output reg
    poison_clock, poison_flag, 
    // output (wire) : 
    poisoning, margin, grid_line, hit_wall, hit_body, hit_obstacle, start_region, dead_region, win_region, obstacle_region, snake_region, food_region,
    map_region, food_region, food_shape_region, flash_region, flash_shape_region, virus_region, virus_shape_region,   // external wire - vga_pixel_assign
    ate, accelerate   // external wire - snake_setting
    ) ;                  


    // 822~825
    assign LEDs[0] = poison_clock >= 'd1000000000;
    assign LEDs[1] = poison_flag;
    assign LEDs[2] = poison_clock > 0;
    assign LEDs[3] = state == MAIN_LOSE;







    //----------------------------------------------------------------------------
    // VGA
    // 145~164     146 video_on->valid,  |  pixel_tick,-> we don't have it  | rgb_next-> in vga_pixel_assign
    //              pixel_addr->not used since we are not using ram
    //              VBUF_W, VBUF_H -> not used

    wire [11:0] data;
    wire [16:0] pixel_addr;
    wire [11:0] pixel;
    wire valid;
    wire [9:0] h_cnt; //640 visible area
    wire [9:0] v_cnt;  //480 visible area
    
    wire [9:0] pixel_x;
    wire [9:0] pixel_y;  
    
    reg  [11:0] rgb_reg; 

    // 209
    assign {vgaRed, vgaGreen, vgaBlue} = (valid==1'b1) ? rgb_reg:12'h0;



    // 1074~1363
    vga_pixel_assign(
    clk_crystal,
    vga_valid,
    state, map_region, pixel_x, pixel_y, margin, grid_line,
    score_region, score_shape_region,
    digit_region, digit_shape_region, decimal_region, decimal_shape_region
    // MAIN_START, MAIN_WAIT
    start_region, 
    // MAIN_PLAY1, MAIN_PLAY2, MAIN_PLAY3
    obstacle_region, snake_region, poisoning, snake_clock, food_region, food_shape_region, flash_region, flash_shape_region
    virus_region, virus_shape_region,
    // MAIN_WIN
    win_region,
    // MAIN_DEAD
    dead_region
    // output reg - rgb_reg
    rgb_reg
    ) ;

    //180~184
    vga_controller   vga__ctrl(
    .pclk(clk_25MHz),
    .reset(rst_global),
    .hsync(hsync),
    .vsync(vsync),
    .valid(valid),
    .h_cnt(pixel_x),
    .v_cnt(pixel_y)
    );





endmodule

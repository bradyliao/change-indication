// 827~840, 900~1071


module image_ctl(
  // input
  clk_crystal, rst_global, state, pixel_x, pixel_y, xsnake, ysnake, dir_next, head_next_x, head_next_y, enablepart, snakelength,
  // output reg
  poison_clock, poison_flag, 
  // output (wire) : 
  poisoning, margin, grid_line, hit_wall, hit_body, hit_obstacle, start_region, dead_region, win_region, obstacle_region, snake_region, food_region,
  map_region, food_region, food_shape_region, flash_region, flash_shape_region, virus_region, virus_shape_region,   // external wire - vga_pixel_assign
  ate, accelerate   // external wire - snake_setting
  ) ;




// input
input clk_crystal ;
input rst_global ;
input [2:0] state ;
input [9:0] pixel_x ;
input [9:0] pixel_y ;
input [5:0] xsnake[0:19], ysnake[0:19], 
input [1:0] dir_next ;
input [5:0] head_next_x, head_next_y;
input [0:19] enablepart;
input [4:0] snakelength;

// output reg
output reg [31:0] poison_clock;
output reg poison_flag;

// output wire
output poisoning, margin, grid_line, hit_wall, hit_body, hit_obstacle, start_region, dead_region, win_region, obstacle_region, snake_region, food_region,
map_region, food_region, food_shape_region, flash_region, flash_shape_region, virus_region, virus_shape_region,
ate, accelerate ;

// internal wire
wire [5:0] xcurrgrid, ycurrgrid ;
wire food_at_snake, flash_at_snake, food_at_obstacle, food_at_margin, food_at_flash, flash_at_obstacle, flash_at_margin, poisoned ;

// reg internal
reg [1:0] map_select;
reg [0:`GRIDXNUM*`GRIDYNUM-1] map;                //2D array display mapping
reg [0:`GRIDXNUM*`GRIDYNUM-1] start;              //2D array display mapping
reg [0:`GRIDXNUM*`GRIDYNUM-1] win;                //2D array display mapping
reg [0:`GRIDXNUM*`GRIDYNUM-1] dead;               //2D array display mapping
reg [0:`GRIDXNUM*`GRIDYNUM-1] obstacles [0:2];    //2D array display mapping
reg [5:0] xfood, yfood;
reg [5:0] xflash, yflash;
reg [5:0] xvirus, yvirus;
reg [9:0] xrand, yrand;









initial begin
start = {
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00011101000100111001000100111100,
    32'b00100001000101000101001001000000,
    32'b00100001100101000101010001000000,
    32'b00011001010101111101100001111100,
    32'b00000101001101000101010001000000,
    32'b00000101000101000101001001000000,
    32'b00111001000101000101000100111100,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000001110,
    32'b00000000000000000000000011101000,
    32'b00000000000000000000111010101000,
    32'b00000000000000000000101010101000,
    32'b00000000000000001110101010101000,
    32'b00000000000000000010101010101000,
    32'b00000000000000000011101010101000,
    32'b00000000000000000000001110101000,
    32'b00000000000000000000000000111000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000
  };
  dead = {
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00000001000100111001000100000000,
    32'b00000000101001000101000100000000,
    32'b00000000010001000101000100000000,
    32'b00000000010001000101000100000000,
    32'b00000000010001000101000100000000,
    32'b00000000010001000101000100000000,
    32'b00000000010000111000111000000000,
    32'b00000000000000000000000000000000,
    32'b00000001111001111100111100000000,
    32'b00000001000100010001000000000000,
    32'b00000001000100010001000000000000,
    32'b00000001000100010001111100000000,
    32'b00000001000100010001000000000000,
    32'b00000001000100010001000000000000,
    32'b00000001111001111100111100000000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000
  };
  win = {
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00000001000100111001000100000000,
    32'b00000000101001000101000100000000,
    32'b00000000010001000101000100000000,
    32'b00000000010001000101000100000000,
    32'b00000000010001000101000100000000,
    32'b00000000010001000101000100000000,
    32'b00000000010000111000111000000000,
    32'b00000000000000000000000000000000,
    32'b00000001010101111101000100000000,
    32'b00000001010100010001000100000000,
    32'b00000001010100010001100100000000,
    32'b00000001010100010001010100000000,
    32'b00000001010100010001011100000000,
    32'b00000001010100010001000100000000,
    32'b00000000111001111101000100000000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000,
    32'b00000000000000000000000000000000  
  };
   map = {
          32'b11111111111111111111111111111111,    
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b10000000000000000000000000000001, 
          32'b11111111111111111111111111111111
        };
  
obstacles[0] = {  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,  
                  32'b00001111100000000000000000000000,  
                  32'b00000010000000000000000000000000,  
                  32'b00000010000000000000000000000000,  
                  32'b00000010000000000000000000000000,  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000001000000,  
                  32'b00000000000000000000000001000000,  
                  32'b00000000000000000000000001000000,  
                  32'b00000000000000000000000111110000,  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000
            };
  obstacles[1] <= {
                  32'b00000000000000000000000000000000,  
                  32'b00001111100000000000000000000000,  
                  32'b00000010000000000000000000000000,  
                  32'b00000010000000000000000000000000,  
                  32'b00000010000000000000000000000000,  
                  32'b00000000000000001111110000000000,  
                  32'b00000000000000001000000000000000,  
                  32'b00000000000000001000000000000000,  
                  32'b00000000000000001000000000000000,  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,    
                  32'b00000000100000000000000000000000,  
                  32'b00000000100000000000000000000000,  
                  32'b00000000100000000000001111110000,  
                  32'b00000000100000000000000000010000,  
                  32'b00000000111111000000000000010000,  
                  32'b00000000000000000000000000010000,  
                  32'b00000000000000000000001111110000,  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,
                  32'b00000000000000000000000000000000,
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000
            };
            
  obstacles[2] = { 
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000,  
                  32'b00001111100000000000000000000000,  
                  32'b00000010000000000000000000000000,  
                  32'b00000010000000000000000100000000,  
                  32'b00010010000000000000000100000000,  
                  32'b00010000000000001000000100000000,  
                  32'b00010000000000001000000100000000,  
                  32'b00010000000000001000000111110000,  
                  32'b00010000000000001000000100010000,  
                  32'b00000000000000000000000100010000,  
                  32'b00010000000000001000000100010000,  
                  32'b00010010000000001000000100010000,  
                  32'b00010010000000001000000100010000,
                  32'b00010010000000001000000100010000,  
                  32'b00010010000000001000000000010000,  
                  32'b00010010000000000000000000010000,  
                  32'b00000010000000000000000000010000,  
                  32'b00000010000000000000000000000000,  
                  32'b00000000000000000000000000000000,
                  32'b00000000000000000000000000000000,  
                  32'b00000000000000000000000000000000
            };       

end






























always @(posedge clk_crystal) begin
    if(rst_global) begin
        map_select <= 0;
    end
    else if(state == MAIN_GAME1) begin
        map_select <= 0;
    end
    else if(state == MAIN_PLAY2) begin
        map_select <= 1;
    end
    else if(state == MAIN_PLAY3) begin
        map_select <= 2;
    end
end






always @(posedge clk_crystal) begin
  if(rst_global) begin
    poison_clock <= 0;
  end
  else if(poison_flag) begin
    if(poison_clock <= 'd1000000000) begin
      poison_clock <= poison_clock + 1;
    end 
  end
end
assign poisoning = poison_flag && poison_clock <= 'd1000000000;
assign xcurrgrid = (pixel_x[9:1] - `MAPX) / 10;
assign ycurrgrid = (pixel_y[9:1] - `MAPY) / 10;
assign margin = map[ycurrgrid*(`GRIDXNUM)+xcurrgrid];  

assign grid_line = (pixel_x[9:1] % 10 == 0) || (pixel_y[9:1] % 10 == 0);
assign hit_wall =  ((xsnake[0] == 0 && dir_next == `LEFT) ||
                   (xsnake[0] == `GRIDXNUM-1 && dir_next == `RIGHT) ||
                   (ysnake[0] == 0 && dir_next == `UP) ||
                   (ysnake[0] == GRIDYNUM-1 && dir_next == `DOWN) )&& !((xsnake[0]==0 && ysnake[0]==11) || 
                   (xsnake[0]==15  && ysnake[0]==0 )|| (xsnake[0]==15 && ysnake[0]==22) || (xsnake[0]==31 && ysnake[0]==11)); 


// input: enablepart, head_next_x, head_next_y, xsnake, ysnake
// output: hit_body
check_hit_body( .x(head_next_x), .y(head_next_y), .arr_x(xsnake[1:19]), .arr_y(ysnake[1:19]), .arr_en(enablepart[1:19]), .out(hit_body));
                  
assign hit_obstacle = obstacles[map_select][head_next_y*GRIDXNUM+head_next_x];
//assign hit_obstacle = (snake_region==1 && 1 == obstacle_region);
assign start_region = start[ycurrgrid*GRIDXNUM+xcurrgrid];
assign dead_region = dead[ycurrgrid*GRIDXNUM+xcurrgrid];
assign win_region = win[ycurrgrid*GRIDXNUM+xcurrgrid];
assign obstacle_region = obstacles[map_select][ycurrgrid*GRIDXNUM+xcurrgrid];


//949~968
// output: snake_region
check_hit( .x(xcurrgrid), .y(ycurrgrid), .arr_x(xsnake[0:19]), .arr_y(ysnake[0:19]), .arr_en(enablepart[0:19]), .out(snake_region));

                      
//970~989  
// input: xfood, yfood, xsnake, ysnake, enablepart
// output: food_at_snake 
check_hit( .x(xfood), .y(yfood), .arr_x(xsnake[0:19]), .arr_y(ysnake[0:19]), .arr_en(enablepart[0:19]), .out(food_at_snake));

//991~1010
check_hit( .x(xflash), .y(yflash), .arr_x(xsnake[0:19]), .arr_y(ysnake[0:19]), .arr_en(enablepart[0:19]), .out(flash_at_snake));                   


// internal wire
assign food_at_obstacle = obstacles[map_select][yfood*GRIDXNUM+xfood];
assign food_at_margin = xfood == 0 || xfood == GRIDXNUM-1 || yfood == 0 || yfood == GRIDYNUM-1;
assign food_at_flash = (xfood == xflash && yfood == yflash);
assign flash_at_obstacle = obstacles[map_select][yflash*GRIDXNUM+xflash];
assign flash_at_margin = xflash == 0 || xflash == GRIDXNUM-1 || yflash == 0 || yflash == GRIDYNUM-1;
assign poisoned = (head_next_x == xvirus && head_next_y == yvirus);

// external wire - vga_pixel_assign
assign map_region = pixel_x >= MAPX<<1 && pixel_x < (MAPX + GRIDXNUM*GRIDLENGTH)<<1 &&
                    pixel_y >= MAPY<<1 && pixel_y < (MAPY + GRIDYNUM*GRIDLENGTH)<<1;
assign food_region = (xcurrgrid == xfood) && (ycurrgrid == yfood);
assign food_shape_region = food[(pixel_y[9:1]%10)*10+(pixel_x[9:1]%10)];
assign flash_region = (xcurrgrid == xflash) && (ycurrgrid == yflash);
assign flash_shape_region = flash[(pixel_y[9:1]%10)*10+(pixel_x[9:1]%10)];
assign virus_region = (xcurrgrid == xvirus) && (ycurrgrid == yvirus);
assign virus_shape_region = virus[(pixel_y[9:1]%10)*10+(pixel_x[9:1]%10)];

// external wire - snake_setting
assign ate = (head_next_x == xfood && head_next_y == yfood);
assign accelerate = (head_next_x == xflash && head_next_y == yflash);


always @(posedge clk_crystal) begin
    if(rst_global)begin
        xfood <= `INITIAL_X+10;
        yfood <= `INITIAL_Y;
        xflash <= `INITIAL_X;
        yflash <= `INITIAL_Y+5;
        xvirus <= `INITIAL_X+15;
        yvirus <= `INITIAL_Y-5;
        xrand <= 0;
        yrand <= 0;
        poison_flag <= 0;
    end
    else if (state == MAIN_PLAY1 || state == MAIN_PLAY2 || state == MAIN_PLAY3) begin
      if(food_at_snake || food_at_obstacle || food_at_margin || food_at_flash) begin
        xfood <= xrand % `GRIDXNUM;
        yfood <= yrand % `GRIDYNUM;
      end
      else if(flash_at_snake || flash_at_obstacle || flash_at_margin || food_at_flash) begin
        xflash <= xrand % `GRIDXNUM;
        yflash <= yrand % `GRIDYNUM;
      end
      else if(poisoned) begin
        xvirus <= 31;
        yvirus <= 22;
        poison_flag <= 1;
      end
      xrand <= xrand > 1000 ? 0 : xrand + 1;
      yrand <= yrand > 1000 ? 0 : yrand + 1;
    end

end


// ------------------------------------------------------------------------
integer idx;
always @(posedge clk_crystal) begin
  for(idx = 0;idx < 20; idx = idx + 1)
    enablepart[idx] <= idx < snakelength;
end





endmodule
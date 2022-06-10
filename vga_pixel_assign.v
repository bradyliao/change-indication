// input: 
// clk_crystal,
// state, map_region, pixel_x, pixel_y, margin, grid_line,
// score_region, score_shape_region,
// digit_region, digit_shape_region, decimal_region, decimal_shape_region
// // MAIN_START, MAIN_WAIT
// start_region, 
// // MAIN_PLAY1, MAIN_PLAY2, MAIN_PLAY3
// obstacle_region, snake_region, poisoning, snake_clock, food_region, food_shape_region, flash_region, flash_shape_region
// virus_region, virus_shape_region,
// // MAIN_WIN
// win_region,
// // MAIN_DEAD
// dead_region

// reg: , rgb_reg, rgb_next

// output : rgb_reg




module vga_pixel_assign(
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
// output, reg - rgb_reg
rgb_reg
) ;

input clk_crystal ;
input vga_valid ;
input [2:0] state ;
input map_region ;
input [9:0] pixel_x ;
input [9:0] pixel_y ;
input margin ;
input grid_line ;
input score_region[0:5] ;
input score_shape_region [0:5];
input digit_region ;
input digit_shape_region ;
input decimal_region ;
input decimal_shape_region ;
input start_region ;;
input obstacle_region ;
input snake_region;
input poisoning;
input [31:0] snake_clock ;
input food_region;
input food_shape_region;
input flash_region;
input flash_shape_region;
input virus_region;
input virus_shape_region;
input win_region;
input dead_region;
output reg  [11:0] rgb_reg ;

reg rgb_next ;


always @(posedge clk_crystal) begin
    rgb_reg <= rgb_next;
end

always @(*) begin
  if (~vga_valid)
    rgb_next = 12'h000; // Synchronization period, must set RGB values to zero.
  else begin
    if(state == MAIN_START || state == MAIN_WAIT) begin
      if(map_region) begin
        if((pixel_x[9:1]>=0&&pixel_x[9:1]<10&&pixel_y[9:1]>=120&&pixel_y[9:1]<130) ||
            (pixel_x[9:1]>=310&&pixel_x[9:1]<320&&pixel_y[9:1]>=120&&pixel_y[9:1]<130) ||
            (pixel_x[9:1]>=150&&pixel_x[9:1]<160&&pixel_y[9:1]>=10&&pixel_y[9:1]<20) ||
            (pixel_x[9:1]>=150&&pixel_x[9:1]<160&&pixel_y[9:1]>=230&&pixel_y[9:1]<240))begin
            rgb_next<=12'h666;        
        end
        else if(pixel_y[9:1]>170 && pixel_y[9:1]<180 && pixel_x[9:1] >100 && pixel_x[9:1]<=109)begin
            rgb_next=12'hf00;
        end
        else if(margin && !grid_line) begin
          rgb_next = 12'h333;
        end
        else if(grid_line) begin
          rgb_next = 12'h666;
        end
        else if(start_region) begin
          rgb_next = 12'h7f7;
        end
        else begin
          rgb_next = 12'h555;
        end      
      end
      else if(digit_region)begin
        if(digit_shape_region)begin
            rgb_next=12'hfff;
        end      
        else rgb_next=12'h000;
      end
      else if(decimal_region)begin
        if(decimal_shape_region)begin
            rgb_next=12'hfff;
        end      
        else rgb_next=12'h000;
      end
      else if (score_region[0])begin
        if(score_shape_region[0])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[1])begin
        if(score_shape_region[1])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[2])begin
        if(score_shape_region[2])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[3])begin
        if(score_shape_region[3])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[4])begin
        if(score_shape_region[4])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[5])begin
        if(score_shape_region[5])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else begin
        rgb_next = 12'h000;
      end
    end
    else if(state == MAIN_GAME1 || state == MAIN_GAME2 || state == MAIN_GAME3) begin
      if(map_region) begin
        if((pixel_x[9:1]>=0&&pixel_x[9:1]<10&&pixel_y[9:1]>=120&&pixel_y[9:1]<130) ||
            (pixel_x[9:1]>=310&&pixel_x[9:1]<320&&pixel_y[9:1]>=120&&pixel_y[9:1]<130) ||
            (pixel_x[9:1]>=150&&pixel_x[9:1]<160&&pixel_y[9:1]>=10&&pixel_y[9:1]<20) ||
            (pixel_x[9:1]>=150&&pixel_x[9:1]<160&&pixel_y[9:1]>=230&&pixel_y[9:1]<240))begin
            rgb_next<=12'h666;        
        end
        else if(margin && !grid_line) begin
          rgb_next = 12'h333;
        end
        else if(grid_line) begin
          rgb_next = 12'h666;
        end
        else if(obstacle_region) begin
          rgb_next = 12'hffd;
        end
        else if(snake_region) begin
          if(poisoning) begin
            rgb_next = 12'h000+4*snake_clock[30:19];
          end
          else begin  
            rgb_next = 12'h7f7;
          end
        end
        else if(food_region) begin
          if(food_shape_region) begin
            rgb_next = 12'hf00;
          end
          else begin
            rgb_next = 12'h555;
          end
        end
        else if(flash_region) begin
          if(flash_shape_region) begin
            rgb_next = 12'hff0;
          end
          else begin
            rgb_next = 12'h555;
          end
        end
        else if(virus_region) begin
          if(virus_shape_region) begin
            rgb_next = 12'hfff;
          end
          else begin
            rgb_next = 12'h83b; 
          end
        end
        else begin
          rgb_next = 12'h555;
        end
      end
      else if(digit_region)begin
        if(digit_shape_region)begin
            rgb_next=12'hfff;
        end      
        else rgb_next=12'h000;
      end
      else if(decimal_region)begin
        if(decimal_shape_region)begin
            rgb_next=12'hfff;
        end      
        else rgb_next=12'h000;
      end
      else if (score_region[0])begin
        if(score_shape_region[0])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[1])begin
        if(score_shape_region[1])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[2])begin
        if(score_shape_region[2])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[3])begin
        if(score_shape_region[3])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[4])begin
        if(score_shape_region[4])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[5])begin
        if(score_shape_region[5])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else begin
        rgb_next = 12'h000;
      end
    end
    else if(state == MAIN_WIN) begin
      if(map_region) begin
        if((pixel_x[9:1]>=0&&pixel_x[9:1]<10&&pixel_y[9:1]>=120&&pixel_y[9:1]<130) ||
            (pixel_x[9:1]>=310&&pixel_x[9:1]<320&&pixel_y[9:1]>=120&&pixel_y[9:1]<130) ||
            (pixel_x[9:1]>=150&&pixel_x[9:1]<160&&pixel_y[9:1]>=10&&pixel_y[9:1]<20) ||
            (pixel_x[9:1]>=150&&pixel_x[9:1]<160&&pixel_y[9:1]>=230&&pixel_y[9:1]<240))begin
            rgb_next<=12'h666;        
        end
        
        else if(margin && !grid_line) begin
          rgb_next = 12'h333;
        end
        else if(grid_line) begin
          rgb_next = 12'h666;
        end
        else if(win_region) begin
          rgb_next = 12'hfd0;
        end
        else begin
          rgb_next = 12'h555;
        end      
      end
      else if(digit_region)begin
        if(digit_shape_region)begin
            rgb_next=12'hfff;
        end      
        else rgb_next=12'h000;
      end
      else if(decimal_region)begin
        if(decimal_shape_region)begin
            rgb_next=12'hfff;
        end      
        else rgb_next=12'h000;
      end
      else if (score_region[0])begin
        if(score_shape_region[0])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[1])begin
        if(score_shape_region[1])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[2])begin
        if(score_shape_region[2])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[3])begin
        if(score_shape_region[3])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[4])begin
        if(score_shape_region[4])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[5])begin
        if(score_shape_region[5])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else begin
        rgb_next = 12'h000;
      end    
    end
    else if(state == MAIN_LOSE) begin
      if(map_region) begin
        if((pixel_x[9:1]>=0&&pixel_x[9:1]<10&&pixel_y[9:1]>=120&&pixel_y[9:1]<130) ||
            (pixel_x[9:1]>=310&&pixel_x[9:1]<320&&pixel_y[9:1]>=120&&pixel_y[9:1]<130) ||
            (pixel_x[9:1]>=150&&pixel_x[9:1]<160&&pixel_y[9:1]>=10&&pixel_y[9:1]<20) ||
            (pixel_x[9:1]>=150&&pixel_x[9:1]<160&&pixel_y[9:1]>=230&&pixel_y[9:1]<240))begin
            rgb_next<=12'h666;        
        end
        else if(margin && !grid_line) begin
          rgb_next = 12'h333;
        end
        else if(grid_line) begin
          rgb_next = 12'h666;
        end
        else if(dead_region) begin
          rgb_next = 12'hfcc;
        end
        else begin
          rgb_next = 12'h555;
        end      
      end
      else if(digit_region)begin
        if(digit_shape_region)begin
            rgb_next=12'hfff;
        end      
        else rgb_next=12'h000;
      end
      else if(decimal_region)begin
        if(decimal_shape_region)begin
            rgb_next=12'hfff;
        end      
        else rgb_next=12'h000;
      end
      else if (score_region[0])begin
        if(score_shape_region[0])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[1])begin
        if(score_shape_region[1])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[2])begin
        if(score_shape_region[2])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[3])begin
        if(score_shape_region[3])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[4])begin
        if(score_shape_region[4])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else if (score_region[5])begin
        if(score_shape_region[5])rgb_next=12'hfff;
        else rgb_next=12'h000;
      end
      else begin
        rgb_next = 12'h000;
      end    
    end
  end
end

endmodule

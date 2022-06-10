`include "Keyboard_def.v"

module input_handler(
clk_crystal, SW, BTNC, BTNL, BTNR, BTNU, BTND,      // interface signal
PS2_DATA, PS2_CLK,                                  //interface signal - keyboard
// project internal signal
clk_1Hz, clk_25MHz,                        // clock
BTNL_d_o, BTNC_d_o, BTNR_d_o, BTNU_d_o,             // button debounce, output
kb_up, kb_down, kb_left, kb_right,                  // keyboard
rst_global,                                          // reset global (SW[15])
snake_clock
) ;



    input clk_crystal ;
    input [15:0] SW ;
    input BTNC, BTNL, BTNR, BTNU, BTND ;
    
    


    // rst_global
    output rst_global ;
    //debounce(.clk_debounce(clk_100Hz), .in(SW[15]), .out(rst_global) );
    assign rst_global = SW[15] ;
    
    
    // clock
    output clk_1Hz ;
    output clk_25MHz ;
    wire clk_100Hz ;
    clock_generator(.clk_in(clk_crystal), .rst(rst_global), ._1Hz(clk_1Hz), ._4Hz(), ._5Hz(), ._10Hz(), ._20Hz(), ._100Hz(clk_100Hz), ._25MHz(clk_25MHz));
    
    // 219~226
    output reg  [31:0] snake_clock;
    always @(posedge clk_crystal) begin
        if (rst_global) begin
            snake_clock <= 0;
        end
        else begin
            snake_clock <= snake_clock + 1;
        end
    end



    // Buttons
    //121~143
    output BTNL_d_o, BTNC_d_o, BTNR_d_o, BTNU_d_o ;
    debounce_onepulse (.clk_debounce(clk_100Hz), .clk_onepulse(clk_crystal), .in(BTNL), .out(BTNL_d_o));
    debounce_onepulse (.clk_debounce(clk_100Hz), .clk_onepulse(clk_crystal), .in(BTNC), .out(BTNC_d_o));
    debounce_onepulse (.clk_debounce(clk_100Hz), .clk_onepulse(clk_crystal), .in(BTNR), .out(BTNR_d_o));
    debounce_onepulse (.clk_debounce(clk_100Hz), .clk_onepulse(clk_crystal), .in(BTNU), .out(BTNU_d_o));


    // keyboard
    inout PS2_DATA ;
	inout PS2_CLK ;
	output reg kb_up ;
	output reg kb_down ;
	output reg kb_left ;
	output reg kb_right ;
    wire [511:0] key_down ;
	wire [8:0] last_change ;
    wire key_valid ;        // 100 MHz pulse
    KeyboardDecoder(key_down, last_change, key_valid, PS2_DATA, PS2_CLK, rst_global, clk_crystal);

    always @*
    begin
        if(key_valid && key_down[last_change])
            case(last_change)
                `keyboard_up:
                    {kb_up, kb_down, kb_left, kb_right} = 4'b1000 ;
                `keyboard_down:
                    {kb_up, kb_down, kb_left, kb_right} = 4'b0100 ;
                `keyboard_left:
                    {kb_up, kb_down, kb_left, kb_right} = 4'b0010 ;
                `keyboard_right:
                    {kb_up, kb_down, kb_left, kb_right} = 4'b0001 ;
                default:
                    {kb_up, kb_down, kb_left, kb_right} = 4'b0000 ;
            endcase
        else
            {kb_up, kb_down, kb_left, kb_right} = 4'b0000 ;
    end






    
endmodule

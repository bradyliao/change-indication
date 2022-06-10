//clk_debounce: 100Hz
// clk_onepluse -> FSM operating frequency, output frequency
module debounce_onepulse (clk_debounce, clk_onepulse, in, out);
    input clk_debounce ;
    input clk_onepulse ;
    input in ;
    output out ;
    
    wire debounce_to_onepulse ;
    
    
    debounce(clk_debounce, in, debounce_to_onepulse) ;
    one_pulse(clk_onepulse, debounce_to_onepulse, out) ;
    
endmodule






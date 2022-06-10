// clk_onepluse -> FSM operating frequency, output frequency
module one_pulse(clk_onepulse, in, out) ;
    input clk_onepulse ;
    input in ;
    output out ;
    
    reg in_previous ;
    reg out ;

    
    always @(posedge clk_onepulse) begin
        in_previous  <=   in ;
        out          <=   in & (~in_previous) ;
        end

endmodule
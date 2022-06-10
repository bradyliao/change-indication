//clk_debounce: 100Hz
module debounce(clk_debounce, in, out);
    input clk_debounce ;
    input in ;
    output out ;
    
    reg [3:0] window ;
    reg out ;
    

    always @(posedge clk_debounce) begin
        window  <=  {window[2:0], in} ;
        out     <=  window[3] & window[2] & window[1] & window[0] ;
        end

endmodule
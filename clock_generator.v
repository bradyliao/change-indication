// clock_generator(.clk_in(), .rst(), ._1Hz(), ._5Hz(), ._10Hz(), ._20Hz(), ._100Hz());

module clock_generator(clk_in, rst, _1Hz, _4Hz, _5Hz, _10Hz, _20Hz, _25MHz, _100Hz);
    input clk_in ; //system_clk
    input rst ;
    output _1Hz ;
    output _4Hz ;
    output _5Hz ;
    output _10Hz ;
    output _20Hz ;
    output _25MHz ;
    output _100Hz ;
    
    
    clock_1Hz   chip_1Hz    (.clk_in(clk_in), .rst(rst), .clk_out(_1Hz)   );
    clock_4Hz   chip_4Hz    (.clk_in(clk_in), .rst(rst), .clk_out(_4Hz)   );
    clock_5Hz   chip_5Hz    (.clk_in(clk_in), .rst(rst), .clk_out(_5Hz)   );
    clock_10Hz  chip_10Hz   (.clk_in(clk_in), .rst(rst), .clk_out(_10Hz)  );
    clock_20Hz  chip_20Hz   (.clk_in(clk_in), .rst(rst), .clk_out(_20Hz)  );
    clock_100Hz chip_100Hz  (.clk_in(clk_in), .rst(rst), .clk_out(_100Hz) );    
    clock_25MHz  chip_25MHz (.clk_in(clk_in), .rst(rst), .clk_out(_25MHz) );


endmodule






// frequency_out = frequency_in / (2*count_to)
// count_to = frequency_in / (2*frequency_out)

// check `define frequency_in and parameter frequency_out in each module

`define frequency_in 100000000 //100M usually system_clk


// 1Hz
module clock_1Hz(clk_in, rst, clk_out);
    input clk_in ;
    input rst ;
    output clk_out ;
    reg clk_out ;
    
    parameter frequency_out = 1 ;
    parameter  count_to = `frequency_in / (2*frequency_out) ;
    
    integer count = 0 ;
    
    always @(posedge clk_in or posedge rst) begin
        if(rst) begin
            clk_out = 1 ;
            count = 0 ;
            end
        else begin
            if(count != count_to) begin
                clk_out <= clk_out ;
                count <= count + 1 ;
                end
            else begin
                clk_out <= ~clk_out ;
                count = 0 ;
                end
            end
        end
endmodule



// 4Hz
module clock_4Hz(clk_in, rst, clk_out);
    input clk_in ;
    input rst ;
    output clk_out ;
    reg clk_out ;
    
    parameter frequency_out = 4 ;
    parameter  count_to = `frequency_in / (2*frequency_out) ;
    
    integer count = 0 ;
    
    always @(posedge clk_in or posedge rst) begin
        if(rst) begin
            clk_out = 1 ;
            count = 0 ;
            end
        else begin
            if(count != count_to) begin
                clk_out <= clk_out ;
                count <= count + 1 ;
                end
            else begin
                clk_out <= ~clk_out ;
                count = 0 ;
                end
            end
        end
endmodule



// 5Hz
module clock_5Hz(clk_in, rst, clk_out);
    input clk_in ;
    input rst ;
    output clk_out ;
    reg clk_out ;
    
    parameter frequency_out = 5 ;
    parameter  count_to = `frequency_in / (2*frequency_out) ;
    
    integer count = 0 ;
    
    always @(posedge clk_in or posedge rst) begin
        if(rst) begin
            clk_out = 1 ;
            count = 0 ;
            end
        else begin
            if(count != count_to) begin
                clk_out <= clk_out ;
                count <= count + 1 ;
                end
            else begin
                clk_out <= ~clk_out ;
                count = 0 ;
                end
            end
        end
endmodule


// 10Hz
module clock_10Hz(clk_in, rst, clk_out);
    input clk_in ;
    input rst ;
    output clk_out ;
    reg clk_out ;
    
    parameter frequency_out = 10 ;
    parameter  count_to = `frequency_in / (2*frequency_out) ;
    
    integer count = 0 ;
    
    always @(posedge clk_in or posedge rst) begin
        if(rst) begin
            clk_out = 1 ;
            count = 0 ;
            end
        else begin
            if(count != count_to) begin
                clk_out <= clk_out ;
                count <= count + 1 ;
                end
            else begin
                clk_out <= ~clk_out ;
                count = 0 ;
                end
            end
        end
endmodule


// 20Hz
module clock_20Hz(clk_in, rst, clk_out);
    input clk_in ;
    input rst ;
    output clk_out ;
    reg clk_out ;
    
    parameter frequency_out = 20 ;
    parameter  count_to = `frequency_in / (2*frequency_out) ;
    
    integer count = 0 ;
    
    always @(posedge clk_in or posedge rst) begin
        if(rst) begin
            clk_out = 1 ;
            count = 0 ;
            end
        else begin
            if(count != count_to) begin
                clk_out <= clk_out ;
                count <= count + 1 ;
                end
            else begin
                clk_out <= ~clk_out ;
                count = 0 ;
                end
            end
        end
endmodule



// 100Hz
module clock_100Hz(clk_in, rst, clk_out);
    input clk_in ;
    input rst ;
    output clk_out ;
    reg clk_out ;
    
    parameter frequency_out = 100 ;
    parameter  count_to = `frequency_in / (2*frequency_out) ;
    
    integer count = 0 ;
    
    always @(posedge clk_in or posedge rst) begin
        if(rst) begin
            clk_out = 1 ;
            count = 0 ;
            end
        else begin
            if(count != count_to) begin
                clk_out <= clk_out ;
                count <= count + 1 ;
                end
            else begin
                clk_out <= ~clk_out ;
                count = 0 ;
                end
            end
        end
endmodule



// 25MHz
module clock_25MHz(clk_in, rst, clk_out);
    input clk_in ;
    input rst ;
    output clk_out ;
    reg clk_out ;
    
    parameter frequency_out = 25000000 ;
    parameter  count_to = `frequency_in / (2*frequency_out) ;
    
    integer count = 0 ;
    
    always @(posedge clk_in or posedge rst) begin
        if(rst) begin
            clk_out = 1 ;
            count = 0 ;
            end
        else begin
            if(count != count_to) begin
                clk_out <= clk_out ;
                count <= count + 1 ;
                end
            else begin
                clk_out <= ~clk_out ;
                count = 0 ;
                end
            end
        end
endmodule
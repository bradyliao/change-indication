`timescale 1ns / 1ps
module check_hit( x, y, arr_x, arr_y, arr_en, out);
    input x,y;
    input [19:0] arr_x, arr_y, arr_en;
    output out;

    assign out = (x == arr_x[0] && y == arr_y[0] && arr_en[0]) || 
                     (x == arr_x[1] && y == arr_y[1] && arr_en[1]) || 
                     (x == arr_x[2] && y == arr_y[2] && arr_en[2]) || 
                     (x == arr_x[3] && y == arr_y[3] && arr_en[3]) || 
                     (x == arr_x[4] && y == arr_y[4] && arr_en[4]) || 
                     (x == arr_x[5] && y == arr_y[5] && arr_en[5]) || 
                     (x == arr_x[6] && y == arr_y[6] && arr_en[6]) || 
                     (x == arr_x[7] && y == arr_y[7] && arr_en[7]) || 
                     (x == arr_x[8] && y == arr_y[8] && arr_en[8]) || 
                     (x == arr_x[9] && y == arr_y[9] && arr_en[9]) || 
                     (x == arr_x[10] && y == arr_y[10] && arr_en[10]) || 
                     (x == arr_x[11] && y == arr_y[11] && arr_en[11]) || 
                     (x == arr_x[12] && y == arr_y[12] && arr_en[12]) || 
                     (x == arr_x[13] && y == arr_y[13] && arr_en[13]) || 
                     (x == arr_x[14] && y == arr_y[14] && arr_en[14]) || 
                     (x == arr_x[15] && y == arr_y[15] && arr_en[15]) ||
                     (x == arr_x[16] && y == arr_y[16] && arr_en[16]) || 
                     (x == arr_x[17] && y == arr_y[17] && arr_en[17]) || 
                     (x == arr_x[18] && y == arr_y[18] && arr_en[18]) || 
                     (x == arr_x[19] && y == arr_y[19] && arr_en[19]);

endmodule

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21:59:18 02/19/2018 
// Design Name: 
// Module Name: VGA2RAM
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA2RAM(
    input clk,
    input videoon,
    input [15:0] din1,
    input [15:0] din2,
    input [10:0] pixel_x,
    input [10:0]pixel_y,
    output reg [16:0]addr,
    output reg [15:0] dout
    );
    
    parameter 
    X_begin = 1,
    Y_begin = 1,
    im_width = 320,
    im_length = 280,
    Disp_width = 640,
    Disp_length = 480
    ;
    
    always @ ( posedge clk )    begin
        if ((videoon==1) && (pixel_x >= X_begin) && (pixel_x < im_width+X_begin) && (pixel_y >= Y_begin) && (pixel_y < im_length+Y_begin)  )    begin
            addr = (pixel_x-X_begin) + (pixel_y-Y_begin)*im_width ;
            if ( pixel_y < 280 )
                dout = din1;
            else
                dout = din2;
        end
        else
        dout = 0;
    end
endmodule

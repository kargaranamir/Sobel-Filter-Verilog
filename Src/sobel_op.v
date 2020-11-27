`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12:12:23 06/25/2018
// Design Name: 
// Module Name: sobel_op
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


module sobel_op(
    input clk,
    input start,
    input [15:0] din,
    input [3:0] coef,
    output reg [16:0] addr_din,
    output reg [16:0] addr_dout,
    output reg dout,
    output reg wren,
    output reg finish
    );
    
    parameter [7:0] 
    cnst1 = 5,
    cnst2 = 0;
    
    initial begin
        addr_din <= 0;
        addr_dout <= 0;
        wren <= 0;
    end
    
    reg [4:0] red_data [8:0];
    reg [5:0] green_data [8:0];
    reg [4:0] blue_data [8:0];
    reg [3:0] cnt = 0;
    reg next_state = 0;
    reg state = 0;
    reg packet = 0;
    reg packet_reg = 0;
    reg signed [7:0] sobelx_red = 0;
    reg signed [7:0] sobely_red = 0;
    reg signed [7:0] sobelx_green = 0;
    reg signed [7:0] sobely_green = 0;
    reg signed [7:0] sobelx_blue = 0;
    reg signed [7:0] sobely_blue = 0;
    reg [7:0] sobel_red = 0;
    reg [7:0] sobel_green = 0;
    reg [7:0] sobel_blue = 0;
    reg [1:0] op_finish = 0;
    wire [7:0] threshold;
    assign threshold = (cnst1 * coef) + cnst2; 
    always @ (*)    begin
        if (state == 0)
            next_state <= start;
        else
            next_state <= ~finish;
    end
    
    always @ (posedge clk)  begin
        state <= next_state;
    end
    
    always @ (posedge clk)  begin
			if ( op_finish == 2)
				packet <= packet_reg;
        case (next_state)
            0:  begin
            end
            1:  begin
                if ( packet == 0 )   begin
                    case (cnt)
                        0:  begin
                           if ( (addr_dout < 320) || (addr_dout % 320 == 0) ) begin
                              red_data [cnt] <= 0;
                              green_data [cnt] <= 0;
                              blue_data [cnt] <= 0;  
                           end
                           else begin
                               red_data [cnt] <= din [15:11];
                               green_data [cnt] <= din [10:5];
                               blue_data [cnt] <= din [4:0]; 
                           end
                           cnt <= cnt + 1;
                        end
                        
                        1:  begin
                           if (addr_dout < 320)  begin
                              red_data [cnt] <= 0;
                              green_data [cnt] <= 0;
                              blue_data [cnt] <= 0;  
                           end
                           else begin
                               red_data [cnt] <= din [15:11];
                               green_data [cnt] <= din [10:5];
                               blue_data [cnt] <= din [4:0]; 
                           end
                           cnt <= cnt + 1;
                        end
                        
                        2:  begin
                           if ( (addr_dout < 320) || (addr_dout % 320 == 319) ) begin
                              red_data [cnt] <= 0;
                              green_data [cnt] <= 0;
                              blue_data [cnt] <= 0;  
                           end
                           else begin
                               red_data [cnt] <= din [15:11];
                               green_data [cnt] <= din [10:5];
                               blue_data [cnt] <= din [4:0]; 
                           end
                           cnt <= cnt + 1;
                        end 
                        
                         3:  begin
                           if (addr_dout % 320 == 0) begin
                              red_data [cnt] <= 0;
                              green_data [cnt] <= 0;
                              blue_data [cnt] <= 0;  
                           end
                           else begin
                               red_data [cnt] <= din [15:11];
                               green_data [cnt] <= din [10:5];
                               blue_data [cnt] <= din [4:0]; 
                           end
                           cnt <= cnt + 1;
                        end    
                        
                        4:  begin
                           red_data [cnt] <= din [15:11];
                           green_data [cnt] <= din [10:5];
                           blue_data [cnt] <= din [4:0]; 
                           cnt <= cnt + 1;
                        end    
                        
                        5:  begin
                           if (addr_dout % 320 == 319) begin
                              red_data [cnt] <= 0;
                              green_data [cnt] <= 0;
                              blue_data [cnt] <= 0;  
                           end
                           else begin
                               red_data [cnt] <= din [15:11];
                               green_data [cnt] <= din [10:5];
                               blue_data [cnt] <= din [4:0]; 
                           end
                           cnt <= cnt + 1;
                        end    
                        
                        6:  begin
                           if ( (addr_dout >= 76480) || (addr_dout % 320 == 0) ) begin
                              red_data [cnt] <= 0;
                              green_data [cnt] <= 0;
                              blue_data [cnt] <= 0;  
                           end
                           else begin
                               red_data [cnt] <= din [15:11];
                               green_data [cnt] <= din [10:5];
                               blue_data [cnt] <= din [4:0]; 
                           end
                           cnt <= cnt + 1;
                        end
                        
                        7:  begin
                           if (addr_dout >= 76480) begin
                              red_data [cnt] <= 0;
                              green_data [cnt] <= 0;
                              blue_data [cnt] <= 0;  
                           end
                           else begin
                               red_data [cnt] <= din [15:11];
                               green_data [cnt] <= din [10:5];
                               blue_data [cnt] <= din [4:0]; 
                           end
                           cnt <= cnt + 1;
                        end   
                        
                         8:  begin
                           if ( (addr_dout >= 76480) || (addr_dout % 320 == 319) ) begin
                              red_data [cnt] <= 0;
                              green_data [cnt] <= 0;
                              blue_data [cnt] <= 0;  
                           end
                           else begin
                               red_data [cnt] <= din [15:11];
                               green_data [cnt] <= din [10:5];
                               blue_data [cnt] <= din [4:0]; 
                           end
                           cnt <= 0;
                           packet <= 1;
                        end 
                   endcase 
                end                                                                                                                       
            end
        endcase
    end
    
    always @ (posedge clk)  begin
        if ((next_state == 1) && (packet == 0))  begin
            case (cnt)
                0:
                    if (addr_dout <320)
                        addr_din <= addr_dout;
                    else
                        addr_din <= addr_dout - 320;
                        
                1:
                    if ((addr_dout < 320) || (addr_dout % 320 == 319))
                        addr_din <= addr_dout;
                    else
                        addr_din <= addr_dout - 319;

                2:
                    if (addr_dout % 320 == 0)
                        addr_din <= addr_dout;
                    else
                        addr_din <= addr_dout - 1; 
                        
                3:
                    addr_din <= addr_dout;
                    
                4:
                    if (addr_dout % 320 == 319)
                        addr_din <= addr_dout;
                    else
                        addr_din <= addr_dout + 1; 
                        
                5:
                    if ((addr_dout > 76480) || (addr_dout % 320 == 0))
                        addr_din <= addr_dout;
                    else
                        addr_din <= addr_dout + 319;  
                        
                6:
                    if (addr_dout > 76480)
                        addr_din <= addr_dout;
                    else
                        addr_din <= addr_dout + 320;      
                        
                7:
                    if ((addr_dout > 76480) || (addr_dout % 320 == 319))
                        addr_din <= addr_dout;
                    else
                        addr_din <= addr_dout + 321;
                        
                8:
                    if ((addr_dout < 320) || (addr_dout % 320 == 319))
                        addr_din <= addr_dout;
                    else
                        addr_din <= addr_dout - 320;    
                                                                                                                                                            
            endcase
        end
        
        else    begin
            addr_dout <= addr_dout;
            addr_din <= addr_din;
        end
    end
    
    always @ (posedge clk)  begin
        if (packet && op_finish == 0) begin
        sobelx_red <= ( red_data[2] + red_data[8] + 2 * red_data[5] ) - ( red_data[0] + red_data[6] + 2 * red_data[3] ); 
        sobelx_green <= ( green_data[2] + green_data[8] + 2 * green_data[5] ) - ( green_data[0] + green_data[6] + 2 * green_data[3] );  
        sobelx_blue <= ( blue_data[2] + blue_data[8] + 2 * blue_data[5] ) - ( blue_data[0] + blue_data[6] + 2 * blue_data[3] ); 
        sobely_red <= ( red_data[0] + red_data[2] + 2 * red_data[1] ) - ( red_data[6] + red_data[8] + 2 * red_data[7] );
        sobely_green <= ( green_data[0] + green_data[2] + 2 * green_data[1] ) - ( green_data[6] + green_data[8] + 2 * green_data[7] );
        sobely_blue <= ( blue_data[0] + blue_data[2] + 2 * blue_data[1] ) - ( blue_data[6] + blue_data[8] + 2 * blue_data[7] );
        op_finish <= 1;
        wren <= 0;
        end
        
        else if (packet && op_finish == 1)  begin
            if (sobelx_red[7] && sobely_red[7])
                sobel_red <= ~sobelx_red + ~sobely_red + 2;
            else if (sobelx_red[7] && ~sobely_red[7]) 
                sobel_red <= ~sobelx_red + sobely_red + 1;
            else if (~sobelx_red[7] && sobely_red[7]) 
                sobel_red <= sobelx_red + ~sobely_red + 1; 
            else
                sobel_red <= sobelx_red + sobely_red;               

            if (sobelx_green[7] && sobely_green[7])
                sobel_green <= ~sobelx_green + ~sobely_green + 2;
            else if (sobelx_green[7] && ~sobely_green[7]) 
                sobel_green <= ~sobelx_green + sobely_green + 1;
            else if (~sobelx_green[7] && sobely_green[7]) 
                sobel_green <= sobelx_green + ~sobely_green + 1; 
            else
                sobel_green <= sobelx_green + sobely_green; 

            if (sobelx_blue[7] && sobely_blue[7])
                sobel_blue <= ~sobelx_blue + ~sobely_blue + 2;
            else if (sobelx_blue[7] && ~sobely_blue[7]) 
                sobel_blue <= ~sobelx_blue + sobely_blue + 1;
            else if (~sobelx_blue[7] && sobely_blue[7]) 
                sobel_blue <= sobelx_blue + ~sobely_blue + 1; 
            else
                sobel_blue <= sobelx_blue + sobely_blue;
            op_finish <= 2;
        end
        
        else if (packet && op_finish == 2)  begin
            if ( (sobel_red > threshold) || (sobel_green > threshold) || (sobel_blue > threshold) )  begin
                dout <= 1;
                wren <= 1;
                packet_reg <= 0;
                op_finish <= 0;
            end
            
            else    begin
                dout <= 0;
                wren <= 1;
                packet_reg <= 0;
                op_finish <= 0;
            end
				if (addr_dout == 76799)
					addr_dout <= 0;
				else
					addr_dout <= addr_dout + 1;
        end 
					
      else 
        wren <= 0;
    end
	
	 always @ ( posedge clk )
		if ( addr_dout == 76799 )
			finish <= 1;
		else 
			finish <= 0;
			
endmodule

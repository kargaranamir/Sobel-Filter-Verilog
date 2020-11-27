`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21:59:18 02/19/2018 
// Design Name: 
// Module Name: VGA_Cntrl
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


module VGA_Cntrl(input clk,output reg [10:0]pixel_x, output reg [10:0]pixel_y, output videoon, output reg h_synq, output reg v_synq
    );
parameter 	 // parameters of horizontal 
	h_display = 639 ,
	r_border = 16,
	l_border = 48,
	h_retrace = 96 // or sync pulse
; 
// 640 + 16 + 48 + 96 = 800	

parameter 	// parameters of vertical
	v_display = 479,
	b_border = 11,
	t_border = 33,
	v_retrace = 2
;  
reg [10:0]cnt1=0;
reg [10:0]cnt2=0;
reg h_videoon=1;
reg v_videoon=1;
initial 
	begin
		pixel_x=0;
		pixel_y=0;
		h_synq=1;
		v_synq=1;
		
	end
always@(posedge clk)
	begin
		pixel_x=pixel_x +1;
		if (pixel_x==h_display)
			h_videoon=0;
		else if (pixel_x==(h_display+r_border+l_border+h_retrace))
			begin
				h_videoon=1;
				pixel_y=pixel_y+1;
				cnt2=cnt2+1;
				pixel_x=0;
			end	
		cnt1=cnt1+1;				
		if (cnt1==(h_display+r_border))
			h_synq=0;
		else if (cnt1==(h_display+r_border+h_retrace))
			begin
				h_synq=1;
			end
		else if (cnt1==(h_display+r_border+l_border+h_retrace))
			begin
				h_synq=1;
				cnt1=0;
			end			
		if (pixel_y==v_display)
			v_videoon=0;
		else if (pixel_y==(v_display+b_border+t_border+v_retrace))
			begin
				v_videoon=1;
				pixel_y=0;
				pixel_x=0;
			end
		if (cnt2==(v_display+b_border))
			v_synq=0;
		else if (cnt2==(v_display+b_border+v_retrace))
			begin
				v_synq=1;
			end
		else if (cnt2==(v_display+b_border+t_border+v_retrace))
			begin
				v_synq=1;
				cnt2=0;
			end		
	end
and d(videoon,h_videoon,v_videoon);
endmodule

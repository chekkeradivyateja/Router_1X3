`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:49:01 02/08/2025 
// Design Name: 
// Module Name:    Synchronizer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Synchronizer(
    input detect_addr,
    input [1:0] data_in,
    input write_en_reg,
    input clk,
    input rstn,
    input rd_en_0,
    input rd_en_1,
    input rd_en_2,
    output reg [2:0] write_en,
    output reg fifo_full,
    output reg soft_rst_0,
    output reg soft_rst_1,
    output reg soft_rst_2,
    input full_0,
    input full_1,
    input full_2,
    input empty_0,
    input empty_1,
    input empty_2,
    output valid_out_0,
    output valid_out_1,
    output valid_out_2
    );
	 
	 reg [1:0] data_in_temp;
	 reg [4:0]count0, count1, count2;
	 
	 always@(posedge clk)
		begin
			if(~rstn)
				data_in_temp <= 0;
			else if(detect_addr)
				data_in_temp <= data_in;
		end	

//...................address...........

			always@(*)
				begin
					case(data_in_temp)
						2'b00:begin
							fifo_full <= full_0;
							if(write_en_reg)
							write_en <= 3'b001;
							else
							write_en <= 0;
							end
						2'b01:begin
							fifo_full <= full_1;
							if(write_en_reg)
							write_en <= 3'b010;
							else
							write_en <= 0;
							end
						2'b10:begin
							fifo_full <= full_2;
							if(write_en_reg)
							write_en <= 3'b100;
							else
							write_en <= 0;
							end
						default:begin
							fifo_full<=0;
							write_en<=0;
							end
						endcase
					end

//...............valid block.......

assign valid_out_0 = (~empty_0);
assign valid_out_1 = (~empty_1);
assign valid_out_2 = (~empty_2);

//..............soft reset.........

always@(posedge clk)
	begin
		if(~rstn)
			begin
				count0<=0;
				soft_rst_0<=0;
			end
		
		else if(valid_out_0)
			begin
				if(~rd_en_0)
				begin 
					if(count0==29)
					begin
					soft_rst_0 <= 1'b1;
					count0 <= 0;
					end
				else
					begin
					soft_rst_0 <= 1'b0;
					count0 <= count0 + 1'b1;
					end
				end
		else
			count0<=0;
			end
		end	
			
		
		
always@(posedge clk)
	begin
		if(~rstn)
			begin
				count1<=0;
				soft_rst_1<=0;
			end
		
		else if(valid_out_1)
			begin
				if(~rd_en_1)
				begin
					if(count1==29)
					begin
					soft_rst_1 <= 1'b1;
					count1 <= 0;
					end
				else
					begin
					soft_rst_1 <= 1'b0;
					count1 <= count1 + 1'b1;
					end
				end
		else
			count1<=0;
			end
		end

		
		
always@(posedge clk)
	begin
		if(~rstn)
			begin
				count2<=0;
				soft_rst_2<=0;
			end
		
		else if(valid_out_2)
			begin
				if(~rd_en_2)
				begin
					if(count2==29)
					begin
					soft_rst_2 <= 1'b1;
					count2 <= 0;
					end
				else
					begin
					soft_rst_2 <= 1'b0;
					count2 <= count2 + 1'b1;
					end
				end
		else
			count2<=0;
			end
		end		


endmodule

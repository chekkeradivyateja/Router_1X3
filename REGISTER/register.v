`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// NAME       :    Divya Teja Chekkera
// Create Date:    11:13:06 02/17/2025 
// Module Name:    register 
//////////////////////////////////////////////////////////////////////////////////
module register(
    input clk,
    input rstn,
    input pkt_valid,
    input [7:0] data_in,
    input fifo_full,
    input rst_int_reg,
    input detect_add,
    input ld_state,
    input laf_state,
    input full_state,
    input lfd_state,
    output reg parity_done,
    output reg low_pkt_valid,
    output reg err,
    output reg [7:0] dout
    );
	 
	 reg [7:0]header;
	 reg [7:0]int_reg;
	 reg [7:0]int_parity;
	 reg [7:0]ext_parity;
	 
	 
	 always @(posedge clk)
	 begin
		if(!rstn)
		begin
			int_reg <= 0;
			dout <= 0;
			header <= 0;
		end
		else if(	detect_add && pkt_valid && !data_in[1:0]!=2'b11)
			header <= data_in;
		else if(lfd_state)
			dout <= header;
		else if(ld_state && !fifo_full)
			dout <= data_in;
		else if(ld_state && fifo_full)
			int_reg <= data_in;
		else if(laf_state)
			dout <= int_reg;
		end


		always @(posedge clk)
			begin
			if(!rstn)
				begin
					low_pkt_valid <= 0;
				end
			else if(rst_int_reg)
				low_pkt_valid <= 0;
			else if(ld_state && !pkt_valid)
				low_pkt_valid <= 1;
			end


		always@(posedge clk)
			begin
				if(!rstn)
				begin
					parity_done <=0;
				end
				else if(detect_add)
					parity_done <= 0;
				else if(ld_state && !fifo_full && !pkt_valid)
					parity_done <= 1;
				else if(laf_state && low_pkt_valid && !parity_done)
					parity_done <= 1;
			end


		always@(posedge clk)
			begin
				if(!rstn)
					int_parity <= 0;
				else if(detect_add)
					int_parity <= 0;
				else if(lfd_state && pkt_valid)
					int_parity <= int_parity^header;
				else if(ld_state && pkt_valid && !full_state)
					int_parity <= int_parity^data_in;
				else
					int_parity <= int_parity;
			end
			
			
		always @(posedge clk)
			begin
				if(!rstn)
					ext_parity <= 0;
				else if(detect_add)
					ext_parity <= 0;
				else if(ld_state && !pkt_valid && !full_state)
					ext_parity <= data_in;
				else if(laf_state && !parity_done && low_pkt_valid)
					ext_parity <= data_in;
			end


		always @(posedge clk)
			begin
				if(!rstn)
					err <=0;
				else if(parity_done)
					begin
						if(int_parity == ext_parity)
						err <= 0;
						else
						err <= 1;
					end
				else
					err <= 0;
				end	
					
endmodule

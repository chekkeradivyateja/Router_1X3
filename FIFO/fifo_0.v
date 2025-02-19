`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:13:34 02/03/2025 
// Design Name: 
// Module Name:    fifo_0 
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
module fifo_0(
    input clk,
    input rstn,
    input wr_en_0,          
    input soft_rst_0,       
    input rd_en_0,          
    input [7:0] data_in,    
    input lfd_state,        
    output empty,     
    output reg [7:0] data_out_0, 
    output full
		
);
    
    reg [8:0] mem [15:0];    
    reg [4:0] wr_ptr, rd_ptr; 
    reg [6:0] fifo_count;
	 
	 
	 integer i;
	
	 reg lfd_state_d;
		
		////delayiing 1 clk cycle
	always@(posedge clk)
		begin
			if(!rstn)
				lfd_state_d <= 0;
			else
				lfd_state_d <= lfd_state;
		end	


		//write......

		always@(posedge clk)
			begin
				if(!rstn || soft_rst_0)
					begin
						for(i=0; i<16; i=i+1)
						mem[i] <= 0;
					end	
				else if(wr_en_0 && (~full))
					begin
						if(lfd_state_d)
							begin
								mem[wr_ptr[3:0]][8]<=1'b1;
								mem[wr_ptr[3:0]][7:0] <= data_in;
							end
						else
							begin
								mem[wr_ptr[3:0]][8] <= 1'b0;
								mem[wr_ptr[3:0]][7:0] <= data_in;
							end
					end
			end			

    //Read .....
	 
	 always @ (posedge clk)
		begin
			if(!rstn)
				data_out_0 <= 8'b0;
			else if(soft_rst_0)
				data_out_0 <= 8'bz;
			else if (rd_en_0 && !empty)
				data_out_0 <= mem[rd_ptr[3:0]][7:0];
			else if(fifo_count == 0)
				data_out_0 <= 8'bz;
		end
			
	always @(posedge clk)
		begin
			if(!rstn)
					wr_ptr <= 0;
			else if(wr_en_0 && (~full))
				wr_ptr <= wr_ptr + 1'b1;
		end		
		
		
	always @(posedge clk)
		begin
			if(!rstn)
					rd_ptr <= 0;
			else if(rd_en_0 && (~empty))
				rd_ptr <= rd_ptr + 1'b1;
		end			
			
	 assign full = (wr_ptr == ({~rd_ptr[4], rd_ptr[3:0]}));
	 assign empty = (wr_ptr == rd_ptr);
		
	always@(posedge clk)
    begin
      if(rd_en_0 && !empty)
        begin
          if((mem[rd_ptr[3:0]][8])==1'b1)
            fifo_count <= mem[rd_ptr[3:0]][7:2] + 1'b1;
          else if(fifo_count != 0)
            fifo_count <= fifo_count - 1'b1;
        end
    end 
endmodule




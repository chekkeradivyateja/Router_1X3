`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:05:00 02/03/2025 
// Design Name: 
// Module Name:    router1x3 
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
module router1x3(
    input clk,
    input rstn,
    input pkt_valid,
    input [7:0] data_in,
    input rd_en_0,
    input rd_en_1,
    input rd_en_2,
    output valid_out_0,
    output valid_out_1,
    output valid_out_2,
    output [7:0] data_out_0,
    output [7:0] data_out_1,
    output [7:0] data_out_2,
    output error,
    output busy
    );
	 
	 wire soft_reset_0,full_0,empty_0,soft_reset_1,full_1,empty_1,soft_reset_2,full_2,empty_2,
         fifo_full,detect_add,ld_state,laf_state,full_state,lfd_state,rst_int_reg,
         parity_done,low_packet_valid,write_enb_reg;
	wire [2:0]write_enb;
	wire [7:0]d_in;
	
	fifo_0 FIFO0(.clk(clk),
	              .rstn(rstn),
		           .soft_rst_0(soft_reset_0),
			   .wr_en_0(write_enb[0]),
			   .rd_en_0(rd_en_0),
            .lfd_state(lfd_state),
			   .data_in(d_in),
			   .full(full_0),
			   .empty(empty_0),
			   .data_out_0(data_out_0));
				   
				   			   
	
	fifo_0 FIFO_1(.clk(clk),
	             .rstn(rstn),
		          .soft_rst_0(soft_reset_1),
			   .wr_en_0(write_enb[1]),
			   .rd_en_0(rd_en_1),
            .lfd_state(lfd_state),
			   .data_in(d_in),
			   .full(full_1),
			   .empty(empty_1),
			   .data_out_0(data_out_1));
					   
					   
	
	fifo_0 FIFO_2(.clk(clk),
	                   .rstn(rstn),
		           .soft_rst_0(soft_reset_2),
			   .wr_en_0(write_enb[2]),
			   .rd_en_0(rd_en_2),
            .lfd_state(lfd_state),
			   .data_in(d_in),
			   .full(full_2),
			   .empty(empty_2),
			   .data_out_0(data_out_2));
    
    //-------register instantiation-----	
    
	register REGISTER1(.clk(clk),
	                    .rstn(rstn),
			    .pkt_valid(pkt_valid),
	        	  .data_in(data_in),
			    .fifo_full(fifo_full),
	        	  .detect_add(detect_add),
              .ld_state(ld_state),
			    .laf_state(laf_state),
			    .full_state(full_state),
	       	 .lfd_state(lfd_state),
			    .rst_int_reg(rst_int_reg),
			    .err(error),
             .parity_done(parity_done),
			    .low_pkt_valid(low_packet_valid),
			    .dout(d_in));
				  
				  
				  
				  
    				
    //-------synchronizer instantiation-----

      
    
							 
	Synchronizer SYNCHRONIZER1(.clk(clk),
	                         .rstn(rstn),
				 .data_in(data_in[1:0]),
				 .detect_addr(detect_add),
				 .full_0(full_0),
				 .full_1(full_1),
				 .full_2(full_2),
				 .empty_0(empty_0),
				 .empty_1(empty_1),
				 .empty_2(empty_2),
				 .write_en_reg(write_enb_reg),
				 .rd_en_0(rd_en_0),
				 .rd_en_1(rd_en_1),
				 .rd_en_2(rd_en_2),
				 .write_en(write_enb),
				 .fifo_full(fifo_full),
				 .valid_out_0(valid_out_0),
				 .valid_out_1(valid_out_1),
				 .valid_out_2(valid_out_2),
				 .soft_rst_0(soft_reset_0),
				 .soft_rst_1(soft_reset_1),
				 .soft_rst_2(soft_reset_2));						 
							 
							 
							 
    //-------fsm instantiation-----
    
	FSM_contr FSM(.clock(clk),
	               .resetn(rstn),
		       .pkt_valid(pkt_valid),
		       .data_in(data_in[1:0]),
		       .fifo_full(fifo_full),
		       .fifo_empty_0(empty_0),
		       .fifo_empty_1(empty_1),
		       .fifo_empty_2(empty_2),
             .soft_reset_0(soft_reset_0),
		       .soft_reset_1(soft_reset_1),
		       .soft_reset_2(soft_reset_2),
		       .parity_done(parity_done),
		       .low_packet_valid(low_packet_valid),
             .write_enb_reg(write_enb_reg),
	          .detect_add(detect_add),
		       .ld_state(ld_state),
		       .laf_state(laf_state),
		       .lfd_state(lfd_state),
		       .full_state(full_state),
	          .rst_int_reg(rst_int_reg),
	          .busy(busy));
   

endmodule

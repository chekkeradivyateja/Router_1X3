`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   12:09:21 02/17/2025
// Design Name:   register
// Module Name:   /home/divyateja/Lab/Router_1x3/TB_reg.v
// Project Name:  Router_1x3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: register
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_reg;

	// Inputs
	reg clk;
	reg rstn;
	reg pkt_valid;
	reg [7:0] data_in;
	reg fifo_full;
	reg rst_int_reg;
	reg detect_add;
	reg ld_state;
	reg laf_state;
	reg full_state;
	reg lfd_state;

	// Outputs
	wire parity_done;
	wire low_pkt_valid;
	wire err;
	wire [7:0] dout;
	integer i;

	// Instantiate the Unit Under Test (UUT)
	register uut (
		.clk(clk), 
		.rstn(rstn), 
		.pkt_valid(pkt_valid), 
		.data_in(data_in), 
		.fifo_full(fifo_full), 
		.rst_int_reg(rst_int_reg), 
		.detect_add(detect_add), 
		.ld_state(ld_state), 
		.laf_state(laf_state), 
		.full_state(full_state), 
		.lfd_state(lfd_state), 
		.parity_done(parity_done), 
		.low_pkt_valid(low_pkt_valid), 
		.err(err), 
		.dout(dout)
	);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	
		task Reset();
	  begin
		 @(negedge clk)
		 rstn=1'b0;
		 @(negedge clk)
		 rstn=1'b1;
	  end
	endtask

		task initialize();
		  begin
			pkt_valid<=1'b0;
			fifo_full<=1'b0;
			detect_add<=1'b0;
			ld_state<=1'b0;
			laf_state<=1'b0;
			full_state<=1'b0;
			lfd_state<=1'b0;
			rst_int_reg<=1'b0;
		  end
		endtask
		
		task good_pkt;

			reg[7:0]payload_data,parity1,header1;
			reg[5:0]payload_len;
			reg[1:0]addr;

			begin
			 @(negedge clk)
			 payload_len=6'd5;
			 addr=2'b10;
			 pkt_valid=1;
			 detect_add=1;
			 header1={payload_len,addr};
			 parity1=0^header1;
			 data_in=header1;
			 @(negedge clk);
			 detect_add=0;
			 lfd_state=1;
			 full_state=0;
			 fifo_full=0;
			 laf_state=0;
			 for(i=0;i<payload_len;i=i+1)
			 begin
			 @(negedge clk);
			  lfd_state=0;
			  ld_state=1;
			  payload_data={$random}%256;
			  data_in=payload_data;
			  parity1=parity1^data_in;
			 end
			 @(negedge clk);
			 pkt_valid=0;
			 data_in=parity1;
			 @(negedge clk);
			 ld_state=0;
			 end
			 endtask
			 
			 
		task bad_pkt;

			reg[7:0]payload_data,parity1,header1;
			reg[5:0]payload_len;
			reg[1:0]addr;

			begin
			 @(negedge clk)
			 payload_len=6'd5;
			 addr=2'b10;
			 pkt_valid=1;
			 detect_add=1;
			 header1={payload_len,addr};
			 parity1=0^header1;
			 data_in=header1;
			 @(negedge clk);
			 detect_add=0;
			 lfd_state=1;
			 full_state=0;
			 fifo_full=0;
			 laf_state=0;
			 for(i=0;i<payload_len;i=i+1)
			 begin
			 @(negedge clk);
			  lfd_state=0;
			  ld_state=1;
			  payload_data={$random}%256;
			  data_in=payload_data;
			  parity1=parity1^data_in;
			 end
			 @(negedge clk);
			 pkt_valid=0;
			 data_in=46;
			 @(negedge clk);
			 ld_state=0;
			 end
			 endtask
			 
			 
			initial
			 begin
			 Reset();
			 initialize();
			 good_pkt;
			 Reset();
			 bad_pkt;
			 #20
			 
			 $finish;
			 end
 
      
endmodule


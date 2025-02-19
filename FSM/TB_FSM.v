`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:44:32 02/12/2025
// Design Name:   FSM_contr
// Module Name:   /home/divyateja/Lab/Router_1x3/TB_FSM.v
// Project Name:  Router_1x3
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: FSM_contr
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module TB_FSM;

	// Inputs
	reg clock;
	reg resetn;
	reg pkt_valid;
	reg [1:0] data_in;
	reg fifo_full;
	reg fifo_empty_0;
	reg fifo_empty_1;
	reg fifo_empty_2;
	reg soft_reset_0;
	reg soft_reset_1;
	reg soft_reset_2;
	reg parity_done;
	reg low_packet_valid;

	// Outputs
	wire write_enb_reg;
	wire detect_add;
	wire ld_state;
	wire laf_state;
	wire lfd_state;
	wire full_state;
	wire rst_int_reg;
	wire busy;

	// Instantiate the Unit Under Test (UUT)
	FSM_contr uut (
		.clock(clock), 
		.resetn(resetn), 
		.pkt_valid(pkt_valid), 
		.data_in(data_in), 
		.fifo_full(fifo_full), 
		.fifo_empty_0(fifo_empty_0), 
		.fifo_empty_1(fifo_empty_1), 
		.fifo_empty_2(fifo_empty_2), 
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
		.busy(busy)
	);
	
	parameter DECODE_ADDRESS     = 3'b000,
          LOAD_FIRST_DATA 	 = 3'b001,
          LOAD_DATA 		 = 3'b010,
          WAIT_TILL_EMPTY 	 = 3'b011,
          CHECK_PARITY_ERROR = 3'b100,
          LOAD_PARITY 		 = 3'b101,
          FIFO_FULL_STATE 	 = 3'b110,
          LOAD_AFTER_FULL 	 = 3'b111;
			
	 reg [3*8:0]string_cmd;

  always@(uut.PS)
      begin
        case (uut.PS)
	    DECODE_ADDRESS     :  string_cmd = "DA";
	    LOAD_FIRST_DATA    :  string_cmd = "LFD";
	    LOAD_DATA    	   :  string_cmd = "LD";
	    WAIT_TILL_EMPTY    :  string_cmd = "WTE";
	    CHECK_PARITY_ERROR :  string_cmd = "CPE";
	    LOAD_PARITY    	   :  string_cmd = "LP";
	    FIFO_FULL_STATE    :  string_cmd = "FFS";
	    LOAD_AFTER_FULL    :  string_cmd = "LAF";
	    endcase
      end			
	
	initial begin
		clock = 0;
		forever #5 clock = ~clock;
	end
	
	task initialize;
   begin
   {pkt_valid,fifo_empty_0,fifo_empty_1,fifo_empty_2,fifo_full,parity_done,low_packet_valid}=0;
   end
   endtask

   task rst;
   begin
   #10;
    resetn=1'b0;
   #10;
    resetn=1'b1;
   end
   endtask
	
	///......................<14........
	 task t1;
   begin
   @(negedge clock)  // LFD
   begin
   pkt_valid<=1;
   data_in[1:0]<=0;
   fifo_empty_0<=1;
   end              
   @(negedge clock) //LD
   @(negedge clock) //LP
   begin
   fifo_full<=0;
   pkt_valid<=0;
   end
   @(negedge clock) // CPE
   @(negedge clock) // DA
   fifo_full<=0;
   end
   endtask
	
	//..........................== 14.................
	task t2;
   begin
   @(negedge clock)//LFD
   begin
   pkt_valid<=1;
   data_in[1:0]<=0;
   fifo_empty_0<=1;
   end
   @(negedge clock)//LD
   @(negedge clock)//FFS
   fifo_full<=1;
   @(negedge clock)//LAF
   fifo_full<=0;
   @(negedge clock)//LP
   begin
   parity_done<=0;
   low_packet_valid<=1;
   end
   @(negedge clock)//CPE
   @(negedge clock)//DA
   fifo_full<=0;
   end
   endtask
	
	///.........................>14...................
	task t3;
   begin
   @(negedge clock) //LFD
   begin
   pkt_valid<=1;
   data_in[1:0]<=0;
   fifo_empty_0<=1;
   end
   @(negedge clock) //LD
   @(negedge clock) // FFS
   fifo_full<=1;
   @(negedge clock) // LAF
   fifo_full<=0;
   @(negedge clock)  // LD
   begin
      low_packet_valid<=0;
	parity_done<=0;

   end  // LP
   @(negedge clock)
   begin
   fifo_full<=0;
   pkt_valid<=0;
   end
   @(negedge clock) // CPE
   @(negedge clock) // DA
   fifo_full<=0;
   end
   endtask
   /////////////.......................16...
   task t4;
   begin
   @(negedge clock)  // LFD
   begin
   pkt_valid<=1;
   data_in[1:0]<=0;
   fifo_empty_0<=1;
   end        
   @(negedge clock)   // LD
   @(negedge clock)   // LP
   begin
   fifo_full<=0;
   pkt_valid<=0;
   end
   @(negedge clock)   // CPE 
   @(negedge clock)   // FFS
   fifo_full<=1;
   @(negedge clock)   // LAF
   fifo_full<=0;
  @(negedge clock)    // DA
   parity_done=1;
   end
   endtask


   initial
   begin
   rst;
   initialize;
  
    t1;
	rst;
	#30
    t2;
	rst;
	#30
	t3;
	rst;
	#30
    t4;
	rst;
   #100;
	$finish;
   end


	
      
endmodule


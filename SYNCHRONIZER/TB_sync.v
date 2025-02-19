`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// NAME       :   Divya Teja Chekkera
// Create Date:   12:52:41 02/08/2025
// Design Name:   Synchronizer
// Module Name:   TB_sync.v
// Project Name:  Router_1x3
// Verilog Test Fixture created by ISE for module: Synchronizer
////////////////////////////////////////////////////////////////////////////////

module TB_sync;

	// Inputs
	reg detect_addr;
	reg [1:0] data_in;
	reg write_en_reg;
	reg clk;
	reg rstn;
	reg rd_en_0;
	reg rd_en_1;
	reg rd_en_2;
	reg full_0;
	reg full_1;
	reg full_2;
	reg empty_0;
	reg empty_1;
	reg empty_2;

	// Outputs
	wire [2:0] write_en;
	wire fifo_full;
	wire soft_rst_0;
	wire soft_rst_1;
	wire soft_rst_2;
	wire valid_out_0;
	wire valid_out_1;
	wire valid_out_2;
	
	

	// Instantiate the Unit Under Test (UUT)
	Synchronizer uut (
		.detect_addr(detect_addr), 
		.data_in(data_in), 
		.write_en_reg(write_en_reg), 
		.clk(clk), 
		.rstn(rstn), 
		.rd_en_0(rd_en_0), 
		.rd_en_1(rd_en_1), 
		.rd_en_2(rd_en_2), 
		.write_en(write_en), 
		.fifo_full(fifo_full), 
		.soft_rst_0(soft_rst_0), 
		.soft_rst_1(soft_rst_1), 
		.soft_rst_2(soft_rst_2), 
		.full_0(full_0), 
		.full_1(full_1), 
		.full_2(full_2), 
		.empty_0(empty_0), 
		.empty_1(empty_1), 
		.empty_2(empty_2), 
		.valid_out_0(valid_out_0), 
		.valid_out_1(valid_out_1), 
		.valid_out_2(valid_out_2)
	);
	
	initial 
		begin
			clk = 1'b0;
			forever #5 clk = ~clk;
		end	

	task Initialize;
	begin
		detect_addr = 0;
		data_in = 0;
		write_en_reg = 0;
		clk = 0;
		rstn = 0;
		rd_en_0 = 0;
		rd_en_1 = 0;
		rd_en_2 = 0;
		full_0 = 0;
		full_1 = 0;
		full_2 = 0;
		empty_0 = 0;
		empty_1 = 0;
		empty_2 = 0;
	end
	endtask
	
	task reset();
	begin
		@(negedge clk)
		rstn = 1'b0;
		@(negedge clk)
		rstn = 1'b1;
		end
	endtask

	task read_enable(input r1, r2, r3);
		begin
			{rd_en_0, rd_en_1, rd_en_2} = {r1, r2, r3};
		end
	endtask
	
	task detect_addrs(input [1:0]d1, input detect_addr1);
		begin
			data_in = d1;
			detect_addr = detect_addr1;
		end
	endtask	
	
	task fifoFull(input f1, f2, f3);
		begin
			full_0 = f1;
			full_1 = f2;
			full_2 = f3;
		end
	endtask

	task Empty(input e1, e2, e3);
		begin
			empty_0 = e1;
			empty_1 = e2;
			empty_2 = e3;
		end
	endtask

	task write_reg(input i1);
		begin
			write_en_reg = i1;
		end
	endtask

//////..........testing...........

	
		initial
		begin
			Initialize;
			reset();
			@(negedge clk)
			read_enable(0,0,0);
			detect_addrs(2'b00, 1);
			fifoFull(0,0,0);
			write_reg(1);
			Empty(0,0,0);
			#1000;
			$finish;
		end	
		
		
      
endmodule


`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// NAME       :   Divya Teja Chekkera
// Create Date:   15:06:12 02/18/2025
// Design Name:   router1x3
// Module Name:   TB_top_module.v
// Project Name:  Router_1x3
////////////////////////////////////////////////////////////////////////////////

module TB_top_module;

	// Inputs
	reg clk;
	reg rstn;
	reg pkt_valid;
	reg [7:0] data_in;
	reg rd_en_0;
	reg rd_en_1;
	reg rd_en_2;

	// Outputs
	wire valid_out_0;
	wire valid_out_1;
	wire valid_out_2;
	wire [7:0] data_out_0;
	wire [7:0] data_out_1;
	wire [7:0] data_out_2;
	wire error;
	wire busy;
	integer i;

	// Instantiate the Unit Under Test (UUT)
	router1x3 uut (
		.clk(clk), 
		.rstn(rstn), 
		.pkt_valid(pkt_valid), 
		.data_in(data_in), 
		.rd_en_0(rd_en_0), 
		.rd_en_1(rd_en_1), 
		.rd_en_2(rd_en_2), 
		.valid_out_0(valid_out_0), 
		.valid_out_1(valid_out_1), 
		.valid_out_2(valid_out_2), 
		.data_out_0(data_out_0), 
		.data_out_1(data_out_1), 
		.data_out_2(data_out_2), 
		.error(error), 
		.busy(busy)
	);

	initial begin
		clk = 0;
		forever #5 clk = ~clk;
	end
	
	task Reset;
	begin
		@(negedge clk)
		rstn = 1'b0;
		@(negedge clk)
		rstn = 1'b1;
	end
	endtask
	
	
	task Initialize;
	begin
		rstn = 1'b1;
		{rd_en_0, rd_en_1, rd_en_2, pkt_valid} = 0;
	end
	endtask
	
	
	
	// packet generation payload 5
	
	task pkt_gen_5;	
			reg [7:0]header, payload_data, parity;
			reg [8:0]payloadlen;
			
			begin
				parity=0;
				wait(!busy)
				begin
				@(negedge clk);
				payloadlen=5;
				pkt_valid=1'b1;
				header={payloadlen,2'b10};
				data_in=header;
				parity=parity^data_in;
				end
				@(negedge clk);
							
				for(i=0;i<payloadlen;i=i+1)
					begin
					wait(!busy)
                    begin  
					@(negedge clk);
					payload_data={$random}%256;
					data_in=payload_data;
					parity=parity^data_in;
                    end  
					end					
								
              wait(!busy)
                    begin
					@(negedge clk);
					pkt_valid=0;				
					data_in=parity;
                    end
						  
						  repeat(2)
			@(negedge clk);
			rd_en_2=1'b1;
			  wait(uut.FIFO_2.empty)
           @(negedge clk)
           rd_en_2=0;  
			
				end			
              
		endtask
		
		
		
		initial
		begin
		    Initialize;
			Reset;
			#10;
			pkt_gen_5;
            #100;
				$finish;
		end		
      
endmodule


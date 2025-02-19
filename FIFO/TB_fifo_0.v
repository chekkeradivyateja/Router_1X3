`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// NAME        :  Divya Teja Chekkera
// Create Date:   11:40:12 02/04/2025
// Design Name:   fifo_0
// Module Name:   TB_fifo_0.v
// Project Name:  Router_1x3
////////////////////////////////////////////////////////////////////////////////

module TB_fifo_0;

    reg clk;
    reg rstn;
    reg wr_en_0;
    reg soft_rst_0;
    reg rd_en_0;
    reg [7:0] data_in;
    reg lfd_state;

    
    wire empty;
    wire [7:0] data_out_0;
    wire full;

   
    reg [7:0] header, parity;
    reg [6:0] fifo_count;  
    reg [1:0] addr;
    integer i;

    
    fifo_0 uut (
        .clk(clk), 
        .rstn(rstn), 
        .wr_en_0(wr_en_0), 
        .soft_rst_0(soft_rst_0), 
        .rd_en_0(rd_en_0), 
        .data_in(data_in), 
        .lfd_state(lfd_state), 
        .empty(empty), 
        .data_out_0(data_out_0), 
        .full(full)
    );

    
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;  
    end

    
    task rst();
        begin
            @(negedge clk);
            rstn = 1'b0;
            fifo_count = 0;  
            @(negedge clk);
            rstn = 1'b1;
        end
    endtask

   
    task soft_rst();
        begin
            @(negedge clk);
            soft_rst_0 = 1'b1;
            fifo_count = 0; 
            @(negedge clk);
            soft_rst_0 = 1'b0;
        end
    endtask

   
    task initialize();
        begin
            wr_en_0 = 1'b0;
            soft_rst_0 = 1'b0;
            rd_en_0 = 1'b0;
            data_in = 8'b0;
            lfd_state = 1'b0;
        end
    endtask

    
    task pkt_gen;
    
	begin
    #10;
    data_in = {6'd14, 2'b01}; 
    lfd_state = 1;
    wr_en_0 = 1;
    fifo_count = fifo_count +1;

    
    for (i = 0; i < 14; i=i+1) begin
        #10;
        lfd_state = 0;
        data_in = {$random} % 256;
        fifo_count = fifo_count +1;
    end

    
    #10;
    data_in = {$random} % 256;
    fifo_count = fifo_count +1;
end
endtask

initial begin
    rst();
    initialize();
    soft_rst();
    pkt_gen();

    #20; 

    
    rd_en_0 = 1;
    wr_en_0 = 0;
    while (!empty) begin
        #10;
        fifo_count = fifo_count - 1;
    end

    #10;
    rd_en_0 = 0;

    #100 $finish;
end

endmodule


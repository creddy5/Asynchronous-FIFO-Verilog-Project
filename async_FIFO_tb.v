`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 30.10.2025 21:11:03
// Design Name: 
// Module Name: async_FIFO_tb
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


module async_fifo_tb(
    
    );
     // ============================================================
    // Parameters
    // ============================================================
    parameter DATA_WIDTH = 4;
    parameter FIFO_DEPTH = 8;
    parameter ADDR_SIZE  = 4;

    // ============================================================
    // Signals
    // ============================================================
    reg  [DATA_WIDTH-1:0] DATA_IN;
    reg  W_EN, R_EN, W_CLK, R_CLK, RST;
    wire FULL, EMPTY;
    wire [DATA_WIDTH-1:0] DATA_OUT;

    // ============================================================
    // Instantiate DUT
    // ============================================================
    asyn_fifo #(
        .DATA_WIDTH(DATA_WIDTH),
        .FIFO_DEPTH(FIFO_DEPTH),
        .ADDR_SIZE(ADDR_SIZE)
    ) uut (
        .DATA_IN(DATA_IN),
        .W_EN(W_EN),
        .R_EN(R_EN),
        .W_CLK(W_CLK),
        .R_CLK(R_CLK),
        .RST(RST),
        .FULL(FULL),
        .EMPTY(EMPTY),
        .DATA_OUT(DATA_OUT)
    );

    // ============================================================
    // Clock Generation
    // ============================================================
    initial begin
        W_CLK = 0;
        forever #5 W_CLK = ~W_CLK; // Write clock = 100 MHz
    end

    initial begin
        R_CLK = 0;
        forever #7 R_CLK = ~R_CLK; // Read clock ≈ 71 MHz
    end

    // ============================================================
    // Test Sequence
    // ============================================================
    integer i;

    initial begin
        // Initialize
        DATA_IN = 0;
        W_EN = 0;
        R_EN = 0;
        RST = 1;

        // Apply reset
        #20;
        RST = 0;

        $display("==== Starting Asynchronous FIFO Test ====");
        $display("Time\tW_CLK\tR_CLK\tW_EN\tR_EN\tDATA_IN\tDATA_OUT\tFULL\tEMPTY");

        // =====================================================
        // WRITE 10 values into FIFO
        // =====================================================
        for (i = 0; i < 10; i = i + 1) begin
            @(posedge W_CLK);
            if (!FULL) begin
                DATA_IN = i;
                W_EN = 1;
                $display("%0t\t%b\t%b\t%b\t%b\t%0d\t%x\t%b\t%b",
                         $time, W_CLK, R_CLK, W_EN, R_EN, DATA_IN, DATA_OUT, FULL, EMPTY);
            end else begin
                W_EN = 0;
                $display("%0t FIFO FULL - Write halted", $time);
            end
        end
        W_EN = 0;

        // Wait for a few cycles
        #50;

        // =====================================================
        // READ all values from FIFO
        // =====================================================
        for (i = 0; i < 10; i = i + 1) begin
            @(posedge R_CLK);
            if (!EMPTY) begin
                R_EN = 1;
                $display("%0t\t%b\t%b\t%b\t%b\t%0d\t%x\t%b\t%b",
                         $time, W_CLK, R_CLK, W_EN, R_EN, DATA_IN, DATA_OUT, FULL, EMPTY);
            end else begin
                R_EN = 0;
                $display("%0t FIFO EMPTY - Read halted", $time);
            end
        end
        R_EN = 0;

        // =====================================================
        // End simulation
        // =====================================================
        #50;
        $display("==== Simulation Finished ====");
        $stop;
    end
    
endmodule

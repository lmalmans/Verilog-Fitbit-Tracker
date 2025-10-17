`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 09:26:47 PM
// Design Name: 
// Module Name: segment_driver_tb
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
/////////////////////////////////////////////////////////////////////////////////

module segment_driver_tb;

    reg clk100Mhz;  // inputs - we control these
    reg rst; // reset signal
    reg [15:0] display_value;
    reg display_dp;  // control for dp
    wire [7:1] cathodes;  
    wire [3:0] anodes;

 
    segment_driver uut (   ///instantiate the device under test
        .clk100Mhz(clk100Mhz),
        .rst(rst),
        .display_value(display_value),
        .display_dp(display_dp),
        .cathodes(cathodes),
        .anodes(anodes)
    );

    // Generate a 100 MHz clock signal  taht would toggle every 5 ns
    initial begin
        clk100Mhz = 0;
        forever #5 clk100Mhz = ~clk100Mhz;
    end

    // Test stimulus
    initial begin
        // set everthing to default and reset
        rst = 1;   // reset
        display_value = 16'h0000;   // satrt with all 0's
        display_dp = 0;  // dp low

        // Hold reset for a short duration
        #20 rst = 0;

        // Test Case 1: Display value 1234, with  decimal point
        $display("Test Case 1: Display 1234 with decimal point");
        display_value = 16'h1234;
        display_dp = 1;  // Enable decimal point on second digit
        #100000;  // Wait to observe digit multiplexing for 100000 ns

        // Test Case 2:Display value 5678 with no decimal point
        $display("Test Case 2: Display 5678 without decimal point");
        display_value = 16'h5678;
        display_dp = 0;  // Disable decimal point
        #100000;  // Wait

        // Test Case 3: Display value 9999 withno decimal point
        $display("Test Case 3: Display 9999 without decimal point");
        display_value = 16'h9999;
        display_dp = 0;
        #100000;  // Wait

        // Test Case 4:back to all 0000, no decimal point
        $display("Test Case 4: Display 0000 without decimal point");
        display_value = 16'h0000;
        display_dp = 0;
        #100000;  // Wait

        // Test Case 5:reset during middle of the operation
        $display("Test Case 5: Reset during operation");
        rst = 1;
        #20 rst = 0;
        #100000;  // Wait to see cleared outputs

        // done!
        $finish;
    end

    // Monitor outputs - for debugging if anything changes
    initial begin
        $monitor("Time=%0t | rst=%b | display_value=%h | display_dp=%b | anodes=%b | cathodes=%b",
                 $time, rst , display_value, display_dp, anodes, cathodes);
    end

endmodule


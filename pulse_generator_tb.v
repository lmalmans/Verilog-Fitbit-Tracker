`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 08:49:55 PM
// Design Name: 
// Module Name: pulse_generator_tb
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
module pulse_generator_tb;
    reg [1:0] MODE;
    reg STOP;
    reg START;
    reg clk100Mhz;
    reg rst;

    wire pulse;

 
    pulse_generator uut (
        .START(START),
        .STOP(STOP),
        .MODE(MODE),
        .clk100Mhz(clk100Mhz),
        .rst(rst),
        .pulse(pulse)
    );

 // according to the manual we will be using a clk100Mhz which is why I created this clk variable
    initial 
    begin
        clk100Mhz = 0;
        forever #5 clk100Mhz = ~clk100Mhz; 
    end

  
    initial 
    begin
 // the initial state of all the variables in the program
        MODE = 2'b00;
        STOP = 0;
        START = 0;
        rst = 0;
        
 // this resets the program for me to test
        rst = 1;
        #10; 
        rst = 0;
          
// this is walk mode and I added to each one a debug statement for the demo
        $display("Walk Mode 32 pulses ");
        MODE = 2'b00;
        START = 1;
        #1000;

        // Test case 2 same thing but with 64 pulses 
        $display("Jog Mode  64 pulses");
        MODE = 2'b01;
        #1000;
 
 
       // Test case 3 with 128 pulses
        $display("Run Mode  128 pulses");
        MODE = 2'b10;
        #1000;

       // turns the program off
        $display("Off Mode");
        MODE = 2'b11;
        #600; 

      // checks for the stop signal
        $display("STOP signal");
        STOP = 1;
        #200; 
        STOP = 0;
        START = 1;

      // resetting the entire program just like the beginning 
        $display("Reseting the program");
        rst = 1;
        #10; 
        rst = 0;
        #100; 

       
        $finish;
    end
// I used this to monitor the change in each of the variables when creating the code as suggested by the TA 
    initial 
    begin
        $monitor("Time=%0dns, MODE=%b, START=%b, STOP=%b, rst=%b, pulse=%b", $time, MODE, START, STOP, rst, pulse);
    end
endmodule

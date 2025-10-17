`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/02/2025 08:22:27 PM
// Design Name: 
// Module Name: testbench
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


module Rotator_tb();
    reg clk100Mhz;
    reg rst;
    reg [13:0] step_count;
    reg [3:0] distance;
    reg [1:0] mode;
   
    wire [13:0] display_value;
    wire dp;
   
    Rotator uut (
        .clk100Mhz(clk100Mhz),
        .rst(rst),
        .step_count(step_count),
        .distance(distance),
        .mode(mode),
        .display_value(display_value),
        .dp(dp)
    );
   
    initial begin
        clk100Mhz = 0;
        forever #5 clk100Mhz = ~clk100Mhz;  
    end
   
    initial begin
        rst = 1;
        step_count = 16'h1234;
        distance = 16'h0305;  
        mode = 4'h2;     
       
        #100;
        rst = 0;
       
        #300;
       
        step_count = 16'h1678;
        distance = 16'h0750;   
        mode = 4'h1;      
       
        #300;
       
        rst = 1;
        #100;
        rst = 0;
       
        #100;
        $finish;
    end
   
 
   
endmodule
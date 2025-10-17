`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 08:38:34 PM
// Design Name: 
// Module Name: fitbitTracker_tb
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

`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 08:05:28 PM
// Design Name: 
// Module Name: FitbitTracker_tb
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

// here are the variables that will be used for this module
module fitbitTracker_tb;
    reg clk100Mhz;
    reg rst;
    reg pulseSignal;

    wire [13:0] step;
    wire [3:0] stepdisplay;
    wire [3:0] distancedisplay;
    wire OFLOW;

 // connecting it to the main code   
    fitbitTracker uut (
        .clk100Mhz(clk100Mhz),
        .rst(rst),
        .pulseSignal(pulseSignal),
        .step(step),
        .stepdisplay(stepdisplay),
        .distancedisplay(distancedisplay),
        .OFLOW(OFLOW)
    );

 // initializing the clock used and the 100Mhz was gotten from the manual   
    initial clk100Mhz = 0;
    always #5 clk100Mhz = ~clk100Mhz;

 // this line is used to reset thats why it has logic of zero 
    initial begin
        rst = 1;
        pulseSignal = 0;

 // small delay is shown      
        #20;
        rst = 0;
// we would see step_count = 3000, distance = floor(3000 / 2048) = 1 (0.5 miles) using the lines we have created
        repeat(3000) 
        begin
            pulseSignal= 1;
 // small delay
            #10;
            pulseSignal  = 0;
            #90;  
        end

     
        #100;
// we added thing as another test case
        repeat(8000) 
        begin
            pulseSignal = 1;
            #10;
            pulseSignal = 0;
            #90;
        end

       
        #100;

        //  reset
        rst = 1;
        #20;
        rst = 0;

        #100;
        $finish;
    end

endmodule
`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 08:38:21 PM
// Design Name: 
// Module Name: fitbitTracker
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
// Create Date: 04/05/2025 08:17:28 PM
// Design Name: 
// Module Name: fitbitTracker
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
module fitbitTracker(
input pulseSignal,
input clk100Mhz,
input rst,
output reg [15:0] step,
output reg [15:0] stepdisplay,
output [15:0] distancedisplay,
output reg OFLOW
    );
   
   
    always@(posedge clk100Mhz)
        begin
  // this checks if the reset is high
        if(rst) begin
 // resets the step display into being 0
            stepdisplay  <= 0 ;
            stepdisplay <= 0 ;
 // resetting the overflow flag as well as the steps
            OFLOW <= 0 ;
            step<=0;
        end
 // checking if the pulse signal is high      
        else if (pulseSignal) 
        begin
// incrementing the step counter by 1
         step <=  step  + 1;
// 9999 is the max it can do otherwise it's overflow
// so we checking if it's less than the number
           if(step < 9999)
           begin
// if so will will update that step display into what we are getting 
            stepdisplay  <=  step;
             end
             else begin
// if it did get to this number then it will display 9999
// and sets the overflow flag to being 1 because we have an overflow
             stepdisplay <= 9999;
             OFLOW  = 1;
         end
       end
    end
   
//    always@(posedge clk) begin
       
//       if(reset)begin
//        distancedisplay <=0 ;
//        OFLOW <= 0;
//       end
//       else begin
//        distancedisplay <= step >> 11;
//       end
           
//    end
   
  assign distancedisplay = step >> 11;
   
    endmodule

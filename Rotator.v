`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 09:00:58 PM
// Design Name: 
// Module Name: Rotator
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
module Rotator(
    input clk100Mhz,          
    input rst,  
// these two lines will help me to change it to 16 bits in order to match the BCD output            
    input [15:0] step_count,   
    input [15:0] distance,     
    input [3:0] mode,          
    output reg [15:0] display_value, 
    output reg dp              
);
// classmates suggested that I do it in states so this is the states definition 
    parameter STATE_STEPS = 2'b00;
    parameter STATE_DIST = 2'b01;
    parameter STATE_MODE = 2'b10;

// these will be used as the registers 
    reg [27:0] counter;    
    reg [1:0] display_mode;   
    
 
    always @(*)
     begin
    // this will help us know what the display content will be
        case (display_mode)
     
            STATE_STEPS:
             begin
 // assigns the step count with the display value
                display_value = step_count;  
 // setting the decimal point to be off for that step count display
                dp = 0;              
            end
 // this will be used for the travelled distance
            STATE_DIST:
             begin
// assigning the traveled distance in order to display the value 
                   display_value = distance;
// turns on the decimal point
                dp = 1;              
            end
// current mode 
            STATE_MODE: 
            begin
 // assigning the mode to display the valu
                   display_value = {12'b0, mode};  
                dp = 0;              
            end
            default: 
            begin
// clearing the display 
                   display_value = 16'b0;
                dp = 0;
            end
        endcase
    end

    always @(posedge clk100Mhz)
     begin
 // if the reset is active then we set it to the initial of 0
        if (rst)
         begin
// resetting the counter to 0
            counter <= 0;
            display_mode <= STATE_STEPS;
        end 
        else 
        begin
// checks if the counter has reached that number (these were values our classmates helped us with)
            if (counter == 200000000 - 1) 
            begin
               counter <= 0;
                case (display_mode)
// changing the display from being steps into being in distance
                    STATE_STEPS: display_mode <= STATE_DIST;
// changing the distance and into mode 
                    STATE_DIST: display_mode <= STATE_MODE;
                    default: display_mode <= STATE_STEPS;
                endcase
            end 
            else
             begin
                counter <= counter + 1;
            end
        end
    end

endmodule

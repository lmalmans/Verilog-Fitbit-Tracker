`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 08:49:40 PM
// Design Name: 
// Module Name: pulse_generator
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

// inputs and outputs that will be used in this program 
module pulse_generator(
    input [1:0] MODE,
    input START,
    input rst,
    input STOP,
    input clk100Mhz,
    output reg pulse
);
// this is a 28-bit counter 
    reg [27:0] count;
// will be used as a checkpoint for the generating process
    reg generating_checkpoint;
    
// start the cases 
    always@(posedge clk100Mhz) 
    begin
 //if it's on reset then the count is set to 0 as well as the pulse 
        if(rst) begin
            generating_checkpoint <= 0;
            count <= 0;
            pulse <= 0;
        end
        else 
        begin
           
            pulse <= 0;
 // checks if it's a stop and if so it'll put the checkpoint at a 0 telling the program to stop 
            if(STOP)
                generating_checkpoint <= 0;
// checks if it's a start and if so does the opposite to a stop 
            else if(START)
                generating_checkpoint <= 1;
                
  // the MODE is the different cases supplied in the manual    
            if(generating_checkpoint) 
            begin
                count <= count + 1;
 // case number 1 is for it to be walking and equivelant is 00 in binary
                case(MODE)
                    2'b00: begin  
 // this is 3125000 clock cyceles made in every pulse, which is what we used in order to generate 32 pulses   
                        if(count >= 3125000) begin
                            count <= 0;
                            pulse <= 1;
                        end
                    end
// this is the equivelant of the jog mode in the manual it's 01 and the 1562500 is what's used to generate 64 pulses                     
                    2'b01: begin 
                        if(count >= 1562500) begin
                            count <= 0;
                            pulse <= 1;
                        end
                    end
 // this is the 10 which is run mocde and it is what 128 pulses is                    
                    2'b10: 
                    begin 
                        if(count >= 781250) begin
                            count <= 0;
                            pulse <= 1;
                        end
                    end
 // this is turning off                    
                    2'b11: 
                    begin  
                        count <= 0;
                        pulse <= 0;
                    end
                endcase
            end
            else 
            begin
                count <= 0;
            end
        end
    end
endmodule
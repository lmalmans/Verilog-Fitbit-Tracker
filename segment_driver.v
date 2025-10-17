`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/05/2025 09:25:34 PM
// Design Name: 
// Module Name: segment_driver
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

module segment_driver(
    input wire clk100Mhz,          // 100 MHz system clock
    input wire rst,              // synchronous reset
    input wire [15:0] display_value,   // bcd input value for steps
    input wire display_dp,         // Decimal point
    output reg [7:1] cathodes,     // {DP,CG,CF,CE,CD,CC,CB,CA}
    output reg [3:0] anodes        // Anode signals to select what is active
);
   
   //7 segmnet display for numbers going in gfedcba fashion
    always @(*) begin
        case (digit_to_show)
            4'h0: segment_pattern[6:0] = 7'b1000000;  // 0
            4'h1: segment_pattern[6:0] = 7'b1111001;  // 1
            4'h2: segment_pattern[6:0] = 7'b0100100;  // 2
            4'h3: segment_pattern[6:0] = 7'b0110000;  // 3
            4'h4: segment_pattern[6:0] = 7'b0011001;  // 4
            4'h5: segment_pattern[6:0] = 7'b0010010;  // 5
            4'h6: segment_pattern[6:0] = 7'b0000010;  // 6
            4'h7: segment_pattern[6:0] = 7'b1111000;  // 7
            4'h8: segment_pattern[6:0] = 7'b0000000;  // 8
            4'h9: segment_pattern[6:0] = 7'b0010000;  // 9
            default: segment_pattern[6:0] = 7'b1111111;
        endcase
        segment_pattern[7] = decimal_status;  // DP value which is active low
        cathodes = segment_pattern;  // Assign to output on display
    end

    // Internal signals
    reg [7:0] segment_pattern; // 7 seg display
    reg [16:0] refresh_counter; //counter for time multiplexinf
    reg [3:0] digit_to_show;  // current digit that will be showed
    reg decimal_status;  // dp low or high
    wire [1:0] digit_select;
   
    // Digit selection timing- outputs taht need to be dsipalyed
    assign digit_select = refresh_counter[15:14];
   
    // Counter for refresh timing
    always @(posedge clk100Mhz) begin
        if (rst)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end
   
    // logic todecide which digit to show and configure the decimal point
    always @(*) begin
        case (digit_select)
            2'b00: begin  // rightmost digit
                anodes = 4'b1110;
                digit_to_show = display_value[3:0];
                decimal_status = 1;  // Decimal point off (active low)
            end
            2'b01: begin  // second digit from right
                anodes = 4'b1101;
                digit_to_show = display_value[7:4];
                decimal_status = !display_dp;  // Only on for distance mode, active low
            end
            2'b10: begin  // second digit from left
                anodes = 4'b1011;
                digit_to_show = display_value[11:8];
                decimal_status = 1;  // Decimal point off (active low)
            end
            2'b11: begin  // leftmost digit
                anodes = 4'b0111;
                digit_to_show = display_value[15:12];
                decimal_status = 1;  // Decimal point off (active low)
            end
            default: begin
                anodes = 4'b1111;
                digit_to_show = 4'b0000;
                decimal_status = 1;  // Decimal point off (active low)
            end
        endcase
    end
   
endmodule
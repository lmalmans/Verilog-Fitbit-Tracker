`timescale 1ns / 1ps

module top(
    input clk100Mhz,
    input [1:0] mode,
    input START,
    input STOP,
    input rst,
    output [7:1] cathode,
    output [3:0] anode,
    output overflow
);

// Debounced signals
wire start_db, stop_db, rst_db;

// Pulse signal from generator
wire pulse;

// Step and distance counts (binary)
wire [15:0] step, stepdisplay, distancedisplay;

// BCD representations
wire [15:0] bcd_step, bcd_distance;

// Display signals
wire [15:0] display_value;
wire dp;


// Instantiate debouncers
debouncer db_start (.clk100Mhz(clk100Mhz), .rst(rst), .i_sig(START), .o_sig_debounced(start_db));
debouncer db_stop  (.clk100Mhz(clk100Mhz), .rst(rst), .i_sig(STOP),  .o_sig_debounced(stop_db));
debouncer db_rst   (.clk100Mhz(clk100Mhz), .rst(rst), .i_sig(rst),   .o_sig_debounced(rst_db));

// Pulse Generator
pulse_generator pg (
    .MODE(mode),
    .START(start_db),
    .rst(rst_db),
    .STOP(stop_db),
    .clk100Mhz(clk100Mhz),
    .pulse(pulse)
);

// Fitbit Tracker
fitbitTracker tracker (
    .pulseSignal(pulse),
    .clk100Mhz(clk100Mhz),
    .rst(rst_db),
    .step(step),
    .stepdisplay(stepdisplay),
    .distancedisplay(distancedisplay),
    .OFLOW(overflow)
);

// Binary to BCD converters
bin2bcd_fsm bin2bcd_step (
    .clk100Mhz(clk100Mhz),
    .rst(rst_db),
    .start(1'b1), // Always convert (or could sync with pulse)
    .bin(stepdisplay[13:0]),
    .bcd(bcd_step)
);

bin2bcd_fsm bin2bcd_dist (
    .clk100Mhz(clk100Mhz),
    .rst(rst_db),
    .start(1'b1),
    .bin(distancedisplay[13:0]),
    .bcd(bcd_distance)
);

// Rotator
Rotator rotator (
    .clk100Mhz(clk100Mhz),
    .rst(rst_db),
    .step_count(bcd_step),
    .distance(bcd_distance),
    .mode({2'b00, mode}), // padded to 4 bits
    .display_value(display_value),
    .dp(dp)
);

// Segment Display Driver
segment_driver seg_driver (
    .clk100Mhz(clk100Mhz),
    .rst(rst_db),
    .display_value(display_value),
    .display_dp(dp),
    .cathodes(cathode),
    .anodes(anode)
);

endmodule

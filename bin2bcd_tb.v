module bin2bcd_tb();
reg clk100Mhz, rst, start;
reg [13:0] bin;
wire [15:0] bcd;

//dut instantiation and connectivity
bin2bcd_fsm DUT(clk100Mhz, rst, start, bin, bcd);
    
//clock generation
    initial
    begin
        clk100Mhz = 0;
        forever 
        begin
            #5 clk100Mhz = ~clk100Mhz;
        end
    end
	
//intiialization/reset and perform test cases
    initial
    begin
		start = 0;
        rst = 1; #20; rst = 0; #20;
		start = 1;
		bin=14'd7850;
		#700;
		start = 0;
		#100;
		start = 1;
		bin=14'd12;
		#700;
		$finish;
    end
	
endmodule
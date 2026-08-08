module tb_cache_controller;
    reg clk, reset, chip_enable, write_enable, way_select, set;
    reg [3:0] tag;
    reg [31:0] data_in;
    wire [31:0] data_out;
    wire hit, miss, valid;

    cache_controller DUT (
        .clk(clk), .reset(reset), .chip_enable(chip_enable),
        .write_enable(write_enable), .way_select(way_select),
        .tag(tag), .data_in(data_in), .set(set),
        .data_out(data_out), .hit(hit), .miss(miss), .valid(valid)
    );

    initial begin clk = 0; forever #5 clk = ~clk; end

    initial begin
        $dumpfile("cache_sim.vcd");
        $dumpvars(0, tb_cache_controller);

        // Initialization
        reset = 1; chip_enable = 0; write_enable = 0;
        way_select = 0; tag = 4'b0; data_in = 32'b0; set = 0;
        #20; reset = 0; chip_enable = 1;
        
        // Write Way0
        write_enable = 1; way_select = 0; set = 0; tag = 4'hA; data_in = 32'hDEADBEEF; 
        #10;
        
        // Read Way0 (Wait time increased to allow SRAM output)
        write_enable = 0; 
        #20; // <-- Wait 2 clock cycles
        
        // Write Way1
        write_enable = 1; way_select = 1; set = 1; tag = 4'hB; data_in = 32'hCAFEBABE; 
        #10;
        
        // Read Way1
        write_enable = 0; set = 1; tag = 4'hB; 
        #20; // <-- Wait 2 clock cycles
        
        // Read Miss
        tag = 4'hF; 
        #20; // <-- Wait 2 clock cycles
        
        $finish;
    end
endmodule

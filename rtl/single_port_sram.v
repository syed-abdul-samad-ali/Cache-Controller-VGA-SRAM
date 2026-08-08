module single_port_sram (
    input clk,
    input reset,
    input chip_enable,
    input write_enable,
    input read_enable,
    input [0:0] address,      
    input [36:0] data_in,     
    output reg [36:0] data_out 
);
    reg [36:0] memory [0:1];  
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            for (i = 0; i < 2; i = i + 1)
                memory[i] <= 37'b0;
            data_out <= 37'b0;
        end
        else if (chip_enable) begin
            if (write_enable) memory[address] <= data_in;
            if (read_enable) data_out <= memory[address];
        end
    end
endmodule

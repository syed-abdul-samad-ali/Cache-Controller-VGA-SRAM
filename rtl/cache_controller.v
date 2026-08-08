module cache_controller (
    input clk, reset, chip_enable, write_enable, way_select,
    input [3:0] tag, input [31:0] data_in, input set,
    output reg [31:0] data_out, output reg hit, miss, valid
);
    wire [36:0] way0_sram_out, way1_sram_out;
    wire [36:0] cache_line_in = {1'b1, tag, data_in}; 

    single_port_sram WAY0 (
        .clk(clk), .reset(reset), .chip_enable(chip_enable),
        .write_enable(write_enable && ~way_select), 
        .read_enable(~write_enable), .address(set),
        .data_in(cache_line_in), .data_out(way0_sram_out)
    );

    single_port_sram WAY1 (
        .clk(clk), .reset(reset), .chip_enable(chip_enable),
        .write_enable(write_enable && way_select),  
        .read_enable(~write_enable), .address(set),
        .data_in(cache_line_in), .data_out(way1_sram_out)
    );

    wire way0_valid = way0_sram_out[36];
    wire [3:0] way0_tag = way0_sram_out[35:32];
    wire [31:0] way0_data = way0_sram_out[31:0];

    wire way1_valid = way1_sram_out[36];
    wire [3:0] way1_tag = way1_sram_out[35:32];
    wire [31:0] way1_data = way1_sram_out[31:0];

    always @(posedge clk) begin
        if (reset) begin
            hit <= 0; miss <= 0; valid <= 0; data_out <= 0;
        end else if (chip_enable && !write_enable) begin
            if (way0_valid && (way0_tag == tag)) begin
                data_out <= way0_data; hit <= 1; miss <= 0; valid <= 1;
            end else if (way1_valid && (way1_tag == tag)) begin
                data_out <= way1_data; hit <= 1; miss <= 0; valid <= 1;
            end else begin
                data_out <= 0; hit <= 0; miss <= 1; valid <= 0;
            end
        end else if (!chip_enable) begin
            hit <= 0; miss <= 0; valid <= 0;
        end
    end
endmodule


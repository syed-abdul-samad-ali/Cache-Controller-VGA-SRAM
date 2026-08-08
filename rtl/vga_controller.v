module vga_controller (
    input clk, reset,
    output hsync, vsync,
    output [3:0] vga_r, vga_g, vga_b
);
    localparam HD = 640, HF = 16, HS = 96, HB = 48, HT = 800;
    localparam VD = 480, VF = 10, VS = 2,  VB = 33, VT = 525;

    reg [9:0] h_count = 0, v_count = 0;
    reg p_tick = 0; 
    
    always @(posedge clk) p_tick <= ~p_tick; 

    always @(posedge clk) begin
        if (reset) begin
            h_count <= 0; v_count <= 0;
        end else if (p_tick) begin
            if (h_count == HT - 1) begin
                h_count <= 0;
                if (v_count == VT - 1) v_count <= 0;
                else v_count <= v_count + 1;
            end else h_count <= h_count + 1;
        end
    end

    assign hsync = (h_count >= (HD + HF) && h_count <= (HD + HF + HS - 1)) ? 1'b0 : 1'b1;
    assign vsync = (v_count >= (VD + VF) && v_count <= (VD + VF + VS - 1)) ? 1'b0 : 1'b1;
    wire video_on = (h_count < HD) && (v_count < VD);

    wire [7:0] sram_addr = {v_count[7:4], h_count[7:4]};
    wire [11:0] pixel_data;

    vga_sram #(8, 12) FRAME_BUFFER (
        .clk(clk), .write_enable(1'b0), .address(sram_addr),
        .data_in(12'b0), .data_out(pixel_data)
    );

    assign vga_r = video_on ? pixel_data[11:8] : 4'h0;
    assign vga_g = video_on ? pixel_data[7:4]  : 4'h0;
    assign vga_b = video_on ? pixel_data[3:0]  : 4'h0;
endmodule

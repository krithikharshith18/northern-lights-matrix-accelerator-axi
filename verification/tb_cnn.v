`timescale 1ns / 1ps

module tb_cnn;

reg clk = 0;
reg rst = 1;
reg start = 0;

reg accumulation_mode = 0;

reg [31:0] write_data;
reg [63:0] NUM_TILES;

reg tile_done_d;

wire done;
wire tile_done;

wire signed [31:0]
C00_out, C01_out, C02_out, C03_out,
C10_out, C11_out, C12_out, C13_out,
C20_out, C21_out, C22_out, C23_out,
C30_out, C31_out, C32_out, C33_out;

integer file, out, r;
integer d0, d1, d2, d3;
integer tile, packet;

always #5 clk = ~clk;

always @(posedge clk) begin
    tile_done_d <= tile_done;

    // outputs become valid 1 cycle after tile_done
    if(tile_done_d) begin

        $fwrite(out,

        "%d %d %d %d\n\
%d %d %d %d\n\
%d %d %d %d\n\
%d %d %d %d\n\n",

        C00_out, C01_out, C02_out, C03_out,
        C10_out, C11_out, C12_out, C13_out,
        C20_out, C21_out, C22_out, C23_out,
        C30_out, C31_out, C32_out, C33_out

        );
    end
end

Top_Accelerator uut(
    .clk(clk), .rst(rst), .start(start),
    .accumulation_mode(accumulation_mode),

    .write_data(write_data),
    .NUM_TILES(NUM_TILES),

    .done(done),
    .tile_done(tile_done),

    .C00_out(C00_out), .C01_out(C01_out),
    .C02_out(C02_out), .C03_out(C03_out),

    .C10_out(C10_out), .C11_out(C11_out),
    .C12_out(C12_out), .C13_out(C13_out),

    .C20_out(C20_out), .C21_out(C21_out),
    .C22_out(C22_out), .C23_out(C23_out),

    .C30_out(C30_out), .C31_out(C31_out),
    .C32_out(C32_out), .C33_out(C33_out)
);

initial begin

    file = $fopen("input.txt", "r");
    out  = $fopen("output.txt", "w");

    if(file == 0) begin
        $display("ERROR : input.txt not found");
        $finish;
    end

    write_data = 0;
    tile_done_d = 0;

    #20;
    rst = 0;

    NUM_TILES = 16257;
    accumulation_mode = 0;

    @(posedge clk);
    start <= 1;

    @(posedge clk);
    start <= 0;

    for(tile = 0; tile < NUM_TILES; tile = tile + 1) begin

        // each tile = 8 packed 32-bit packets
        for(packet = 0; packet < 8; packet = packet + 1) begin

            r = $fscanf(file, "%d\n", d0);
            r = $fscanf(file, "%d\n", d1);
            r = $fscanf(file, "%d\n", d2);
            r = $fscanf(file, "%d\n", d3);

            @(negedge clk);

            write_data <= {
                d0[7:0],
                d1[7:0],
                d2[7:0],
                d3[7:0]
            };
        end

        // align next overlap burst with controller schedule
        if(tile != NUM_TILES-1) begin
            repeat(5) @(posedge clk);
            @(negedge clk);
        end
    end

    wait(done);

    #50;

    $fclose(file);
    $fclose(out);

    $display("CNN TEST COMPLETED");

    $finish;

end

endmodule
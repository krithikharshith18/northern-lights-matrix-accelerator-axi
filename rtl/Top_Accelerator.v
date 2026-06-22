`timescale 1ns / 1ps

module Top_Accelerator(
    input wire clk, rst, start, accumulation_mode,
    input wire [31:0] write_data,
    input wire [63:0] NUM_TILES,

    output wire done,
    output wire tile_done,

    output wire signed [31:0]
    C00_out, C01_out, C02_out, C03_out,
    C10_out, C11_out, C12_out, C13_out,
    C20_out, C21_out, C22_out, C23_out,
    C30_out, C31_out, C32_out, C33_out
);

wire en, clear, write_en, clear_acc;
wire read_buffer_sel, write_buffer_sel;

wire [2:0] write_addr;
wire [4:0] k;

wire signed [7:0] A0, A1, A2, A3;
wire        [7:0] B0, B1, B2, B3;

wire signed [31:0]
C00, C01, C02, C03,
C10, C11, C12, C13,
C20, C21, C22, C23,
C30, C31, C32, C33;

Controller ctrl(
    .clk(clk), .rst(rst), .start(start),
    .accumulation_mode(accumulation_mode),
    .NUM_TILES(NUM_TILES),

    .en(en), .clear(clear), .write_en(write_en),
    .clear_acc(clear_acc), .tile_done(tile_done), .done(done),

    .count(k), .write_addr(write_addr),
    .read_buffer_sel(read_buffer_sel),
    .write_buffer_sel(write_buffer_sel)
);

Input_Buffer ib(
    .clk(clk), .rst(rst), .en(en), .write_en(write_en),
    .read_buffer_sel(read_buffer_sel),
    .write_buffer_sel(write_buffer_sel),

    .k(k), .write_data(write_data), .write_addr(write_addr),

    .A0(A0), .A1(A1), .A2(A2), .A3(A3),
    .B0(B0), .B1(B1), .B2(B2), .B3(B3)
);

// 4x4 output-stationary systolic array
Array_4x4 arr(
    .clk(clk), .en(en), .rst(rst), .clear(clear),

    .A0(A0), .A1(A1), .A2(A2), .A3(A3),
    .B0(B0), .B1(B1), .B2(B2), .B3(B3),

    .C00(C00), .C01(C01), .C02(C02), .C03(C03),
    .C10(C10), .C11(C11), .C12(C12), .C13(C13),
    .C20(C20), .C21(C21), .C22(C22), .C23(C23),
    .C30(C30), .C31(C31), .C32(C32), .C33(C33)
);

// stores completed tile outputs across accumulation passes
Output_Buffer ob(
    .clk(clk), .rst(rst), .clear_acc(clear_acc),
    .tile_done(tile_done),

    .C00(C00), .C01(C01), .C02(C02), .C03(C03),
    .C10(C10), .C11(C11), .C12(C12), .C13(C13),
    .C20(C20), .C21(C21), .C22(C22), .C23(C23),
    .C30(C30), .C31(C31), .C32(C32), .C33(C33),

    .C00_out(C00_out), .C01_out(C01_out),
    .C02_out(C02_out), .C03_out(C03_out),

    .C10_out(C10_out), .C11_out(C11_out),
    .C12_out(C12_out), .C13_out(C13_out),

    .C20_out(C20_out), .C21_out(C21_out),
    .C22_out(C22_out), .C23_out(C23_out),

    .C30_out(C30_out), .C31_out(C31_out),
    .C32_out(C32_out), .C33_out(C33_out)
);

endmodule
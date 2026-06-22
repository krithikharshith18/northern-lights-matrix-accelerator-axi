`timescale 1ns / 1ps

module PE(
    input wire clk, en, rst, clear,
    input wire signed [7:0] A_in,
    input wire [7:0] B_in,

    output wire signed [7:0] A_out,
    output wire [7:0] B_out,
    output wire signed [31:0] psum_out
);

reg signed [7:0] A_reg;
reg        [7:0] B_reg;

(* use_dsp = "yes" *) reg signed [31:0] psum_reg;

assign A_out = A_reg;
assign B_out = B_reg;
assign psum_out = psum_reg;

always @(posedge clk) begin

    if(rst) begin
        A_reg <= 0;
        B_reg <= 0;
        psum_reg <= 0;
    end

    // clear accumulator between tiles
    else if(clear) begin
        psum_reg <= 0;
    end

    else if(en) begin

        // output stationary MAC operation
        psum_reg <= psum_reg + ($signed(A_reg) * $signed({1'b0, B_reg}));

        // forward operands through systolic array
        A_reg <= A_in;
        B_reg <= B_in;
    end
end

endmodule
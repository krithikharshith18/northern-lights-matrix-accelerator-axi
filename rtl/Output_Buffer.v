`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Output_Buffer(
    input wire clk,rst,tile_done,clear_acc,
    input wire signed [31:0] C00, C01, C02, C03, C10, C11, C12, C13, C20, C21, C22, C23, C30, C31, C32, C33,
    output reg signed [31:0] C00_out, C01_out, C02_out, C03_out, C10_out, C11_out, C12_out, C13_out, C20_out, C21_out, C22_out, C23_out, C30_out, C31_out, C32_out, C33_out
    );
    
always @(posedge clk) begin
    if (rst || clear_acc) begin
        C00_out <= 0; C01_out <= 0; C02_out <= 0; C03_out <= 0;
        C10_out <= 0; C11_out <= 0; C12_out <= 0; C13_out <= 0;
        C20_out <= 0; C21_out <= 0; C22_out <= 0; C23_out <= 0;
        C30_out <= 0; C31_out <= 0; C32_out <= 0; C33_out <= 0;
    end 
    else if (tile_done) begin
        C00_out <= C00_out + C00; C01_out <= C01_out + C01;
        C02_out <= C02_out + C02; C03_out <= C03_out + C03;

        C10_out <= C10_out + C10; C11_out <= C11_out + C11;
        C12_out <= C12_out + C12; C13_out <= C13_out + C13;

        C20_out <= C20_out + C20; C21_out <= C21_out + C21;
        C22_out <= C22_out + C22; C23_out <= C23_out + C23;

        C30_out <= C30_out + C30; C31_out <= C31_out + C31;
        C32_out <= C32_out + C32; C33_out <= C33_out + C33;
    end
end
endmodule

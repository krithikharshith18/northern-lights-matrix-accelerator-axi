`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Array_4x4(
input wire clk,en,rst,clear,
input wire signed [7:0] A0, A1, A2, A3,
input wire [7:0] B0, B1, B2, B3,
output wire signed [31:0] C00, C01, C02, C03, C10, C11, C12, C13, C20, C21, C22, C23, C30, C31, C32, C33
);

// XAABB (X is Matrix Source, AA is Source PE, BB is Destination PE)
wire signed [7:0] A0001, A0102, A0203, A1011, A1112, A1213, A2021, A2122, A2223, A3031, A3132, A3233;
wire [7:0] B0010, B1020, B2030, B0111, B1121, B2131, B0212, B1222, B2232, B0313, B1323, B2333;

// row 0
PE PE00(.clk(clk),.en(en),.rst(rst),.A_in(A0),.B_in(B0),.A_out(A0001),.B_out(B0010),.psum_out(C00),.clear(clear));
PE PE01(.clk(clk),.en(en),.rst(rst),.A_in(A0001),.B_in(B1),.A_out(A0102),.B_out(B0111),.psum_out(C01),.clear(clear));
PE PE02(.clk(clk),.en(en),.rst(rst),.A_in(A0102),.B_in(B2),.A_out(A0203),.B_out(B0212),.psum_out(C02),.clear(clear));
PE PE03(.clk(clk),.en(en),.rst(rst),.A_in(A0203),.B_in(B3),.A_out(),.B_out(B0313),.psum_out(C03),.clear(clear));
// row 1
PE PE10(.clk(clk),.en(en),.rst(rst),.A_in(A1),.B_in(B0010),.A_out(A1011),.B_out(B1020),.psum_out(C10),.clear(clear));
PE PE11(.clk(clk),.en(en),.rst(rst),.A_in(A1011),.B_in(B0111),.A_out(A1112),.B_out(B1121),.psum_out(C11),.clear(clear));
PE PE12(.clk(clk),.en(en),.rst(rst),.A_in(A1112),.B_in(B0212),.A_out(A1213),.B_out(B1222),.psum_out(C12),.clear(clear));
PE PE13(.clk(clk),.en(en),.rst(rst),.A_in(A1213),.B_in(B0313),.A_out(),.B_out(B1323),.psum_out(C13),.clear(clear));
// row 2
PE PE20(.clk(clk),.en(en),.rst(rst),.A_in(A2),.B_in(B1020),.A_out(A2021),.B_out(B2030),.psum_out(C20),.clear(clear));
PE PE21(.clk(clk),.en(en),.rst(rst),.A_in(A2021),.B_in(B1121),.A_out(A2122),.B_out(B2131),.psum_out(C21),.clear(clear));
PE PE22(.clk(clk),.en(en),.rst(rst),.A_in(A2122),.B_in(B1222),.A_out(A2223),.B_out(B2232),.psum_out(C22),.clear(clear));
PE PE23(.clk(clk),.en(en),.rst(rst),.A_in(A2223),.B_in(B1323),.A_out(),.B_out(B2333),.psum_out(C23),.clear(clear));
// row 3
PE PE30(.clk(clk),.en(en),.rst(rst),.A_in(A3),.B_in(B2030),.A_out(A3031),.B_out(),.psum_out(C30),.clear(clear));
PE PE31(.clk(clk),.en(en),.rst(rst),.A_in(A3031),.B_in(B2131),.A_out(A3132),.B_out(),.psum_out(C31),.clear(clear));
PE PE32(.clk(clk),.en(en),.rst(rst),.A_in(A3132),.B_in(B2232),.A_out(A3233),.B_out(),.psum_out(C32),.clear(clear));
PE PE33(.clk(clk),.en(en),.rst(rst),.A_in(A3233),.B_in(B2333),.A_out(),.B_out(),.psum_out(C33),.clear(clear));

endmodule

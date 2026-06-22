module Input_Buffer(
    input wire clk, rst, en, write_en, read_buffer_sel, write_buffer_sel,
    input wire [4:0] k,
    input wire [31:0] write_data,
    input wire [2:0] write_addr,
    output reg signed [7:0] A0, A1, A2, A3,
    output reg [7:0] B0, B1, B2, B3 
);

reg signed [7:0] A_buf0 [15:0];
reg [7:0] B_buf0 [15:0];

reg signed [7:0] A_buf1 [15:0];
reg [7:0] B_buf1 [15:0];

wire signed [7:0] wd0, wd1, wd2, wd3;

assign wd0 = write_data[31:24];
assign wd1 = write_data[23:16];
assign wd2 = write_data[15:8];
assign wd3 = write_data[7:0];

integer i;

// ---------------- WRITE ----------------
always @(posedge clk) begin
    if (rst) begin
        for(i=0;i<16;i=i+1) begin
            A_buf0[i] <= 0; B_buf0[i] <= 0;
            A_buf1[i] <= 0; B_buf1[i] <= 0;
        end
    end
    else if (write_en) begin
        // first tile OR normal write buffer selection
        if (write_buffer_sel == 0) begin
            // write into buf0
            if(write_addr < 4) begin          
                         
                A_buf0[write_addr*4+0] <= wd0;
                A_buf0[write_addr*4+1] <= wd1;
                A_buf0[write_addr*4+2] <= wd2;
                A_buf0[write_addr*4+3] <= wd3;        
            end
            
            else begin       
      
                B_buf0[(write_addr-4)*4+0] <= wd0;
                B_buf0[(write_addr-4)*4+1] <= wd1;
                B_buf0[(write_addr-4)*4+2] <= wd2;
                B_buf0[(write_addr-4)*4+3] <= wd3;           
            end 
            
        end else begin
            // write into buf1
            if(write_addr < 4) begin          
         
                A_buf1[write_addr*4+0] <= wd0;
                A_buf1[write_addr*4+1] <= wd1;
                A_buf1[write_addr*4+2] <= wd2;
                A_buf1[write_addr*4+3] <= wd3;        
            end
            
            else begin       
       
                B_buf1[(write_addr-4)*4+0] <= wd0;
                B_buf1[(write_addr-4)*4+1] <= wd1;
                B_buf1[(write_addr-4)*4+2] <= wd2;
                B_buf1[(write_addr-4)*4+3] <= wd3;           
            end 
        end
    end
end


// ---------------- READ ----------------
always @(*) begin
    // default
    A0 = 0; A1 = 0; A2 = 0; A3 = 0;
    B0 = 0; B1 = 0; B2 = 0; B3 = 0;

    if (en) begin

        if (read_buffer_sel == 0) begin
            // read buf0

            A0 = (k < 4) ? A_buf0[k] : 0;
            A1 = (k >= 1 && k < 5) ? A_buf0[3+k] : 0;
            A2 = (k >= 2 && k < 6) ? A_buf0[6+k] : 0;
            A3 = (k >= 3 && k < 7) ? A_buf0[9+k] : 0;

            B0 = (k < 4) ? B_buf0[4*k] : 0;
            B1 = (k >= 1 && k < 5) ? B_buf0[4*k-3] : 0;
            B2 = (k >= 2 && k < 6) ? B_buf0[4*k-6] : 0;
            B3 = (k >= 3 && k < 7) ? B_buf0[4*k-9] : 0;

        end else begin
            // read buf1

            A0 = (k < 4) ? A_buf1[k] : 0;
            A1 = (k >= 1 && k < 5) ? A_buf1[3+k] : 0;
            A2 = (k >= 2 && k < 6) ? A_buf1[6+k] : 0;
            A3 = (k >= 3 && k < 7) ? A_buf1[9+k] : 0;

            B0 = (k < 4) ? B_buf1[4*k] : 0;
            B1 = (k >= 1 && k < 5) ? B_buf1[4*k-3] : 0;
            B2 = (k >= 2 && k < 6) ? B_buf1[4*k-6] : 0;
            B3 = (k >= 3 && k < 7) ? B_buf1[4*k-9] : 0;
        end
    end
end

endmodule
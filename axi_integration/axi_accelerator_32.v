
`timescale 1 ns / 1 ps

	module axi_accelerator_32 #
	(
		// Users to add parameters here

		// User parameters ends
		// Do not modify the parameters beyond this line


		// Parameters of Axi Slave Bus Interface S00_AXI
		parameter integer C_S00_AXI_DATA_WIDTH	= 32,
		parameter integer C_S00_AXI_ADDR_WIDTH	= 7
	)
	(
		// Users to add ports here

		// User ports ends
		// Do not modify the ports beyond this line


		// Ports of Axi Slave Bus Interface S00_AXI
		input wire  s00_axi_aclk,
		input wire  s00_axi_aresetn,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_awaddr,
		input wire [2 : 0] s00_axi_awprot,
		input wire  s00_axi_awvalid,
		output wire  s00_axi_awready,
		input wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_wdata,
		input wire [(C_S00_AXI_DATA_WIDTH/8)-1 : 0] s00_axi_wstrb,
		input wire  s00_axi_wvalid,
		output wire  s00_axi_wready,
		output wire [1 : 0] s00_axi_bresp,
		output wire  s00_axi_bvalid,
		input wire  s00_axi_bready,
		input wire [C_S00_AXI_ADDR_WIDTH-1 : 0] s00_axi_araddr,
		input wire [2 : 0] s00_axi_arprot,
		input wire  s00_axi_arvalid,
		output wire  s00_axi_arready,
		output wire [C_S00_AXI_DATA_WIDTH-1 : 0] s00_axi_rdata,
		output wire [1 : 0] s00_axi_rresp,
		output wire  s00_axi_rvalid,
		input wire  s00_axi_rready
        
	);
	
	
	
wire done;
wire tile_done;

reg start_acc;

reg [31:0] write_data_acc;

wire signed [31:0]
C00_out, C01_out, C02_out, C03_out,
C10_out, C11_out, C12_out, C13_out,
C20_out, C21_out, C22_out, C23_out,
C30_out, C31_out, C32_out, C33_out;

wire [31:0] reg0_out, reg1_out, reg2_out, reg3_out,
            reg4_out, reg5_out, reg6_out, reg7_out,
            reg8_out, reg9_out, reg10_out, reg11_out,
            reg12_out, reg13_out, reg14_out, reg15_out,
            reg16_out, reg17_out, reg18_out, reg19_out,
            reg20_out, reg21_out, reg22_out, reg23_out,
            reg24_out, reg25_out, reg26_out, reg27_out,
            reg28_out, reg29_out, reg30_out, reg31_out;
            
reg done_d;

reg [31:0] result0,  result1,  result2,  result3;
reg [31:0] result4,  result5,  result6,  result7;
reg [31:0] result8,  result9,  result10, result11;
reg [31:0] result12, result13, result14, result15;            
            
                
    Top_Accelerator uut(
        .clk(s00_axi_aclk),
        .rst(~s00_axi_aresetn),
    
        .start(start_acc),
        .accumulation_mode(1'b0),
        .write_data(write_data_acc),
        .NUM_TILES(64'd1),
    
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
            
// Instantiation of Axi Bus Interface S00_AXI
	axi_accelerator_32_slave_lite_v1_0_S00_AXI # ( 
		.C_S_AXI_DATA_WIDTH(C_S00_AXI_DATA_WIDTH),
		.C_S_AXI_ADDR_WIDTH(C_S00_AXI_ADDR_WIDTH)
	) axi_accelerator_32_slave_lite_v1_0_S00_AXI_inst (
		.S_AXI_ACLK(s00_axi_aclk),
		.S_AXI_ARESETN(s00_axi_aresetn),
		.S_AXI_AWADDR(s00_axi_awaddr),
		.S_AXI_AWPROT(s00_axi_awprot),
		.S_AXI_AWVALID(s00_axi_awvalid),
		.S_AXI_AWREADY(s00_axi_awready),
		.S_AXI_WDATA(s00_axi_wdata),
		.S_AXI_WSTRB(s00_axi_wstrb),
		.S_AXI_WVALID(s00_axi_wvalid),
		.S_AXI_WREADY(s00_axi_wready),
		.S_AXI_BRESP(s00_axi_bresp),
		.S_AXI_BVALID(s00_axi_bvalid),
		.S_AXI_BREADY(s00_axi_bready),
		.S_AXI_ARADDR(s00_axi_araddr),
		.S_AXI_ARPROT(s00_axi_arprot),
		.S_AXI_ARVALID(s00_axi_arvalid),
		.S_AXI_ARREADY(s00_axi_arready),
		.S_AXI_RDATA(s00_axi_rdata),
		.S_AXI_RRESP(s00_axi_rresp),
		.S_AXI_RVALID(s00_axi_rvalid),
		.S_AXI_RREADY(s00_axi_rready),
		.reg0_out(reg0_out),
        .reg1_out(reg1_out),
        .reg2_out(reg2_out),
        .reg3_out(reg3_out),
        .reg4_out(reg4_out),
        .reg5_out(reg5_out),
        .reg6_out(reg6_out),
        .reg7_out(reg7_out),
        .reg8_out(reg8_out),
        .reg9_out(reg9_out),
        .reg10_out(reg10_out),
        .reg11_out(reg11_out),
        .reg12_out(reg12_out),
        .reg13_out(reg13_out),
        .reg14_out(reg14_out),
        .reg15_out(reg15_out),
        .reg16_out(reg16_out),
        .reg17_out(reg17_out),
        .reg18_out(reg18_out),
        .reg19_out(reg19_out),
        .reg20_out(reg20_out),
        .reg21_out(reg21_out),
        .reg22_out(reg22_out),
        .reg23_out(reg23_out),
        .reg24_out(reg24_out),
        .reg25_out(reg25_out),
        .reg26_out(reg26_out),
        .reg27_out(reg27_out),
        .reg28_out(reg28_out),
        .reg29_out(reg29_out),
        .reg30_out(reg30_out),
        .reg31_out(reg31_out),
        .result0(result0),
        .result1(result1),
        .result2(result2),
        .result3(result3),
        .result4(result4),
        .result5(result5),
        .result6(result6),
        .result7(result7),
        .result8(result8),
        .result9(result9),
        .result10(result10),
        .result11(result11),
        .result12(result12),
        .result13(result13),
        .result14(result14),
        .result15(result15)
	);

	// Add user logic here
// Replay FSM: re-creates TB timing from AXI registers

localparam IDLE      = 4'd0,
           START     = 4'd1,
           P0        = 4'd2,
           P1        = 4'd3,
           P2        = 4'd4,
           P3        = 4'd5,
           P4        = 4'd6,
           P5        = 4'd7,
           P6        = 4'd8,
           P7        = 4'd9,
           WAIT_DONE = 4'd10;

reg [3:0] state;
reg start_seen;

    always @(posedge s00_axi_aclk) begin
        if (!s00_axi_aresetn) begin
            state <= IDLE;
            start_seen <= 1'b0;
            start_acc <= 1'b0;
            write_data_acc <= 32'd0;
        end
        else begin
            start_acc <= 1'b0;
    
            case(state)
    
                IDLE: begin
                    if (!reg0_out[0])
                        start_seen <= 1'b0;
    
                    if (reg0_out[0] && !start_seen) begin
                        start_seen <= 1'b1;
                        state <= START;
                    end
                end
    
                START: begin
                    start_acc <= 1'b1;
                    state <= P0;
                end   
    
                P0: begin
                    write_data_acc <= reg1_out;
                    state <= P1;
                end
    
                P1: begin
                    write_data_acc <= reg2_out;
                    state <= P2;
                end
    
                P2: begin
                    write_data_acc <= reg3_out;
                    state <= P3;
                end
    
                P3: begin
                    write_data_acc <= reg4_out;
                    state <= P4;
                end
    
                P4: begin
                    write_data_acc <= reg5_out;
                    state <= P5;
                end
    
                P5: begin
                    write_data_acc <= reg6_out;
                    state <= P6;
                end
    
                P6: begin
                    write_data_acc <= reg7_out;
                    state <= P7;
                end
    
                P7: begin
                    write_data_acc <= reg8_out;
                    state <= WAIT_DONE;
                end
    
                WAIT_DONE: begin
                    if (done)
                        state <= IDLE;
                end
    
                default: begin
                    state <= IDLE;
                end
    
            endcase
        end
    end
    
    
    
    
always @(posedge s00_axi_aclk) begin
done_d <= done;

if(done_d) begin
    result0  <= C00_out;
    result1  <= C01_out;
    result2  <= C02_out;
    result3  <= C03_out;

    result4  <= C10_out;
    result5  <= C11_out;
    result6  <= C12_out;
    result7  <= C13_out;

    result8  <= C20_out;
    result9  <= C21_out;
    result10 <= C22_out;
    result11 <= C23_out;

    result12 <= C30_out;
    result13 <= C31_out;
    result14 <= C32_out;
    result15 <= C33_out;
end
end
	// User logic ends

	endmodule

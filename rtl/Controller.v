`timescale 1ns / 1ps

module Controller(
    input wire clk, rst, start, accumulation_mode,
    input wire [63:0] NUM_TILES,

    output reg en, clear, write_en, clear_acc, tile_done, done,
    output reg [4:0] count,
    output reg [2:0] write_addr,
    output reg read_buffer_sel, write_buffer_sel
);

parameter IDLE = 3'd0,
          LOAD = 3'd1,
          CLEAR = 3'd2,
          RUN = 3'd3,
          DONE = 3'd4,
          PRELOAD_WAIT = 3'd5;

reg [2:0] state, next_state;
reg [63:0] tile_count;
reg [2:0] load_count;

always @(posedge clk) begin
    if(rst) begin
        state <= IDLE;
        count <= 0;
        load_count <= 0;
        tile_count <= 0;

        read_buffer_sel <= 0;
        write_buffer_sel <= 0;
    end

    else begin
        state <= next_state;

        // systolic compute counter
        if(state == RUN)
            count <= count + 1;
        else
            count <= 0;

        // preload counter for first tile
        if(state == LOAD) begin
            if(load_count != 7)
                load_count <= load_count + 1;
        end
        else
            load_count <= 0;

        // completed tile counter
        if(state == DONE && tile_count < NUM_TILES-1)
            tile_count <= tile_count + 1;
        else if(state == IDLE)
            tile_count <= 0;

        // switch write buffer after first preload
        if(state == LOAD && load_count == 7)
            write_buffer_sel <= 1;

        // ping-pong buffer swap after every tile
        if(state == DONE && tile_count < NUM_TILES-1) begin
            read_buffer_sel <= ~read_buffer_sel;
            write_buffer_sel <= ~write_buffer_sel;
        end
    end
end

always @(*) begin
    next_state = state;

    en = 0;
    clear = 0;
    write_en = 0;
    clear_acc = 0;

    done = 0;
    tile_done = 0;

    write_addr = 0;

    // clear accumulator only on first tile or non-accumulation mode
    if(state == CLEAR && (tile_count == 0 || accumulation_mode == 0))
        clear_acc = 1;

    case(state)

    IDLE: begin
        if(start)
            next_state = LOAD;
    end

    // preload first tile into buf0
    LOAD: begin
        write_en = 1;
        write_addr = load_count;

        if(load_count == 7)
            next_state = PRELOAD_WAIT;
    end

    // one-cycle alignment bubble before steady-state execution
    PRELOAD_WAIT:
        next_state = CLEAR;

    CLEAR: begin
        clear = 1;
        next_state = RUN;
    end

    RUN: begin
        en = 1;

        // overlap loading of next tile during compute
        if(tile_count < NUM_TILES-1 && count >= 3 && count <= 10) begin
            write_en = 1;
            write_addr = count - 3;
        end

        if(count == 10)
            next_state = DONE;
    end

    DONE: begin
        tile_done = 1;

        if(tile_count < NUM_TILES-1)
            next_state = CLEAR;

        else begin
            done = 1;
            next_state = IDLE;
        end
    end

    default:
        next_state = IDLE;

    endcase
end

endmodule
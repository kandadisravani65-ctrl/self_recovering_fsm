
`timescale 1ns/1ps

module self_recovering_fsm (
    input  wire clk,
    input  wire rst_n,
    input  wire start,
    output reg  busy,
    output reg  done,
    output reg  recovery_flag
);

    // State encoding
    localparam IDLE   = 2'b00;
    localparam ACTIVE = 2'b01;
    localparam DONE   = 2'b10;

    reg [1:0] state, next_state;

    // State register: active-low asynchronous reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Next-state logic with illegal-state recovery
    always @(*) begin
        next_state = IDLE;

        case (state)
            IDLE: begin
                if (start)
                    next_state = ACTIVE;
                else
                    next_state = IDLE;
            end

            ACTIVE: begin
                next_state = DONE;
            end

            DONE: begin
                next_state = IDLE;
            end

            default: begin
                // Any illegal encoding recovers to IDLE
                next_state = IDLE;
            end
        endcase
    end

    // Registered-state outputs
    always @(*) begin
        busy           = 1'b0;
        done           = 1'b0;
        recovery_flag  = 1'b0;

        case (state)
            IDLE: begin
                busy = 1'b0;
                done = 1'b0;
            end

            ACTIVE: begin
                busy = 1'b1;
                done = 1'b0;
            end

            DONE: begin
                busy = 1'b0;
                done = 1'b1;
            end

            default: begin
                // Indicate detection of an illegal state
                recovery_flag = 1'b1;
            end
        endcase
    end

endmodule


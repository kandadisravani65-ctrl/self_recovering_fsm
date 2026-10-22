
`timescale 1ns/1ps

module self_recovering_fsm_tb;

    reg clk;
    reg rst_n;
    reg start;

    wire busy;
    wire done;
    wire recovery_flag;

    integer errors;

    self_recovering_fsm dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .busy(busy),
        .done(done),
        .recovery_flag(recovery_flag)
    );

    // 10 ns clock period
    always #5 clk = ~clk;

    initial begin
        clk   = 1'b0;
        rst_n = 1'b0;
        start = 1'b0;
        errors = 0;

        $dumpfile("waveforms/self_recovering_fsm.vcd");
        $dumpvars(0, self_recovering_fsm_tb);

        $display("======================================");
        $display(" Self-Recovering FSM Testbench");
        $display("======================================");

        // Test 1: Reset returns FSM to IDLE
        #12;
        rst_n = 1'b1;
        #1;

        if (busy == 0 && done == 0 && recovery_flag == 0)
            $display("PASS: Reset places FSM in IDLE");
        else begin
            $display("FAIL: Reset test");
            errors = errors + 1;
        end

        // Test 2: Start moves FSM to ACTIVE
        @(negedge clk);
        start = 1'b1;
        @(posedge clk);
        #1;
        start = 1'b0;

        if (busy == 1 && done == 0)
            $display("PASS: FSM enters ACTIVE");
        else begin
            $display("FAIL: ACTIVE state test");
            errors = errors + 1;
        end

        // Test 3: ACTIVE transitions to DONE
        @(posedge clk);
        #1;

        if (busy == 0 && done == 1)
            $display("PASS: FSM enters DONE");
        else begin
            $display("FAIL: DONE state test");
            errors = errors + 1;
        end

        // Test 4: DONE transitions back to IDLE
        @(posedge clk);
        #1;

        if (busy == 0 && done == 0 && recovery_flag == 0)
            $display("PASS: FSM returns to IDLE");
        else begin
            $display("FAIL: Return-to-IDLE test");
            errors = errors + 1;
        end

        // Test 5: Inject an illegal state for recovery testing
        // This force is simulation-only and is not synthesized.
        force dut.state = 2'b11;
        #1;

        if (recovery_flag == 1)
            $display("PASS: Illegal state detected");
        else begin
            $display("FAIL: Illegal state detection");
            errors = errors + 1;
        end

        release dut.state;

        // Allow the FSM to recover on the next rising clock edge
        @(posedge clk);
        #1;

        if (busy == 0 && done == 0 && recovery_flag == 0)
            $display("PASS: FSM recovers to IDLE");
        else begin
            $display("FAIL: FSM recovery test");
            errors = errors + 1;
        end

        // Final result
        $display("--------------------------------------");
        if (errors == 0)
            $display("ALL TESTS PASSED");
        else
            $display("TESTS FAILED: %0d", errors);

        $display("--------------------------------------");

        #10;
        $finish;
    end

endmodule


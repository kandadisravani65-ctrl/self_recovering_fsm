`timescale 1ns/1ps

module self_recovering_fsm_tb;

    reg clk = 0;
    reg rst_n = 0;
    reg start = 0;

    wire busy;
    wire done;
    wire recovery_flag;

    self_recovering_fsm dut (
        .clk(clk),
        .rst_n(rst_n),
        .start(start),
        .busy(busy),
        .done(done),
        .recovery_flag(recovery_flag)
    );

    always #5 clk = ~clk;

    initial begin
        $dumpfile("self_recovering_fsm.vcd");
        $dumpvars(0, self_recovering_fsm_tb);

        $display("Time  State  busy done recovery_flag");
        $monitor("%4t   %b      %b    %b       %b",
                 $time, dut.state, busy, done, recovery_flag);

        // Reset the FSM
        #12;
        rst_n = 1;

        // Start normal operation: IDLE -> ACTIVE -> DONE -> IDLE
        #8;
        start = 1;
        #10;
        start = 0;
        #30;

        // Inject illegal state 2'b11 for simulation only
        $display("\nInjecting illegal state at time %0t", $time);
        force dut.state = 2'b11;
        #1;

        if (recovery_flag !== 1'b1)
            $fatal(1, "FAIL: recovery_flag did not assert");

        $display("PASS: illegal state detected; recovery_flag asserted");

        // Release the forced state before the next rising edge.
        // The combinational next-state logic should select IDLE.
        release dut.state;
        #10;

        if (dut.state !== 2'b00)
            $fatal(1, "FAIL: FSM did not recover to IDLE");

        if (recovery_flag !== 1'b0)
            $fatal(1, "FAIL: recovery_flag did not clear");

        $display("PASS: FSM recovered to IDLE; recovery_flag cleared");
        $display("PASS: ALL RECOVERY TESTS PASSED");

        #10;
        $finish;
    end

endmodule

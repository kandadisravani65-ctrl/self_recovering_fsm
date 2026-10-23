create_clock -name core_clk -period 10.0 [get_ports clk]
set_clock_uncertainty 0.1 [get_clocks core_clk]

set_input_delay 1.0 -clock core_clk [get_ports start]
set_input_transition 0.1 [get_ports start]

set_output_delay 1.0 -clock core_clk [get_ports {busy done recovery_flag}]
set_load 0.05 [get_ports {busy done recovery_flag}]

# Asynchronous active-low reset.
# Exclude reset-originating paths from ordinary data-path timing analysis.
# Reset deassertion safety and recovery/removal timing require separate consideration.
set_false_path -from [get_ports rst_n]

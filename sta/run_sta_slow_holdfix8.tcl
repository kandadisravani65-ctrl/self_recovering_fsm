read_liberty /home/vsduser/Desktop/OpenSTA/examples/nangate45_slow.lib
read_verilog synth/self_recovering_fsm_netlist_holdfix8.v
link_design self_recovering_fsm
read_sdc constraints/self_recovering_fsm.sdc
check_setup
report_checks -path_delay max
report_checks -path_delay min
report_worst_slack -max
report_tns
exit

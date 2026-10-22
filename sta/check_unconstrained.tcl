read_liberty /home/vsduser/Desktop/OpenSTA/examples/nangate45_typ.lib
read_verilog synth/self_recovering_fsm_netlist.v
link_design self_recovering_fsm
read_sdc constraints/self_recovering_fsm.sdc

report_checks -unconstrained

exit

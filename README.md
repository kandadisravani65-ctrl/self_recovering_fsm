# Self-Recovering FSM

A Verilog finite state machine with illegal-state detection and
recovery to the IDLE state.

## Features
- IDLE, ACTIVE, and DONE states
- Active-low asynchronous reset
- Busy and done outputs
- Illegal-state detection through recovery_flag
- Default recovery transition to IDLE

## Implementation
- RTL: Verilog
- Physical design flow: OpenLane
- PDK: SKY130A
- Layout output: GDSII

## Physical Verification
The reported OpenLane run completed with:
- Magic DRC violations: 0
- LVS errors: 0
- Antenna violations: 0

## Simulation
The simulation testbench uses Icarus Verilog to exercise normal FSM
operation and inject an illegal state to test recovery.

Run from the simulation directory:

    iverilog -g2012 -o self_recovering_fsm_sim ../self_recovering_fsm.v self_recovering_fsm_tb.v
    vvp self_recovering_fsm_sim

## Files
- self_recovering_fsm.v: RTL source
- config.tcl: OpenLane configuration
- self_recovering_fsm.gds: generated layout
- final_summary_report.csv: flow summary
- simulation/: testbench and waveform
- screenshots/: layout and verification evidence

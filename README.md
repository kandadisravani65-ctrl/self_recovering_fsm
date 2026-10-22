# Self-Recovering Finite State Machine (FSM)

## Project Overview
This project implements a self-recovering Finite State Machine (FSM) using Verilog HDL. The design includes recovery behavior for an illegal state and is verified through simulation, synthesis, and static timing analysis.

## Features
- Three normal states: IDLE, ACTIVE, and DONE.
- Asynchronous active-low reset (`rst_n`).
- Start-controlled transition from IDLE to ACTIVE.
- Automatic transitions from ACTIVE to DONE and DONE to IDLE.
- Recovery to IDLE when an illegal state is encountered.
- `recovery_flag` indicates detection of an illegal state.

## State Transitions

| Current State | Condition | Next State |
|---|---|---|
| IDLE | `start = 0` | IDLE |
| IDLE | `start = 1` | ACTIVE |
| ACTIVE | Any | DONE |
| DONE | Any | IDLE |
| Illegal | Any | IDLE |

## Project Structure

- `rtl/` — Verilog RTL design
- `tb/` — Testbench
- `sim/` — Simulation files and results
- `waveforms/` — VCD waveform files
- `synth/` — Synthesis scripts and mapped netlist
- `sta/` — Static timing analysis scripts
- `constraints/` — Timing constraints (SDC)
- `reports/` — Synthesis and timing reports
- `docs/` — Project documentation

## Verification
The testbench checks reset behavior, normal state transitions, and recovery from an injected illegal state.

**Simulation result:** All six test checks passed.

## Synthesis
The design was synthesized using Yosys and mapped to the educational Nangate45 standard-cell library.

- Mapped standard cells: 8
- Cell area: 15.96 (library area units)
- Cell breakdown:
  - AND2_X1: 1
  - DFFR_X1: 2
  - NOR2_X1: 4
  - NOR3_X1: 1

## Static Timing Analysis
Static timing analysis was performed using OpenSTA with typical, fast, and slow educational library models.

| Library corner | Worst reported setup slack | Reported hold-path slack |
|---|---:|---:|
| Fast | +8.81 ns | -0.05 ns |
| Typical | +8.75 ns | -0.02 ns |
| Slow | +8.36 ns | +0.14 ns |

The reported setup paths meet timing under the configured constraints. Hold timing violations were observed in the fast and typical corners and require further investigation or corrective implementation.

These results are educational estimates, not signoff timing results. The analysis uses example library models and ideal clock assumptions.

## Tools Used
- Verilog HDL
- Icarus Verilog and VVP
- GTKWave
- Yosys
- OpenSTA
- Nangate45 educational standard-cell library
- Ubuntu Linux

## Future Improvements
- Investigate and resolve hold timing violations.
- Review reset timing assumptions and input-delay diagnostics.
- Add further fault-injection and recovery tests.
- Improve timing constraints and validation.
- Publish simulation waveforms and reports with the project.



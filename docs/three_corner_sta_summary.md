# Three-Corner Static Timing Analysis

## Setup

- Tool: OpenSTA 2.4.0
- Corners: Nangate45 fast, typical, and slow Liberty models
- Clock period: 10.0 ns
- Clock uncertainty: 0.1 ns
- Input delay: 1.0 ns on `start`
- Output delay: 1.0 ns on `busy`, `done`, and `recovery_flag`
- `rst_n` is treated as an asynchronous active-low reset and excluded
  from ordinary data-path timing using a false-path constraint.

## Baseline Results

| Corner | Setup slack (ns) | Hold slack (ns) | Hold status |
|---|---:|---:|---|
| Fast | +8.81 | -0.05 | FAIL |
| Typical | +8.75 | -0.02 | FAIL |
| Slow | +8.36 | +0.14 | PASS |

Setup slack is positive in all three corners. Hold timing fails in the
fast and typical corners.

## Hold-Fix Experiments

| Variant | Fast hold (ns) | Typical hold (ns) | Slow hold (ns) |
|---|---:|---:|---:|
| holdfix2 | -0.04 | 0.00 | +0.21 |
| holdfix3 | -0.03 | +0.01 | +0.25 |
| holdfix4 | -0.02 | +0.03 | +0.29 |
| holdfix5 | -0.02 | +0.03 | +0.30 |

The experiments improved hold slack in some corners but did not eliminate
the fast-corner violation. These variants are experiments, not a completed
timing fix.

## Constraint Warning

OpenSTA reports one input port missing `set_input_delay`: `rst_n`.
This is intentional in the current constraint model because reset is
asynchronous and has a false-path exception. The warning is retained in
the results; it should not be hidden by assigning an arbitrary input delay.

Reset deassertion safety and recovery/removal timing are separate concerns
and are not proven by this ordinary data-path analysis.

## Limitations and Follow-Up

These are synthesis-netlist timing estimates, not routed physical-design
results. A physical implementation flow should repair hold violations with
timing-driven delay cells/buffers and then rerun setup and hold analysis
at all required corners. Do not claim hold timing closure until every
required corner passes.

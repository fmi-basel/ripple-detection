# Ripple Detection Toolkit

## Overview
This repository provides MATLAB workflows for integrated analysis of hippocampal ripple events from electrophysiology.


## What This Repository Can Do
1. Detect hippocampal ripple candidates from referenced LFP traces.
2. Filter false-positive ripples using movement/noise intervals.
3. Extract ripple features (timing, duration, amplitude, intrinsic frequency, oscillation count, half-prominence).

## Ripple Detection Steps (Core)
- LFP preprocessing for ripple search: referenced HPC signal, notch around 50 Hz, then bandpass **100-250 Hz**.
- Detection signal: moving-average envelope of `abs(filtered LFP)`.
- Candidate ripple peak: `findpeaks` with:
  - minimum height = `mean(envelope) + 0.21*std(envelope)`
  - minimum peak width = **15 ms**
  - minimum peak distance = **45 ms**
- Ripple start/end: first envelope crossings below `envelope - 2*std(envelope)` before and after each peak.
- Final cleaning: remove events overlapping motion/noise intervals (false-positive filtering step).

# Amplitude and Frequency Modulation Analysis

## Overview
This project analyzes the effects of Amplitude Modulation (AM) and Frequency Modulation (FM) on audio signals. It explores various factors, including noise, nonlinear distortion, and phase mismatches in demodulation.

## Table of Contents
- [Amplitude Modulation Analysis (Q1 Part A)](#amplitude-modulation-analysis-q1-part-a)
- [Effects of Noise on AM Transmission and Recovery (Q1 Part B)](#effects-of-noise-on-am-transmission-and-recovery-q1-part-b)
- [Effects of Nonlinear Distortion on AM Signal (Q1 Part C)](#effects-of-nonlinear-distortion-on-am-signal-q1-part-c)
- [Effects of Phase Mismatch in Synchronous Demodulation (Q1 Part D)](#effects-of-phase-mismatch-in-synchronous-demodulation-q1-part-d)
- [Frequency Modulation of Audio Signal](#frequency-modulation-of-audio-signal)
- [Analysis of FM Signal Distortion Through Non-Linear Systems (Q2 Part B)](#analysis-of-fm-signal-distortion-through-non-linear-systems-q2-part-b)
- [FM Demodulation of Distorted Signals (Q2 Part C, D)](#fm-demodulation-of-distorted-signals-q2-part-c-d)

## Amplitude Modulation Analysis (Q1 Part A)
### Implementation
- Standard AM modulation with a 2000 Hz carrier frequency.
- Signal normalization and carrier wave generation.
- AM equation: `s(t) = (1 + m(t))cos(2πfct)`.

### Results
- FFT analysis confirms frequency shift to ±2000 Hz.
- Expanded amplitude range and DC offset observed.

### Conclusion
Successful AM transformation verified through spectral analysis.

## Effects of Noise on AM Transmission and Recovery (Q1 Part B)
### Implementation
- AM modulation with a 2000 Hz carrier.
- White Gaussian noise added at 10 dB SNR.
- Envelope detection using the Hilbert transform.

### Results
- Noisy demodulated signal has a reduced clarity and noise artifacts.
- FFT shows increased noise floor and spectral leakage.

### Conclusion
10 dB noise degrades AM recovery but preserves intelligibility.

## Effects of Nonlinear Distortion on AM Signal (Q1 Part C)
### Implementation
- AM signal distorted using: `s'(t) = s(t) + 0.2s^3(t) - 0.05s^5(t)`.
- Envelope detection and low-pass filtering applied.

### Results
- Subtle amplitude variations observed.
- Demodulation successfully retrieves original signal characteristics.

### Conclusion
Nonlinear distortion alters signal but does not prevent demodulation.

## Effects of Phase Mismatch in Synchronous Demodulation (Q1 Part D)
### Implementation
- AM modulation at 2000 Hz.
- Phase errors of `π/6`, `π/3`, and `π/2` tested.

### Results
- Increased phase mismatch causes greater signal distortion.
- FFT reveals strong DC components and spectral shifts.

### Conclusion
Precise phase synchronization is crucial for accurate AM recovery.

## Frequency Modulation of Audio Signal
### Implementation
- FM modulation with a carrier frequency of 2000 Hz.
- Frequency deviation: 50 Hz/volt.
- Integrated signal used for modulation.

### Results
- Constant amplitude with frequency variations corresponding to audio input.
- FM is more resilient to amplitude noise compared to AM.

### Conclusion
FM modulation is successfully demonstrated with expected frequency variations.

## Analysis of FM Signal Distortion Through Non-Linear Systems (Q2 Part B)
### Implementation
- FM signal passed through a nonlinear system: `s'(t) = s(t) + 0.2s^3(t) - 0.05s^5(t)`.

### Results
- Harmonics introduced at 3f_c and 5f_c.
- Zero crossings remain intact, ensuring demodulation feasibility.

### Conclusion
FM signals are resilient to distortion but show spectral artifacts.

## FM Demodulation of Distorted Signals (Q2 Part C, D)
### Implementation
- Differentiator and envelope detector method used for demodulation.
- 6th-order Butterworth low-pass filter applied.

### Results
- High-frequency artifacts present.
- Some original signal information is retained but affected by distortion.

### Conclusion
Demodulation succeeds in retrieving basic patterns but introduces artifacts.

## How to Run the Code
1. Load the provided MATLAB scripts.
2. Modify parameters as needed for different test conditions.
3. Run each section and analyze results using the provided plots.

## References
- Signal Processing Toolbox for MATLAB.
- FFT and Hilbert Transform-based demodulation methods.

---
This README provides a summary of the modulation experiments and their analysis. For more details, refer to the full implementation in the code files.


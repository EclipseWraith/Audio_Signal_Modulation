%% Amplitude Modulation with Noise Addition and Envelope Detection
% This script demonstrates amplitude modulation (AM) of an audio signal,
% followed by envelope detection for demodulation. It compares clean and noisy
% scenarios to show the effect of noise on the modulation/demodulation process.

% Load Audio Signal from file
[audioSignal, fs] = audioread('Piyush2023375.wav');
audioSignal = audioSignal(:, 1); % Ensure mono signal by taking first channel if stereo

% Define Parameters
fc = 2000;  % Carrier frequency in Hz
t = (0:length(audioSignal)-1)/fs;  % Time vector based on sampling frequency

% Normalize Audio Signal to prevent overmodulation
audioSignal = audioSignal / max(abs(audioSignal));

% Generate Carrier Signal at frequency fc
carrier = cos(2*pi*fc*t');

% Perform AM Modulation
% Standard AM equation: s(t) = A_c[1 + μ*m(t)]cos(2πf_c*t)
% Here μ = 1 (modulation index) and A_c = 1
AM_signal = (1 + audioSignal) .* carrier;

% Clean Envelope Detection using Hilbert Transform
% The Hilbert transform provides the analytical signal whose magnitude
% corresponds to the envelope of the modulated signal
clean_envelope = abs(hilbert(AM_signal));

% Design a lowpass Butterworth filter to remove high-frequency components
% Cutoff set to carrier frequency to preserve the baseband signal
[b, a] = butter(5, 2*fc/fs, 'low');  % 5th order Butterworth filter

% Apply filter to the envelope to recover the original signal
demodulated_without_noise = filter(b, a, clean_envelope);

% Normalize the demodulated signal for fair comparison
demodulated_without_noise = demodulated_without_noise / max(abs(demodulated_without_noise));

% Add White Gaussian Noise to simulate channel impairments
% 10 dB SNR (Signal-to-Noise Ratio)
noisy_signal = awgn(AM_signal, 10, 'measured');  % 'measured' uses actual signal power

% Envelope Detection for Noisy Signal using the same technique
noisy_envelope = abs(hilbert(noisy_signal));

% Apply the same lowpass filter to recover the noisy demodulated signal
demodulated_with_noise = filter(b, a, noisy_envelope);

% Normalize the noisy demodulated signal for fair comparison
demodulated_with_noise = demodulated_with_noise / max(abs(demodulated_with_noise));

%% Visualization Section

% Figure 1: Signal Comparison in Time Domain
figure('Name', 'Signal Comparison');

% Plot original audio signal
subplot(4,1,1);
plot(t, audioSignal);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot clean modulated signal
subplot(4,1,2);
plot(t, AM_signal);
title('AM Modulated Signal (without noise)');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot noisy modulated signal
subplot(4,1,3);
plot(t, noisy_signal);
title('AM Modulated Signal (With 10dB Noise)');
xlabel('Time (s)');
ylabel('Amplitude');

% Figure 2: Demodulation Comparison
figure('Name', 'Demodulation Comparison');

% Plot original signal again for reference
subplot(3,1,1);
plot(t, audioSignal);
title('Original Signal');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot signal demodulated from clean modulated signal
subplot(3,1,2);
plot(t, demodulated_without_noise);
title('Demodulated Signal (Without Noise)');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot signal demodulated from noisy modulated signal
subplot(3,1,3);
plot(t, demodulated_with_noise);
title('Demodulated Signal (With 10dB Noise)');
xlabel('Time (s)');
ylabel('Amplitude');

% FFT Comparison with proper frequency axis
N = length(audioSignal);
f = fs*(-N/2:N/2-1)/N;
figure('Name', 'FFT Comparison');
subplot(3,1,1);

plot(f, abs(fftshift(fft(audioSignal)/N)));
title('Original Signal FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
subplot(3,1,2);

plot(f, abs(fftshift(fft(demodulated_clean_signal)/N)));
title('Demodulated Clean Signal FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
subplot(3,1,3);

plot(f, abs(fftshift(fft(demodulated_noisy_signal)/N)));
title('Demodulated Noisy Signal FFT');
xlabel('Frequency (Hz)');
ylabel('Magnitude');


disp('Playing Demodulated Noisy Signal');
sound(demodulated_noisy_signal, fs);
pause(length(demodulated_noisy_signal)/fs + 1);

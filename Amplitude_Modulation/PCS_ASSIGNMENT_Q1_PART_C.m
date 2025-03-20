%% Amplitude modulation with non linear distortion

% Load Audio Signal from file
[audioSignal, fs] = audioread('Piyush2023375.wav');
audioSignal = audioSignal(:, 1); % Ensure mono signal by taking only the first channel if stereo

% Parameters
fc = 2000; % Carrier frequency in Hz
t = (0:length(audioSignal)-1)/fs; % Time vector based on sampling frequency

% Normalize Audio Signal to prevent overmodulation
audioSignal = audioSignal / max(abs(audioSignal)); % Scale to range [-1, 1]


% Generate Carrier Signal
carrier = cos(2*pi*fc*t'); % Carrier wave at frequency fc

% Perform AM Modulation
% Standard AM equation: (1 + m(t)) * cos(2πfc*t) where m(t) is the message signal
AM_signal = (1 + audioSignal) .* carrier; % Element-wise multiplication

% This section simulates non-linear distortion that might occur in real systems

% Generate non-linear distorted signal using a polynomial model
% Adding 3rd and 5th order terms to create harmonic distortion
nonlinear_signal = AM_signal + ...
 0.2 * AM_signal.^3 - ... % 3rd order term adds harmonic distortion
 0.05 * AM_signal.^5;    % 5th order term adds further harmonic content

% Envelope detection for distorted signal
nonlinear_envelope = abs(hilbert(nonlinear_signal)); % Hilbert transform extracts the signal envelope
[b, a] = butter(5, 2*fc/fs, 'low');  % 5th order Butterworth filter

% These would typically be lowpass filter coefficients to remove high-frequency components
nonlinear_demodulated_signal = filter(b, a, nonlinear_envelope); % Apply lowpass filter to recover baseband signal
nonlinear_demodulated_signal = nonlinear_demodulated_signal / max(abs(nonlinear_demodulated_signal)); % Normalize output

% Calculate FFTs for frequency domain analysis
N = length(AM_signal); % FFT length
f = fs*(-N/2:N/2-1)/N; % Frequency vector for plotting, centered at zero

% Compute FFTs with proper scaling and shift to center zero frequency
original_fft = fftshift(fft(AM_signal)/N); % FFT of clean modulated signal
nonlinear_fft = fftshift(fft(nonlinear_signal)/N); % FFT of distorted signal
nonlinear_demod_fft = fftshift(fft(nonlinear_demodulated_signal)/N); % FFT of demodulated signal

%% Visualization

% Comprehensive visualization of distortion effects
figure('Name', 'Non-linear Distortion Analysis');

% Time domain signals
subplot(4,1,1);
plot(t, audioSignal);
title('Original Audio Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(4,1,2);
plot(t, AM_signal);
title('Original AM Signal');
xlabel('Time (s)');
ylabel('Amplitude');
% This shows the AM carrier modulated by the audio signal

subplot(4,1,3);
plot(t, nonlinear_signal);
title('Distorted AM Signal');
xlabel('Time (s)');
ylabel('Amplitude');
% Shows how nonlinear distortion affects the modulated signal waveform

subplot(4,1,4);
plot(t, nonlinear_demodulated_signal);
title('Demodulated Distorted Signal');
xlabel('Time (s)');
ylabel('Amplitude');
% Shows the recovered audio after demodulating the distorted signal

figure('Name', 'FFT Analysis');

% Frequency domain signals
subplot(3,1,1);
plot(f, abs(original_fft));
title('FFT of Original AM Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-3*fc, 3*fc]); % Limit view to relevant frequencies
% Should show carrier at ±fc and sidebands

subplot(3,1,2);
plot(f, abs(nonlinear_fft));
title('FFT of Distorted AM Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-3*fc, 3*fc]); % Limit view to relevant frequencies
% Shows additional harmonics at multiples of carrier frequency due to distortion

subplot(3,1,3);
plot(f, abs(nonlinear_demod_fft));
title('FFT of Demodulated Distorted Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-fc, fc]); % Limit view to baseband frequencies

disp('Playing Demodulated Non-linear Distorted Signal');
sound(nonlinear_demodulated, fs);
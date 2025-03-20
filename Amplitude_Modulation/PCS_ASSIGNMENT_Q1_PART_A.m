%% Amplitude Modulation

% Load Audio Signal
[audioSignal, fs] = audioread('Piyush2023375.wav'); % Load audio file and extract sample rate
audioSignal = audioSignal(:, 1);  % Ensure mono signal by taking only first channel

% Parameters
fc = 2000;  % Carrier frequency
t = (0:length(audioSignal)-1)/fs;% Create time vector based on signal length and sample rate

% Normalize Audio Signal
audioSignal = audioSignal / max(abs(audioSignal));% Scale audio to range [-1,1]

% Generate Carrier Signal
carrier = cos(2*pi*fc*t');

% Perform AM Modulation
AM_signal = (1 + audioSignal) .* carrier;

% FFT of Modulated Signal
N = length(AM_signal);% Get number of samples
f = fs*(-N/2:N/2-1)/N;% Create frequency axis centered at zero
AM_fft = fftshift(fft(AM_signal)/N);% Compute normalized FFT and center it

% Plotting Modulation Results
figure('Name', 'AM Modulation Analysis');
subplot(3,1,1);
plot(t, audioSignal);
title('Original Audio Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, AM_signal);
title('AM Modulated Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,3);
plot(f, abs(AM_fft));
title('FFT of Modulated Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');

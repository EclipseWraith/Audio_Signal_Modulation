%% Frequency Modulation with non linear distortion

% Load Audio Signal from the specified WAV file
[audioSignal, fs] = audioread('Piyush2023375.wav');
audioSignal = audioSignal(:, 1); % Ensure mono signal by taking only first channel if stereo

% Parameters
fc = 2000; % Carrier frequency in Hz
kf = 50;   % Frequency deviation constant in Hz/volt (determines modulation depth)
t = (0:length(audioSignal)-1)/fs; % Time vector based on sampling frequency

% Normalize Audio Signal to prevent excessive frequency deviation
audioSignal = audioSignal / max(abs(audioSignal)); % Scale to range [-1, 1]

% Generate FM Signal using the basic FM equation:
% s(t) = A * cos(2πfc*t + 2πkf*∫m(t)dt)

% First, integrate the message signal to convert from FM to PM
% This integration is approximated using cumulative sum divided by sampling frequency
integrated_signal = cumsum(audioSignal)/fs;

% Generate the FM signal
% The instantaneous frequency is fc + kf*m(t)
% The instantaneous phase is 2π*fc*t + 2π*kf*∫m(t)dt
fm_signal = cos(2*pi*fc*t' + 2*pi*kf*integrated_signal);

% Generate non-linear distorted FM signal according to polynomial distortion model:
% s'(t) = s(t) + 0.2s^3(t) - 0.05s^5(t)
% This simulates non-linearities in real-world transmission/amplification systems
distorted_fm = fm_signal + 0.2*fm_signal.^3 - 0.05*fm_signal.^5;
% The cubic term adds 3rd-order harmonics and intermodulation products
% The 5th-order term adds 5th-order harmonics and further intermodulation

% Plot the original and distorted FM signals for comparison
figure('Name', 'FM Signal Distortion');

% Plot original clean FM signal
subplot(3,1,1);
plot(t, fm_signal);
title('Original FM Signal (Zoomed)');
xlabel('Time (s)');
xlim([2 2.02]); % Zoom to a small window to see the waveform details
ylabel('Amplitude');

% Plot distorted FM signal showing effects of non-linearity
subplot(3,1,2);
plot(t, distorted_fm);
title('Distorted FM Signal (Zoomed)');
xlabel('Time (s)');
xlim([2 2.02]); % Same zoom window for comparison
ylabel('Amplitude');
% Note how the non-linearity alters the waveform shape

% Plot the difference (distortion component only)
subplot(3,1,3);
plot(t, distorted_fm - fm_signal);
title('Distortion Component (Zoomed)');
xlabel('Time (s)');
xlim([2 2.02]); % Same zoom window for consistency
ylabel('Amplitude');
% This isolates just the distortion added by the non-linear process

% Frequency domain analysis to visualize spectral effects of distortion
N = length(fm_signal); % FFT length
f = fs*(-N/2:N/2-1)/N; % Frequency vector for plotting, centered at zero

% Compute FFTs with proper scaling and centering
original_fft = fftshift(fft(fm_signal)/N); % FFT of original FM signal
distorted_fft = fftshift(fft(distorted_fm)/N); % FFT of distorted FM signal

% Create a new figure for spectrum analysis
figure('Name', 'FM Distortion Frequency Analysis');

% Plot spectrum of original FM signal
subplot(2,1,1);
plot(f, abs(original_fft));
title('Spectrum of Original FM Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-3*fc, 3*fc]); % Focus on relevant frequency range (carrier and significant sidebands)
% FM naturally creates sidebands at multiples of the modulating frequency

% Plot spectrum of distorted FM signal
subplot(2,1,2);
plot(f, abs(distorted_fft));
title('Spectrum of Distorted FM Signal');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
xlim([-3*fc, 3*fc]); % Same frequency range for direct comparison
% Non-linear distortion creates additional spectral components
% These appear as new harmonics and intermodulation products
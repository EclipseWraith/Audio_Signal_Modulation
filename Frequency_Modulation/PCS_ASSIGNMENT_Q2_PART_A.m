%% Frequency Modulation
% Load Audio Signal from the specified WAV file
[audioSignal, fs] = audioread('Piyush2023375.wav');
audioSignal = audioSignal(:, 1); % Ensure mono signal by taking only first channel if stereo

% Parameters
fc = 2000; % Carrier frequency in Hz
kf = 50;   % Frequency deviation constant in Hz/volt (determines modulation depth)
t = (0:length(audioSignal)-1)/fs; % Time vector based on sampling frequency

% Normalize Audio Signal to prevent excessive frequency deviation
audioSignal = audioSignal / max(abs(audioSignal)); % Scale to range [-1, 1]

%% Part 1: FM Modulation and Signal Generation

% Generate FM Signal using the basic FM equation:
% s(t) = A * cos(2πfc*t + 2πkf*∫m(t)dt)
% where m(t) is the message signal

% First, integrate the message signal to convert from FM to PM
% This integration is approximated using cumulative sum divided by sampling frequency
integrated_signal = cumsum(audioSignal)/fs;

% Generate the FM signal
% The instantaneous frequency is fc + kf*m(t)
% The instantaneous phase is 2π*fc*t + 2π*kf*∫m(t)dt
fm_signal = cos(2*pi*fc*t' + 2*pi*kf*integrated_signal);

% Plot FM signal and original audio for comparison
figure('Name', 'FM Signal Generation');

% Plot original audio signal
subplot(2,1,1);
plot(t, audioSignal);
title('Original Audio Signal (Zoomed)');
xlabel('Time (s)');
ylabel('Amplitude');

% Plot the FM modulated signal
% Note: FM signals maintain constant amplitude but vary in frequency
subplot(2,1,2);
plot(t, fm_signal);
title('FM Modulated Signal (Zoomed)');
xlabel('Time (s)');
xlim([2 2.02]); % Zoom to a small time window to visualize frequency variations
ylabel('Amplitude');
% The zoomed view helps to observe how the carrier frequency changes
% based on the audio signal amplitude
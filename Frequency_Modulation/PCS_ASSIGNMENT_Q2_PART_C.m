%% Frequency modulation and demodulation

% Load Audio Signal from the specified WAV file
[audioSignal, fs] = audioread('Piyush2023375.wav');
audioSignal = audioSignal(:, 1); % Ensure mono signal by taking only first channel if stereo

% Parameters
fc = 2000; % Carrier frequency in Hz
kf = 50;   % Frequency deviation constant in Hz/volt (determines modulation depth)
t = (0:length(audioSignal)-1)/fs; % Time vector based on sampling frequency

% Normalize Audio Signal to prevent excessive frequency deviation
audioSignal = audioSignal / max(abs(audioSignal)); % Scale to range [-1, 1]

% Generate FM Signal
% First, integrate the message signal to convert from FM to PM
% This integration is approximated using cumulative sum divided by sampling frequency
integrated_signal = cumsum(audioSignal)/fs;

% Generate the FM signal using the standard FM equation
% s(t) = A * cos(2πfc*t + 2πkf*∫m(t)dt)
fm_signal = cos(2*pi*fc*t' + 2*pi*kf*integrated_signal);

% Apply non-linear distortion to the FM signal
% This simulates imperfections in transmission/amplification systems
s_distorted = fm_signal + 0.2*fm_signal.^3 - 0.05*fm_signal.^5;
% The polynomial distortion model adds harmonics and intermodulation products

%% FM Demodulation using Differentiation and Envelope Detection

% Step 1: Differentiator (Compute Derivative)
% The derivative of FM signal helps extract frequency variations
dt = 1/fs; % Time step for differentiation
d_s = [diff(s_distorted)/dt; 0]; % Numerical differentiation
% Note: We append a zero at the end to maintain the original signal length

% Step 2: Envelope Detector using Hilbert Transform
% The analytic signal helps extract the envelope which contains the message
analytic_signal = hilbert(d_s); % Create analytic signal (complex)
envelope = abs(analytic_signal); % Take magnitude to get envelope

% Step 3: Low-Pass Filtering to Extract the Modulating Signal
% This removes high-frequency components resulting from the demodulation process
fc_lp = 4000; % Cutoff frequency of lowpass filter (Hz)
[b, a] = butter(6, fc_lp/(fs/2), 'low'); % 6th-order Butterworth filter
% Note: fc_lp/(fs/2) normalizes the cutoff frequency to Nyquist frequency
m_demod = filtfilt(b, a, envelope); % Apply filter with zero phase distortion

% Step 4: Normalize the Demodulated Signal to match original amplitude
m_demod = m_demod / max(abs(m_demod)) * max(abs(audioSignal));
% This scaling helps in fair comparison with the original signal

%% Visualization and Performance Evaluation

% Plot Results for comparison
figure('Name', 'FM Demodulation using Differentiation and Envelope Detection');

subplot(3,1,1);
plot(t, audioSignal);
title('Original Audio Signal'); xlabel('Time (s)'); ylabel('Amplitude'); xlim([2 2.02]);
% Original message signal (reference)

subplot(3,1,2);
plot(t, s_distorted);
title('Distorted FM Signal'); xlabel('Time (s)'); ylabel('Amplitude'); xlim([2 2.02]);
% Showing the distorted FM signal that will be demodulated

subplot(3,1,3);
plot(t, m_demod);
title('Demodulated Signal (Recovered Message)'); xlabel('Time (s)'); ylabel('Amplitude'); xlim([2 2.02]);
% Showing how well the original message was recovered

% Save demodulated signal as audio file for listening tests
audiowrite('demodulated_non_linear.wav', m_demod, fs);
% This allows auditory evaluation of the demodulation quality

%% Performance Metrics Calculation

% Mean Squared Error - Lower is better
mse = mean((audioSignal - m_demod).^2);
% Measures average squared difference between original and recovered signals

% Correlation Coefficient - Higher (closer to 1) is better
corr_coef = corrcoef(audioSignal, m_demod);
% Measures the linear relationship between original and recovered signals

% Signal-to-Noise Ratio in dB - Higher is better
SNR_dB = 10*log10(sum(audioSignal.^2)/sum((audioSignal - m_demod).^2));
% Ratio of signal power to noise power, expressed in decibels

% Display performance metrics
fprintf('Performance Metrics for FM Demodulation with Differentiation and Envelope Detection:\n');
fprintf('MSE: %f\n', mse);
fprintf('Correlation: %f\n', corr_coef(1,2));
fprintf('SNR: %f dB\n', SNR_dB);
% These metrics quantify how well the demodulation process worked

%% Play Original and Demodulated Signal
disp('Playing Original Signal');
sound(audioSignal, fs);
pause(length(audioSignal)/fs + 1);

disp('Playing Demodulated Signal After Non-linear Distortion');
sound(m_demod, fs);

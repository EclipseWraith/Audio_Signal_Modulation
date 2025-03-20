%% Amplitude modulation & Synchronous Demodulation with Phase Mismatch

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


% Define the phase errors to test
phase_errors = [pi/6, pi/3, pi/2]; % Phase errors in radians (30°, 60°, 90°)
phase_labels = {'π/6', 'π/3', 'π/2'}; % Labels for plots and output

% Create a cell array to store demodulated signals for later playback and analysis
sync_demodulated_signals = cell(length(phase_errors), 1);

% Iterate through each phase error and perform synchronous demodulation
for i = 1:length(phase_errors)
    phase_error = phase_errors(i);
    phase_label = phase_labels{i};
    
    % Create local oscillator with phase error
    % The phase error simulates imperfect synchronization between transmitter and receiver
    local_osc = cos(2*pi*fc*t' + phase_error);
    
    % Synchronous demodulation - multiply received signal with local oscillator
    % This is the core operation of synchronous detection
    sync_demod = AM_signal .* local_osc;
    
    % Low-pass filtering to remove high frequency components (2*fc terms)
    % Butterworth filter with cutoff at carrier frequency
    [b, a] = butter(5, 2*fc/fs, 'low'); % 5th order filter, cutoff at 2*fc/fs normalized
    sync_demodulated = filter(b, a, sync_demod); % Apply filter to extract baseband signal
    
    % Normalize output for fair comparison
    sync_demodulated = sync_demodulated / max(abs(sync_demodulated));
    
    % Store demodulated signal for potential playback later
    sync_demodulated_signals{i} = sync_demodulated;
    
    % Create a new figure for each phase error with time domain comparison
    % This helps visualize the effects of phase error on signal quality
    figure('Name', ['Phase Error ' phase_label ' - Time Domain Analysis'], 'Position', [100, 100, 800, 600]);
    
    % Plot original signal for reference
    subplot(3,1,1);
    plot(t, audioSignal);
    title('Original Signal');
    xlabel('Time (s)');
    ylabel('Amplitude');
    
    % Plot demodulated signal to show phase error effects
    subplot(3,1,2);
    plot(t, sync_demodulated);
    title(['Demodulated Signal with Phase Error ' phase_label]);
    xlabel('Time (s)');
    ylabel('Amplitude');
    
    % Plot difference between original and demodulated signals
    % This highlights distortion caused by phase mismatch
    subplot(3,1,3);
    plot(t, audioSignal - sync_demodulated);
    title(['Difference Signal with Phase Error ' phase_label]);
    xlabel('Time (s)');
    ylabel('Amplitude Difference');
    
    % Calculate and display quantitative metrics to measure demodulation quality
    mse = mean((audioSignal - sync_demodulated).^2); % Mean Squared Error
    corr_coef = corrcoef(audioSignal, sync_demodulated); % Correlation coefficient
    fprintf('Phase error: %s - MSE: %f, Correlation: %f\n', ...
        phase_label, mse, corr_coef(1,2));
    % The formula mean((audioSignal - sync_demodulated).^2) calculates the average 
    % of the squared differences between the original audio signal and the demodulated signal.
    
    % Create a new figure for frequency domain analysis
    % This helps visualize spectral effects of phase errors
    figure('Name', ['Phase Error ' phase_label ' - Frequency Domain Analysis'], 'Position', [100, 100, 800, 600]);
    
    % FFT analysis to examine frequency content
    N = length(sync_demodulated);
    f = fs*(-N/2:N/2-1)/N; % Frequency vector centered at 0
    sync_fft = fftshift(fft(sync_demodulated)/N); % FFT of demodulated signal
    audio_fft = fftshift(fft(audioSignal)/N); % FFT of original audio
    
    % Plot FFT of original signal
    subplot(3,1,1);
    plot(f, abs(audio_fft));
    title('FFT of Original Signal');
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    xlim([-fs/4, fs/4]); % Focus on relevant frequencies (limit view)
    
    % Plot FFT of demodulated signal
    subplot(3,1,2);
    plot(f, abs(sync_fft));
    title(['FFT of Demodulated Signal with Phase Error ' phase_label]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude');
    xlim([-fs/4, fs/4]); % Focus on relevant frequencies
    
    % Plot FFT difference to highlight spectral distortion
    subplot(3,1,3);
    plot(f, abs(audio_fft - sync_fft));
    title(['FFT Difference with Phase Error ' phase_label]);
    xlabel('Frequency (Hz)');
    ylabel('Magnitude Difference');
    xlim([-fs/4, fs/4]); % Focus on relevant frequencies
end
%% Audio Playback
% Play original and processed signals
disp('Playing Original Signal');
sound(audioSignal, fs);
pause(length(audioSignal)/fs + 1);

% Play synchronously demodulated signals with different phase errors
for i = 1:length(phase_errors)
    disp(['Playing Synchronously Demodulated Signal with Phase Error: ', ...
           phase_labels{i}]);
    sound(sync_demodulated_signals{i}, fs);
    pause(length(sync_demodulated_signals{i})/fs + 1);
end

for i = 1:length(phase_errors)
    filename = sprintf('sync_demodulated_signal_%d.wav', i);
    
    audiowrite(filename, sync_demodulated_signals{i}, fs);
end
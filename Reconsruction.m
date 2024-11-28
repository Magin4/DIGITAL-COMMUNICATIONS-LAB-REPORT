% Clear workspace and close all figures
clear;
close all;
clc;

% Define signal parameters
tot = 1;              % Total duration (1 second)
td = 0.002;           % Time resolution
t = 0:td:tot;         % Continuous time vector

% Create the original signal
x = sin(2 * pi * t) - sin(6 * pi * t);

% Sampling process
ts = 0.02;                           % Sampling interval
Nfactor = round(ts / td);            % Downsampling factor
xsm = downsample(x, Nfactor);        % Downsample the signal

% Upsample the signal back to original resolution
xsmu = upsample(xsm, Nfactor);       % Upsampled signal

% Calculate spectrum of the upsampled signal
Lffu = 2 ^ nextpow2(length(xsmu));   % Next power of 2 for FFT length
fmaxu = 1 / (2 * td);                % Maximum frequency
Faxisu = linspace(-fmaxu, fmaxu, Lffu); % Frequency axis
xfftu = fftshift(fft(xsmu, Lffu));   % FFT of the upsampled signal

% Plot the spectrum of the sampled signal
figure(1);
plot(Faxisu, abs(xfftu));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Spectrum of Sampled Signal');
grid on;

% Design a low-pass filter (LPF)
BW = 10;                                      % Filter bandwidth (cutoff frequency)
H_lpf = zeros(1, Lffu);                       % Initialize LPF
center = Lffu / 2;                            % Center of frequency axis
H_lpf(center - BW:center + BW - 1) = 1;       % Rectangular filter in frequency domain

% Plot the LPF transfer function
figure(2);
plot(Faxisu, H_lpf);
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Transfer Function of LPF');
grid on;

% Apply LPF to the frequency spectrum
x_recv = xfftu .* H_lpf;                    % Frequency-domain filtering

% Plot the spectrum after LPF
figure(3);
plot(Faxisu, abs(x_recv));
xlabel('Frequency (Hz)');
ylabel('Amplitude');
title('Spectrum of LPF Output');
grid on;

% Inverse FFT to reconstruct the signal
x_recv_time = real(ifft(fftshift(x_recv)));
x_recv_time = x_recv_time(1:length(t));    % Ensure length matches original signal

% Plot original vs. reconstructed signal
figure(4);
plot(t, x, 'r', 'LineWidth', 2);           % Original signal in red
hold on;
plot(t, x_recv_time, 'b--', 'LineWidth', 2); % Reconstructed signal in blue dashed line
xlabel('Time (s)');
ylabel('Amplitude');
title('Original vs. Reconstructed Signal');
legend('Original Signal', 'Reconstructed Signal');
grid on;
% Define parameters for the sampled signal
tot = 1;                % Total time duration (1 second)
ts = 0.02;              % Sampling interval
n = 0:ts:tot;           % Discrete time vector
x_sampled = sin(2*pi*n) - sin(6*pi*n);   % Sampled signal

% Define quantization levels
levels = 16;                           
x_min = min(x_sampled);                % Minimum value of sampled signal
x_max = max(x_sampled);                % Maximum value of sampled signal
step = (x_max - x_min) / levels;       % Step size for quantization

% Quantize the sampled signal
x_quantized = step * round((x_sampled - x_min) / step) + x_min;

% Plot quantized vs. sampled signal
figure;
stem(n, x_sampled, 'r', 'LineWidth', 1.5); hold on;
stem(n, x_quantized, 'b--', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Sampled Signal vs. Quantized Signal');
legend('Sampled Signal', 'Quantized Signal');
grid on;

% Calculate and plot quantization error
quantization_error = x_sampled - x_quantized;
figure;
stem(n, quantization_error, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Error');
title('Quantization Error');
grid on;
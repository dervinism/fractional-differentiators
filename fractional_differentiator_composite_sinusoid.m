% Fractional Differentiator Response to a Composite Sinusoid
% Combines 5 sinusoids with different frequencies, amplitudes, and phases,
% then applies fractional differentiation at several alpha values.
%
% The fractional derivative of A*sin(omega*t + phi) is:
%   A * omega^alpha * sin(omega*t + phi + alpha*pi/2)
%
% By linearity, the fractional derivative of a sum of sinusoids is the
% sum of the fractional derivatives of each component.
clear; clc;

%% ── Parameters ──────────────────────────────────────────────────────────

t = linspace(0, 20, 20000);  % Time vector (0 to 20 seconds, fine resolution)

% Component sinusoids: [frequency_Hz, amplitude, phase_deg]
%   Ten components spanning a range of frequencies and phases
components = [
    0.5,  1.00,    0;    % 0.5 Hz, A=1.00, no phase shift
    1.0,  0.90,   30;    % 1.0 Hz, A=0.90, 30° phase
    1.8,  0.75,  -45;    % 1.8 Hz, A=0.75, -45° phase
    2.5,  0.65,   60;    % 2.5 Hz, A=0.65, 60° phase
    3.5,  0.50, -120;    % 3.5 Hz, A=0.50, -120° phase
    5.0,  0.40,  150;    % 5.0 Hz, A=0.40, 150° phase
    6.5,  0.30,  -90;    % 6.5 Hz, A=0.30, -90° phase
    8.0,  0.25,   20;    % 8.0 Hz, A=0.25, 20° phase
   10.0,  0.20, -160;    % 10.0 Hz, A=0.20, -160° phase
   12.5,  0.15,   75;    % 12.5 Hz, A=0.15, 75° phase
];

n_components = size(components, 1);
freqs_hz   = components(:, 1);
amps       = components(:, 2);
phases_deg = components(:, 3);

omegas     = 2 * pi * freqs_hz;       % Angular frequencies
phases_rad = deg2rad(phases_deg);      % Phases in radians

% Fractional differentiation orders
alphas = [0.25, 0.50, 0.75];

%% ── Build the composite input signal ────────────────────────────────────

x_input = zeros(size(t));
for k = 1:n_components
    x_input = x_input + amps(k) * sin(omegas(k) * t + phases_rad(k));
end

%% ── Compute fractional derivatives ──────────────────────────────────────
% For each alpha, apply the fractional derivative to each component and sum.

fractional_outputs = zeros(length(alphas), length(t));
for j = 1:length(alphas)
    alpha = alphas(j);
    y = zeros(size(t));
    for k = 1:n_components
        A_frac = amps(k) * omegas(k)^alpha;        % Amplitude scaling
        phi_frac = phases_rad(k) + alpha * pi / 2;  % Phase lead
        y = y + A_frac * sin(omegas(k) * t + phi_frac);
    end
    fractional_outputs(j, :) = y;
end

% Normalize each output to match the input's peak amplitude
input_peak = max(abs(x_input));
for j = 1:length(alphas)
    output_peak = max(abs(fractional_outputs(j, :)));
    fractional_outputs(j, :) = fractional_outputs(j, :) * (input_peak / output_peak);
end

%% ── Figure 1: Component sinusoids ───────────────────────────────────────

comp_colors = [
    0.20, 0.60, 0.86;   % blue
    0.90, 0.40, 0.15;   % orange
    0.30, 0.70, 0.30;   % green
    0.65, 0.35, 0.75;   % purple
    0.85, 0.65, 0.12;   % gold
    0.90, 0.20, 0.40;   % crimson
    0.10, 0.75, 0.75;   % teal
    0.55, 0.55, 0.55;   % grey
    0.75, 0.50, 0.20;   % brown
    0.50, 0.80, 0.30;   % lime
];

figure('Color', 'white', 'Position', [50, 450, 667, 400]);
hold on; grid on;
for k = 1:n_components
    comp_signal = amps(k) * sin(omegas(k) * t + phases_rad(k));
    label = sprintf('%.1f Hz, A=%.1f, \\phi=%d°', freqs_hz(k), amps(k), round(phases_deg(k)));
    plot(t, comp_signal, 'Color', comp_colors(k,:), 'LineWidth', 1.5, 'DisplayName', label);
end
plot(t, x_input, 'k-', 'LineWidth', 2.5, 'DisplayName', 'Composite x(t)');

xlabel('Time (s)', 'FontSize', 16, 'FontWeight', 'bold');
ylabel('Amplitude', 'FontSize', 16, 'FontWeight', 'bold');
title('Composite Signal: Sum of 10 Sinusoids', 'FontSize', 14);
legend('Location', 'northeast', 'FontSize', 10);
xlim([18, 20]);
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.4, 'FontSize', 11);

%% ── Figure 2: Fractional derivatives of the composite signal ────────────

% Colors matching the original fractional_differentiator_sinusoid.m style
frac_colors = [
    0.13, 0.55, 0.13;   % green       (alpha = 0.25)
    0.85, 0.85, 0.10;   % yellow      (alpha = 0.50)
    0.10, 0.20, 0.60;   % dark blue   (alpha = 0.75)
];

% Input signal color (orange)
input_color = [0.85, 0.55, 0.05];

figure('Color', 'white', 'Position', [50, 50, 667, 550]);
hold on; grid on;

% Plot the composite input signal
plot(t, x_input, 'Color', input_color, 'LineWidth', 2.5, ...
    'DisplayName', 'Input x(t) — composite');

% Plot fractional derivative responses
for j = 1:length(alphas)
    alpha = alphas(j);
    phase_lead_deg = alpha * 90;
    label = sprintf('\\alpha = %.2f (phase lead = %d° per component)', ...
        alpha, round(phase_lead_deg));
    plot(t, fractional_outputs(j,:), '-', 'Color', frac_colors(j,:), ...
        'LineWidth', 2.0, 'DisplayName', label);
end

% Formatting
xlabel('Time (s)', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Amplitude (arbitrary units)', 'FontSize', 18, 'FontWeight', 'bold');
title({'Fractional Differentiator Response to a Composite Sinusoid:', ...
       'Time-Domain Phase Lead'}, 'FontSize', 14);
legend('Location', 'northeast', 'FontSize', 10);
xlim([18, 20]);
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.4, 'FontSize', 11);

%% ── Print component summary to console ──────────────────────────────────

fprintf('\n=== Composite Sinusoid Components ===\n\n');
fprintf('  %-4s  %-10s  %-10s  %-10s\n', '#', 'Freq (Hz)', 'Amplitude', 'Phase (°)');
fprintf('  %-4s  %-10s  %-10s  %-10s\n', '---', '--------', '---------', '---------');
for k = 1:n_components
    fprintf('  %-4d  %-10.1f  %-10.2f  %-10.0f\n', ...
        k, freqs_hz(k), amps(k), phases_deg(k));
end
fprintf('\n  x(t) = ');
for k = 1:n_components
    if k > 1
        fprintf('       + ');
    end
    fprintf('%.1f·sin(2π·%.1f·t + %d°)', amps(k), freqs_hz(k), round(phases_deg(k)));
    if k < n_components
        fprintf('\n');
    end
end
fprintf('\n\n');

fprintf('=== Fractional Derivative Orders ===\n\n');
for j = 1:length(alphas)
    fprintf('  alpha = %.2f → per-component phase lead = %d°\n', ...
        alphas(j), round(alphas(j) * 90));
end
fprintf('\n');

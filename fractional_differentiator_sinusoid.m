% Fractional Differentiator Response to a Sinusoid
clear; clc;

% Parameters
t = linspace(0, 2, 1000);   % Time vector (0 to 2 seconds)
omega0 = 2 * pi;             % Angular frequency (1 Hz)

% Alpha values and corresponding phase leads
alphas = [0.25, 0.50, 0.75, 1.00];
phase_leads_deg = alphas * 90;  % Phase lead = alpha * 90 degrees

% Amplitudes scale as omega0^alpha
amplitudes = omega0 .^ alphas;

% Colors matching the original plot
colors = [
    0.13, 0.55, 0.13;   % green       (alpha = 0.25)
    0.85, 0.85, 0.10;   % yellow      (alpha = 0.50)
    0.10, 0.20, 0.60;   % dark blue   (alpha = 0.75)
    0.60, 0.15, 0.05;   % dark red    (alpha = 1.00)
];

% Input signal color (orange)
input_color = [0.85, 0.55, 0.05];

figure('Color', 'white', 'Position', [100, 100, 600, 550]);
hold on; grid on;

% Plot input sinusoid x(t) = sin(omega0 * t)
x_input = sin(omega0 * t);
plot(t, x_input, 'Color', input_color, 'LineWidth', 2.0, ...
    'DisplayName', 'Input x(t) = sin(\omega_0 t)');

% Plot fractional derivative responses
line_styles = {'-', '-', '-', '-', '-'};  % all solid lines
for i = 1:length(alphas)
    alpha = alphas(i);
    phase_lead_rad = alpha * pi / 2;
    A = amplitudes(i);

    % Fractional derivative of sin(omega0*t) = A * sin(omega0*t + phase_lead)
    y = A * sin(omega0 * t + phase_lead_rad);

    label = sprintf('\\alpha = %.2f, phase lead = %d°', alpha, round(phase_leads_deg(i)));
    plot(t, y, line_styles{i}, 'Color', colors(i,:), 'LineWidth', 2.0, 'DisplayName', label);
end

% Formatting
xlabel('Time (s)', 'FontSize', 18, 'FontWeight', 'bold');
ylabel('Amplitude (arbitrary units)', 'FontSize', 18, 'FontWeight', 'bold');
title('Fractional Differentiator Response to a Sinusoid: Time-Domain Phase Lead', 'FontSize', 14);
legend('Location', 'northeast', 'FontSize', 11);
xlim([0, 2]);
ylim([-7, 7]);
set(gca, 'GridLineStyle', ':', 'GridAlpha', 0.4, 'FontSize', 11);
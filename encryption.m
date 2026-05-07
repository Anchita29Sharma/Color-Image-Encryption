clc;
clear;

% ---- Take inputs at runtime ----
S_sec_key = input('Enter secret key (S_sec_key): ');
n = input('Enter value of n: ');

x_values = input('Enter x values in vector form [ ] : ');

% ---- Storage ----
fx_values = zeros(size(x_values));

% ---- Apply formula ----
for i = 1:length(x_values)
    fx_values(i) = (S_sec_key - x_values(i)^(1/n))^n;
end

% ---- Create table ----
T = table(x_values', fx_values', ...
    'VariableNames', {'Input_x', 'Encrypted_f(x)'});

disp('Result Table:');
disp(T);

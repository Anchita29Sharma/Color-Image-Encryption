clc;
clear;

% ---- Take inputs at runtime ----
S_sec_key = input('Enter secret key (S_sec_key): ');
n = input('Enter value of n: ');
fx_values = input('Enter encrypted values f(x) in vector form [ ] : ');

% ---- Storage ----
x_decrypted = zeros(size(fx_values));

% ---- Apply CORRECT decryption formula ----
for i = 1:length(fx_values)
    x_decrypted(i) = (S_sec_key - fx_values(i)^(1/n))^n;
end

% ---- Create table ----
T = table(fx_values', x_decrypted', ...
    'VariableNames', {'Encrypted_f_x', 'Decrypted_x'});

disp('Result Table:');
disp(T);

load Guitar.MAT

Fs = 8000;

% figure;
% subplot(1,3,1);
% res = wave2proc;
% N = round(length(res)/10);
% X1 = fft(res(1:N));
% plot([0:N-1]*Fs/N, abs(X1));
% 
% subplot(1,3,2);
% N = round(length(res));
% X2 = fft(res(1:N));
% plot([0:N-1]*Fs/N, abs(X2));
% 
% subplot(1,3,3);
% res = repmat(res, 100, 1);
% N = round(length(res));
% X3 = fft(res(1:N));
% plot([0:N-1]*Fs/N, abs(X3));

res = repmat(wave2proc, 10, 1);
N = length(res);
X = fft(res(1:N));
plot([0:N-1]*Fs/N, abs(X));

Rg = round([200,400]/Fs*N);
[~, base] = max(abs(X(Rg(1):Rg(2))));
base = base + Rg(1) - 2;  % 注意matlab下标是从1开始的
freq = base/N*Fs;
disp(freq);

harmos = abs(X(mod([0:length(X)-1], base) == 0));
harmos = harmos / harmos(2);
disp([[0:12]', harmos(1:13)]);
% disp(harmos(2:13)');




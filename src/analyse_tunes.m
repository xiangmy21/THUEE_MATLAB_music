function [now_amps, idx] = analyse_tunes(wav, Fs, tunes)

if length(wav) < 0.05*Fs
    now_amps = [];
    idx = -1;
    return;
end
wav = repmat(wav, 100, 1);
N = length(wav);
X = abs(fft(wav(1:N)));
% figure;
% plot([0:N-1]*Fs/N, X);
X = X(1:end/2);
[amp, loc] = max(X);
threshold_amp = amp / 2;
ax = [1:length(X)]';
xs = ax(X>threshold_amp & ax<=loc);

for i = 1:length(xs)
    k = loc/xs(i);
    if k < 5 && abs(k/round(k)-1) < 0.05
        res = xs(i);
        break;
    end
end
baseFreq = (res-1)/N*Fs;

diff = abs(tunes - baseFreq);
[~, idx] = min(diff);
baseFreq = tunes(idx);
% disp(baseFreq);

len = floor(Fs/2/baseFreq);
now_amps = zeros([1,len]);
Range = round(res/10);
for i = 1:len
    pos = (res-1)*i+1;
    now_amps(i) = max(X(min(pos-Range,end):min(pos+Range,end)));
end
now_amps = now_amps / now_amps(1);

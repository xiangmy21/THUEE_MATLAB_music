function res = divide_pats(wav, Fs)
% Fs = 8000;
% wav = audioread('fmt.wav');
% len = length(wav);
% subplot(6,1,1);
% plot([0:len-1]/Fs, wav);

y1 = wav.^2;
% subplot(6,1,2);
% plot([0:len-1]/Fs, y1);

hann = barthannwin(round(Fs/10));
y2 = conv(y1, hann);
% subplot(6,1,3);
% plot([0:length(y2)-1]/Fs, y2);

y3 = y2(2:end) - y2(1:end-1);
% subplot(6,1,4);
% plot([0:length(y3)-1]/Fs, y3);

y4 = y3.*(y3>0);
% subplot(6,1,5);
% plot([0:length(y4)-1]/Fs, y4);

[y5, loc] = findpeaks(y4);
tmp = sort(y5, 'descend');
threshold_amp = (tmp(2)+tmp(3))/2/29;
threshold_gap = round(Fs/15);
% disp(threshold_amp);

loc = loc(y5>threshold_amp);
y5 = y5(y5>threshold_amp);
res = [loc(1)];
last = y5(1);

for k = 2:length(y5)
    if loc(k) - res(end) < threshold_gap
        if last < y5(k)
            res = [res(1:end-1), loc(k)];
            last = y5(k);
        end
    else
        res = [res, loc(k)];
        last = y5(k);
    end
end

% subplot(6,1,6);
% plot([0:length(y4)-1]/Fs, y4);
% hold on;
% % disp(res);
% scatter(res/Fs, y4(res), 15);

end

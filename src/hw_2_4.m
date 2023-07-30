clear
close all
Fs = 8000;
wav = audioread('fmt.wav');

tunes = 220 * 2.^([-10:30]/12);
tune_num = length(tunes);
harmo_amps = cell(1,tune_num);

pats = divide_pats(wav, Fs);
for k = 1:length(pats)-1
%     disp(k);
    [now_amps, idx] = analyse_tunes(wav(pats(k):pats(k+1)-Fs/20), Fs, tunes);
    if isempty(harmo_amps{idx})
        harmo_amps{idx} = now_amps;
    else
        harmo_amps{idx} = (now_amps + harmo_amps{idx}) / 2;
    end
end

for i = 1:tune_num
    if isempty(harmo_amps{i})
        for j = 1:max(i-1, tune_num-i)
            if (i>j && ~isempty(harmo_amps{i-j}))
                harmo_amps(i) = harmo_amps(i-j);
                break;
            elseif (i+j<=tune_num && ~isempty(harmo_amps{i+j}))
                harmo_amps(i) = harmo_amps(i+j);
                break;
            end
        end
    end
end

save instrument.mat tunes harmo_amps;
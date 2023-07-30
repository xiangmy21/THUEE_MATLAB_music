function extract_harmonics(wavpath, app)
[wavs, Fs] = audioread(wavpath);

tunes = 220 * 2.^([-10:30]/12);
tune_num = length(tunes);
harmo_amps = cell(1,tune_num);

tracks = size(wavs,2);
for K = 1:tracks  % 可能会有左右声道
    wav = wavs(:,K);
    pats = divide_pats(wav, Fs);
    for k = 1:length(pats)-1
        [now_amps, idx] = analyse_tunes(wav(pats(k):pats(k+1)-Fs/20), Fs, tunes);
        if idx ~= -1
            if isempty(harmo_amps{idx})
                harmo_amps{idx} = now_amps;
            else
                harmo_amps{idx} = (now_amps + harmo_amps{idx}) / 2;
            end
        end
        uiprogressdlg(app.UIFigure,'Title','Please Wait',...
                  'Message','数据处理中','value',(k/length(pats)+K-1)/tracks);
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
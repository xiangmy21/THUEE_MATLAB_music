function play_music(path, baseTune, bpm, shiftRatio)
if nargin < 4
    shiftRatio = 1.1;
end
if nargin < 3
    bpm = 120;
end
if nargin < 2
    baseTune = 0;
end
beatTime = 60/bpm;

baseA = 220;
realBase = baseA * 2^((3+baseTune)/12);  % 1=C调 + baseTune个半音
% 乐曲中用到的基本是低一组和高一组
diffs = [-12,-10,-8,-7,-5,-3,-1,0,2,4,5,7,9,11,12,14,16,17,19,21,23];
baseFreq = [0, realBase*2.^(diffs/12)];

Fs = 44100;

fid = fopen(path, 'r');  % 从json文件中提取音调和拍数
raw = fread(fid, inf);
fclose(fid);
str = char(raw');
data = jsondecode(str);
song = zeros([size(data,1), 2]);
song(:,1) = baseFreq(1+round(data(:,1)*7+data(:,2)));
song(:,2) = data(:,3);

envelope = @(x) (6*x.*exp(-8*x));

load instrument.mat tunes harmo_amps
wav = [];
rows = size(song, 1);
shiftLen = 0;
for k = 1:rows
    f = song(k,1);
    T = beatTime * song(k,2) * shiftRatio;  % 这里对单音做延长
    t = linspace(0, T, Fs*T)';
    if f ~= 0
        harmoConfs = harmo_amps{abs(tunes-f)<1};
        res = sin(2*pi*f*t*(1:length(harmoConfs))) * harmoConfs' .* envelope(t/T) ;
    else
        res = zeros(size(t));
    end

    if shiftLen > length(res)
        wav = [
            wav(1:end-shiftLen);
            wav(end-shiftLen+1:end) + [res; zeros(shiftLen - length(res), 1)];
        ];
        shiftLen = shiftLen - length(res) + round(Fs * beatTime * song(k, 2) * (shiftRatio - 1));
    else
        wav = [
            wav(1:end-shiftLen);
            wav(end-shiftLen+1:end) + res(1:shiftLen);
            res(shiftLen+1:end);
        ];
        shiftLen = round(Fs * beatTime * song(k, 2) * (shiftRatio - 1));
    end
end

sound(wav, Fs);
audiowrite('../results/传说的世界.wav', wav, Fs);
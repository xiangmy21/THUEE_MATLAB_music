baseA = 220;
realBase = baseA * 2^(4/12);  % 1=#C调
% 乐曲中用到的基本是低一组和高一组
diffs = [-12,-10,-8,-7,-5,-3,-1,0,2,4,5,7,9,11,12,14,16,17,19,21,23];
baseFreq = realBase*2.^(diffs/12);
mid = @(x) baseFreq(x+7);  % mid(1) = F
low = @(x) baseFreq(x);
high = @(x) baseFreq(x+14);

Fs = 8192;
beatTime = 60/132;
shiftRatio = 2;
song = [
    0,1; mid(5),0.5; mid(2),0.25; mid(3),0.25; mid(2),1; mid(1),0.5; low(5),0.5;
    mid(5),1; mid(2),1; mid(2),1; mid(1),1;
    0,1; mid(5),0.5; mid(2),0.25; mid(3),0.25; mid(2),1; mid(1),0.5; low(5),0.5;
    low(5),1; mid(5),1; mid(2),1; mid(3),1;
    0,1; mid(1),0.5; mid(1),0.5; mid(1),0.5; mid(5),0.5; mid(2),0.5; mid(1),0.5;
    mid(2),1; mid(2),1; mid(2),1; low(5),1;
    low(4),1; low(3),0.5; low(4),1; mid(1),1; mid(1),0.5;
    mid(3),1; mid(2),0.5; mid(1),1; low(6),0.5; low(5),1;
    0,1; mid(5),0.5; mid(2),0.25; mid(3),0.25; mid(2),1; mid(1),0.5; low(5),0.5;
    mid(5),1; mid(2),1; mid(2),1; mid(1),1;
    0,1; mid(5),0.5; mid(2),0.25; mid(3),0.25; mid(2),1; mid(1),0.5; low(5),0.5;
    mid(5),1; mid(6),1; mid(2),1; mid(3),1;
    0,1; mid(1),0.5; mid(1),0.5; mid(1),0.5; mid(5),0.5; mid(2),0.5; mid(1),0.5;
    mid(2),1; mid(2),1; mid(2),1; low(5),1;
    low(4),1; low(3),0.5; low(4),1; mid(1),1; mid(3),1.5;
    mid(2),0.5; mid(1),1; mid(2),3; 0,1; 0,1;
    mid(5),0.5; mid(6),0.5; mid(6),1; mid(5),1; mid(2),0.5; mid(1),0.5; 
    mid(2),0.5; mid(3),0.5; mid(5),0.5; mid(6),0.5; mid(5),0.5; mid(3),0.5; 0,1;
    mid(3),0.5; mid(2),0.5; mid(2),0.5; mid(1),0.5; mid(1),0.5; mid(2),0.5; mid(3),0.5; mid(5),0.5;
    mid(6),0.5; mid(5),0.5; mid(5),0.5; mid(3),0.5; mid(3),0.5; mid(5),0.5; 0,1;
    mid(6),0.5; mid(5),0.5; mid(5),0.5; mid(3),0.5; mid(3),0.5; low(6),0.5; 0,0.5; low(5),0.5;
    mid(5),0.5; mid(5),0.5; mid(5),1; mid(3),1; 0,0.5; low(5),0.5;
    low(5),0.5; low(6),0.5; mid(1),0.5; mid(2),0.5; mid(3),0.5; mid(5),0.5; mid(6),0.5; mid(5),0.5; 
    mid(2),1; 0,0.5; mid(3),0.5; mid(2),0.5; mid(3),0.5; mid(1),1;
    mid(5),0.5; mid(6),0.5; mid(6),1; mid(5),1; mid(2),0.5; mid(1),0.5; 
    mid(2),0.5; mid(3),0.5; mid(5),0.5; mid(6),0.5; mid(5),0.5; mid(3),0.5; 0,1;
    mid(3),0.5; mid(2),0.5; mid(2),0.5; mid(1),0.5; mid(1),0.5; mid(2),0.5; mid(3),0.5; mid(5),0.5;
    mid(6),0.5; mid(5),0.5; mid(5),0.5; mid(3),0.5; mid(3),0.5; mid(5),0.5; 0,1;
    mid(6),0.5; mid(5),0.5; mid(5),0.5; mid(3),0.5; mid(3),0.5; low(6),0.5; 0,0.5; low(5),0.5;
    mid(5),0.5; mid(5),0.5; mid(5),1; mid(3),1; 0,0.5; low(5),0.5;
    low(5),0.5; low(6),0.5; mid(1),0.5; mid(2),0.5; mid(3),0.5; mid(2),0.5; mid(2),0.5; mid(1),0.5;
    mid(1),4;
];
envelope = @(x) (6*x.*exp(-8*x));

tunes = [];
rows = size(song, 1);
shiftLen = 0;
for k = 1:rows
    f = song(k,1);
    T = beatTime * song(k,2) * shiftRatio;  % 这里对单音做延长
    t = linspace(0, T, Fs*T)';
    harmoConfs = [1, 0.2, 0.1, 0.01];
    res = sin(2*pi*f*t*(1:length(harmoConfs))) * harmoConfs' .* envelope(t/T) ;
    if shiftLen > length(res)
        tunes = [
            tunes(1:end-shiftLen);
            tunes(end-shiftLen+1:end) + [res; zeros(shiftLen - length(res), 1)];
        ];
        shiftLen = shiftLen - length(res) + round(Fs * beatTime * song(k, 2) * (shiftRatio - 1));
    else
        tunes = [
            tunes(1:end-shiftLen);
            tunes(end-shiftLen+1:end) + res(1:shiftLen);
            res(shiftLen+1:end);
        ];
        shiftLen = round(Fs * beatTime * song(k, 2) * (shiftRatio - 1));
    end
end

%plot([0:length(tunes)-1]/Fs, tunes);
sound(tunes, Fs);
audiowrite('../results/1_5.wav', tunes, Fs);


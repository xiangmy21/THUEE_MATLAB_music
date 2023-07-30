baseA = 220;
realBase = baseA * 2^(8/12);  % 1=F调
% 乐曲中用到的基本是低一组和高一组
diffs = [-12,-10,-8,-7,-5,-3,-1,0,2,4,5,7,9,11,12,14,16,17,19,21,23];
baseFreq = realBase*2.^(diffs/12);
mid = @(x) baseFreq(x+7);  % mid(1) = F
low = @(x) baseFreq(x);
high = @(x) baseFreq(x+14);

Fs = 8000;
beatTime = 0.5;
song = [ % 按照2拍分节
    mid(5),1; mid(5),0.5; mid(6),0.5;
    mid(2),2;
    mid(1),1; mid(1),0.5; low(6),0.5;
    mid(2),2;
];

tunes = [];
rows = size(song, 1);
for k = 1:rows
    f = song(k,1);
    T = beatTime * song(k,2);
    t = linspace(0, T, Fs*T)'; % 转置为列向量
    res = sin(2*pi*f*t);
    tunes = [tunes; res];
end

sound(tunes, Fs);
audiowrite('../results/1_1.wav', tunes, Fs);

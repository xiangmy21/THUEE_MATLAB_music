load Guitar.MAT

Fs = 8000;
%plot([0:length(realwave)-1]/Fs, realwave);
%figure;
%plot([0:length(wave2proc)-1]/Fs, wave2proc);
wav = audioread('fmt.wav');
sound(wav, Fs);
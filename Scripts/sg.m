function spectrum = sg(clip,fs)

spectrum = spectrogram(clip,hamming(fs),40000,fs,fs);
spectrum = spectrum(1:1:size(spectrum,1)/2,:);

t = 0:1/fs:((size(clip,1)) * (1/fs));
image('XData',t,'YData',(fs/2):-1:1,'CData',abs(spectrum(end:-1:1,:)));
xlabel('Time (s)');
ylabel('Frequency (Hz)');
xlim([0 ((size(clip,1)) * (1/fs))]);
ylim([0 fs/2]);
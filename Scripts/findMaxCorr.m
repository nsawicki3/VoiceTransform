function shift_amount = findMaxCorr(clip1,clip2)

clip1_spectro = spectrogram(clip1,blackman(44100),10000,44100,44100,'yaxis');
clip2_spectro = spectrogram(clip2,blackman(44100),10000,44100,44100,'yaxis');

C = conv2(clip1_spectro,clip2_spectro);
image(abs(C));
[val,shift_amount] = max(abs(C(1,:)));

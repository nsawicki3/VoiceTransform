function sound2(clip1,clip2,fs)

min_length = min(size(clip1,1),size(clip2,1));
plot(clip1(1:1:min_length,:) + clip2(1:1:min_length,:));
sound(clip1(1:1:min_length,:) + clip2(1:1:min_length,:),fs)


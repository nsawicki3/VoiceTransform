function [clip1_shifted,clip2_shifted,max_index] = alignMaxCorr(clip1,clip2,max_shift_seconds,fs)

max_shift = 44100*max_shift_seconds;
difference_in_samples = max(size(clip1,1),size(clip2,1)) - min(size(clip1,1),size(clip2,1));
skip_amount = 50;

longerclip = [];
shorterclip = [];

correlation_plot = [];

if size(clip1,1) >= size(clip2,1)
    
    longer_clip = [clip1];
    shorter_clip = [zeros(floor(difference_in_samples/2),1); clip2; zeros(ceil(difference_in_samples/2),1)];
    
    longer_clip =  [zeros(floor(max_shift/2),1); longer_clip; zeros(ceil(max_shift/2),1)];
    shorter_clip = [zeros(floor(max_shift/2),1); shorter_clip; zeros(ceil(max_shift/2),1)];
  
    longer_clip_original = longer_clip;
    shorter_clip_original = shorter_clip;
    
    figure(1)
    t = 0:1/fs:((size(longer_clip,1) * (1/fs))-1/fs);
    size(t)
    size(longer_clip)
    plot(t',longer_clip)
    hold on
    plot(t',shorter_clip)
    xlabel('Time (s)')
    title('Before Shift')
    
    
    
    shift_iter = 1;
    max_corr = 0;
    max_location = [];
    while(shift_iter < floor(max_shift/2))
        
        shorter_clip = [zeros(skip_amount,1);shorter_clip(1:1:end-skip_amount,1)];
        tmp_corr = corr(shorter_clip,longer_clip);
        
        if (abs(tmp_corr) > abs(max_corr))
            max_corr = tmp_corr;
            max_location = shift_iter;
            clip1_shifted = longer_clip;
            clip2_shifted = shorter_clip;
        end
        
       correlation_plot = [correlation_plot tmp_corr];
        
       shift_iter = shift_iter + skip_amount
    end
    
elseif size(clip1,1) < size(clip2,1)
    
    longer_clip = clip2;
    shorter_clip = clip1;

end 
 
hold off
figure(2)
plot(t',clip1_shifted)
hold on
plot(t',clip2_shifted)
xlabel('Time (s)')
title('After Shift')

hold off

max_corr
max_index = max_location
max_corr_shift_in_seconds = max_location/fs

figure()
plot(correlation_plot)
title('Correlation as a function of sample shift')

%figure()
%plot(shorter_clip_original - clip2_shifted)
%title('shorter_difference')

%figure()
%plot(longer_clip_original - clip1_shifted)
%clip1_spectro = spectrogram(clip1,blackman(44100),10000,44100,44100,'yaxis');
%clip2_spectro = spectrogram(clip2,blackman(44100),10000,44100,44100,'yaxis');

%C = conv2(clip1_spectro,clip2_spectro);
%image(abs(C));
%[val,shift_amount] = max(abs(C(1,:)));

function merged_clip = replaceSpectraSnippets(source_audio,target_audio,fs)

source_spectrum = sg_full(source_audio,fs);
target_spectrum = sg_full(target_audio,fs);

merged_spectrum = source_spectrum;

slice_size = 25;
correlation_bandwidth = 1000;

close all

figure()
subplot(3,1,1)
image(abs(source_spectrum))
title('source audio')

subplot(3,1,2)
image(abs(target_spectrum))
title('target audio')

time_iter = 1;
while(time_iter < 102)
    
   current_slice = source_spectrum(:,time_iter:time_iter + slice_size - 1);
   current_slice_norm = current_slice ./ max(abs(current_slice));
   
   max_corr = 0;
   max_index = [];
   
   target_iter = 1;
   while(target_iter + slice_size < size(target_spectrum,2))
       
       current_target_slice = target_spectrum(:,target_iter:target_iter + slice_size - 1);
       current_target_slice_norm = current_target_slice ./ max(abs(current_target_slice));
       
       current_corr = corr2(abs(current_slice_norm(1:correlation_bandwidth,:)), abs(current_target_slice_norm(1:correlation_bandwidth,:)));
       if(current_corr > max_corr)
           max_corr = current_corr;
           max_index = target_iter;
       end 
       
       target_iter = target_iter + 1;
   end
   
   merged_spectrum(:,time_iter:time_iter + slice_size - 1) = target_spectrum(:,max_index: max_index + slice_size - 1);
    
   time_iter = time_iter + slice_size
end

subplot(3,1,3)
image(abs(merged_spectrum))
title('merged audio')

[x, t] = istft(merged_spectrum, hamming(fs), hamming(fs), 4100, fs, fs);

figure()
plot(x)

merged_clip = x;

   
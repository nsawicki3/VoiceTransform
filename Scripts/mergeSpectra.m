function [merged_spectra,reconstructed_signal] = mergeSpectra(source_clip,insert_clip,fs,band_start,band_stop)


min_length = min(size(insert_clip,1),size(source_clip,1));

figure()
source_spectrum = sg(source_clip,fs);
title('Source Spectrum')
figure()
insert_spectrum = sg(insert_clip,fs);
title('Insert Spectrum')

Hd_low = designfilt('lowpassfir','FilterOrder',1000,'CutoffFrequency',band_stop, 'DesignMethod','window','Window',{@kaiser,30},'SampleRate',44100);
Hd_high = designfilt('highpassfir','FilterOrder',1000,'CutoffFrequency',band_start, 'DesignMethod','window','Window',{@kaiser,30},'SampleRate',44100);

source_filt_tmp = filter(Hd_low,source_clip);
source_filt = filter(Hd_high,source_filt_tmp);

insert_filt_tmp = filter(Hd_low,insert_clip);
insert_filt = filter(Hd_high,insert_filt_tmp);

[source_shifted,source_filt_shifted,max_index] = alignMaxCorr(source_filt,source_clip,2,44100);
filtered_source = source_shifted(1:1:min_length,:) - source_filt_shifted(1:1:min_length,:);

[source_shifted_toinsert,insert_filt_shifted,max_index] = alignMaxCorr(source_shifted,insert_filt,2,44100);

%reconstructed_signal = filtered_source(1:1:min_length,:) + insert_filt_shifted(1:1:min_length,:);
reconstructed_signal = [zeros(max_index,1); filtered_source(1:1:min_length,:)] + [insert_filt_shifted(1:1:min_length,:);zeros(max_index,1)];


figure()
sg(source_shifted - source_filt_shifted,fs);
title('filtered source')


figure()
sg(insert_filt,fs);
title('filtered source')


figure()
merged_spectra = sg(reconstructed_signal,fs);
title('merged spectra')


% 
% min_length = min(size(source_spectrum,2),size(insert_spectrum,2));
% 
% t = 0:1/fs:((size(source_clip,1)) * (1/fs));
% freqz = 1:2:(fs/2);
% 
% 
% 
% Hd1 = designfilt('bandpassfir', ...
%     'StopbandFrequency1',1/60,'PassbandFrequency1',1/40, ...
%     'PassbandFrequency2',1/4 ,'StopbandFrequency2',1/2 , ...
%     'StopbandAttenuation1',10,'PassbandRipple',1, ...
%     'StopbandAttenuation2',10,'DesignMethod','equiripple','SampleRate',fs);
% 
% 
% 
% 
% 
% band_start_mask = (freqz > band_start);
% band_stop_mask = (freqz < band_stop);
% 
% merged_spectra = source_spectrum;
% %merged_spectra(~(band_start_mask & band_stop_mask),1:1:min_length) = 0;
% merged_spectra(band_start_mask & band_stop_mask,1:1:min_length) = insert_spectrum(band_start_mask & band_stop_mask,1:1:min_length);
% 
% figure()
% image('XData',t,'YData',(fs/2):-1:1,'CData',abs(merged_spectra((end:-1:1),:)))
% title('merged spectra')
% xlim([0 ((size(source_clip,1)) * (1/fs))]);
% ylim([0 fs/2]);
% 
% duplicated_spectrum = [zeros(1,size(merged_spectra,2));merged_spectra;conj(merged_spectra)];
% 
% [x, t] = istft(duplicated_spectrum, hamming(44100), hamming(44100), 4100, 44100, 44100);
% 
% figure()
% plot(x)
% title('reconstructed signal')
% hold on
% plot(source_clip)
% plot(insert_clip)
% hold off
% 
% reconstructed_signal = x;
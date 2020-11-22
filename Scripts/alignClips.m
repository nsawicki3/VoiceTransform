function [source_shifted,target_shifted] = alignClips(source_clip,target_clip,shift_amount)

% shift_amount = findMaxCorr(source_clip,target_clip);

if size(source_clip,1) == size(target_clip,1)
    source_shifted = source_clip;
    target_shifted = target_clip;
end
if size(source_clip,1) > size(target_clip,1)
    source_shifted = source_clip;
    target_shifted = [zeros(shift_amount,1); target_clip];
end
if size(source_clip,1) < size(target_clip,1)
    
    source_shifted = [zeros(shift_amount,1); source_clip];
    target_shifted = target_clip;
end
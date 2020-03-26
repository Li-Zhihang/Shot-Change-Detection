clear
clc
%% parameters
filename = "test.mp4";  % video path
savename = "test_idx.txt";  % where to save index file
win_len = 5000;  % lenght of the computing window
start_time = 0;  % start reading
end_time = 60;  % end of reading

%% initialize
reader = VideoReader(filename);
reader.CurrentTime = start_time;
% check time flags
if end_time < 0
    end_time = reader.Duration;
end
if end_time > reader.Duration || end_time < start_time
    error('End time must less than the video duration and bigger than the start time');
end
savef = fopen(savename, 'w');
fprintf(savef, '%s\r\n%.2f\r\n%.2f\r\n', filename, start_time, end_time);

%% process frames
win_count = 0;
while reader.CurrentTime < end_time
    S = histo(reader, win_len, end_time);
    S_s = smooth(S);
    [pks, loc] = findpeaks(-S_s);
    real_pks = (-pks) < 0.9;
    pks = -pks(real_pks);
    loc = loc(real_pks);
    % add bias
    loc = loc + win_count * win_len * ones('like', loc);
    win_count = win_count + 1;
    % write into file
    for loc_idx = 1: length(loc)
        fprintf(savef, '%d\r\n', loc(loc_idx));
    end
end
%% clean up
fclose(savef);

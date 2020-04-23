clear
clc
%% parameters
filename = "test.mp4";  % video path
savename = "index.txt";  % where to save index file
win_len = 5000;  % lenght of the computing window
start_time = 0;  % start reading, in seconds
end_time = 60;  % end of reading, in seconds. if negative, set to END

%% initialize
reader = VideoReader(filename);
reader.CurrentTime = start_time;
% change time into frames
if end_time < 0
    end_frame = reader.NumFrames;
    end_time = reader.Duration;
else
    end_frame = int16(end_time * reader.FrameRate);
end
start_frame = int16(start_time * reader.FrameRate);
% check time flags
if end_frame > reader.NumFrames || end_frame < start_frame
    error('End time must less than the video duration and bigger than the start time');
end
savef = fopen(savename, 'w');
fprintf(savef, '%s\r\n%.2f\r\n%.2f\r\n', filename, start_time, end_time);

%% process frames
CurrentFrame = start_frame; 
tic
while CurrentFrame < end_frame
    numFrame = min(end_frame - CurrentFrame, win_len);
    S = histo(reader, numFrame);
    S_s = smooth(S);
    [pks, loc] = findpeaks(-S_s);
    real_pks = (-pks) < 0.92;
    pks = -pks(real_pks);
    loc = loc(real_pks);
    % add bias
    loc = loc + double(CurrentFrame) * ones('like', loc);
    CurrentFrame = CurrentFrame + numFrame;
    % write into file
    for loc_idx = 1: length(loc)
        fprintf(savef, '%d\r\n', loc(loc_idx));
    end
end
toc
%% clean up
fclose(savef);

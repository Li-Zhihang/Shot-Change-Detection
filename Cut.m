clear
clc
%% parameters
scriptname = "index.txt";
if_resize = true;
shape_new = [576, 1024];
%output_format = 'MPEG-4';

%% read script
scriptf = fopen(scriptname, 'r');
videofile = fgetl(scriptf);
start_time = str2double(fgetl(scriptf));
end_time = str2double(fgetl(scriptf));
location = fscanf(scriptf, '%d\r\n');
fclose(scriptf);

%% read and write
reader = VideoReader(videofile);
reader.CurrentTime = start_time;

wf_idx = 1;  % write file index
Writer = VideoWriter(strcat("shot_", num2str(wf_idx)));
open(Writer)

loc_ptr = 1;  % location pointer(toward `location array`)
rdr_idx = 1;  % reader index
while reader.CurrentTime < end_time
    frame = readFrame(reader);
    if if_resize
        frame = imresize(frame, shape_new);
    end
    if (loc_ptr <= length(location) && rdr_idx == location(loc_ptr))
        close(Writer)
        wf_idx = wf_idx + 1;
        loc_ptr = loc_ptr + 1;
        Writer = VideoWriter(strcat("shot_", num2str(wf_idx)));
        open(Writer)
    end
    writeVideo(Writer, frame)
    rdr_idx = rdr_idx + 1;
end
close(Writer)

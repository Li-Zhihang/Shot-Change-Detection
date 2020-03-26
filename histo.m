function S = histo(reader, numFrame, end_time)
% parameters
h_bins = 8;
s_bins = 4;
v_bins = 4;
num_of_bins = h_bins + s_bins + v_bins;

% compute histograms
histograms = zeros(num_of_bins, 2);  % previous histo in 1st row, current in 2nd row
S = zeros(numFrame, 1);

early_break = true;
for n = 1: numFrame
    if (reader.CurrentTime >= end_time)
        early_break = true;
        break
    end
    hsv_image = rgb2hsv(imresize(readFrame(reader), [180, 320]));

    h = hsv_image(:, :, 1);
    s = hsv_image(:, :, 2);
    v = hsv_image(:, :, 3);

    h_hist = imhist(h, h_bins);
    h_hist = h_hist ./ sum(h_hist);
    s_hist = imhist(s, s_bins);
    s_hist = s_hist ./ sum(s_hist);
    v_hist = imhist(v, v_bins);
    v_hist = v_hist ./ sum(v_hist);
    
    if (n == 1)
        histograms(: , 1) = [h_hist; s_hist; v_hist] ./ 3;
        S(n) = sum(histograms(: , 1));
    else
        histograms(: , 2) = [h_hist; s_hist; v_hist] ./ 3;
        % find the intersection
        S(n) = sum(min(histograms, [], 2));
        histograms(:, 1) = histograms(:, 2);
    end
end

if early_break
    S = S(1: n -1);
end

end
function S = histo(reader, numFrame)
% Functions for computing hsv histogram and intersections
% parameters
h_bins = 8;
s_bins = 4;
v_bins = 4;
num_of_bins = h_bins + s_bins + v_bins;
shape = [180, 320];

% compute histograms
hists = zeros(numFrame, num_of_bins);  % previous histo in 1st row, current in 2nd row

for n = 1: numFrame
    frames = readFrame(reader);
    hsv_image = rgb2hsv(imresize(frames, shape));

    h = imhist(hsv_image(:, :, 1), h_bins)';
    s = imhist(hsv_image(:, :, 2), s_bins)';
    v = imhist(hsv_image(:, :, 3), v_bins)';

    hists(n, :) = [h, s, v];
    
end

% normalize histograms
hists = hists ./ (3 * shape(1) * shape(2));
% compute intersection
hists_shift = [hists(1, :); hists(1: numFrame - 1, :)];
hists_pair = cat(3, hists, hists_shift);
hists_min = min(hists_pair, [], 3);
S = sum(hists_min, 2);

end
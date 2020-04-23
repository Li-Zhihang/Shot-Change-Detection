import argparse
import time

import cv2.cv2 as cv
import numpy as np
from scipy.signal import find_peaks

h_bins = 8
s_bins = 4
v_bins = 4
num_of_bins = h_bins + s_bins + v_bins


def check_time(args, cap):
    frame_count = cap.get(cv.CAP_PROP_FRAME_COUNT)

    start_frame = int(args.start_sec * cap.get(cv.CAP_PROP_FPS))
    if args.end_sec < 0:
        end_frame = frame_count
    else:
        end_frame = int(args.end_sec * cap.get(cv.CAP_PROP_FPS))

    if end_frame > frame_count:
        end_frame = frame_count
        print('[w] End time greater than the length of the video.')

    if end_frame < start_frame:
        print('[f] End time must larger than start time.')
        raise ValueError

    cap.set(cv.CAP_PROP_POS_FRAMES, start_frame)

    return start_frame, end_frame


def get_intersection(cap, numFrame, shape):
    hists = np.zeros((numFrame, num_of_bins))
    for k in range(numFrame):
        _, img = cap.read()
        img = cv.resize(img, (shape[1], shape[0]))
        hsv_img = cv.cvtColor(img, cv.COLOR_BGR2HSV)

        h, _ = np.histogram(hsv_img[:, :, 0], h_bins, (0, 255))
        s, _ = np.histogram(hsv_img[:, :, 1], s_bins, (0, 255))
        v, _ = np.histogram(hsv_img[:, :, 2], v_bins, (0, 255))

        hists[k] = np.concatenate((h, s, v))

    # compute intersection
    hists = hists / (3 * shape[0] * shape[1])
    hists_shift = hists[[0] + [x for x in range(numFrame - 1)]]
    hists_pair = np.stack((hists, hists_shift), 2)
    hists_min = np.min(hists_pair, axis=2)
    S = np.sum(hists_min, axis=1)

    return S


def smooth_curve(S):
    len_s = len(S)
    nIters = 100
    lamb = 0.1
    k = 0.1

    S_t = np.zeros((nIters, len_s))  # each column stores the new values
    S_t[0] = S

    for t in range(0, nIters - 1):

        delta_e = S_t[t, [x for x in range(1, len_s)] + [len_s - 1]] - S_t[t]
        delta_w = S_t[t, [0] + [x for x in range(len_s - 1)]] - S_t[t]
        c_e = np.exp(-(np.linalg.norm(delta_e) / k) ** 2)
        c_w = np.exp(-(np.linalg.norm(delta_w) / k) ** 2)

        S_t[t + 1] = S_t[t] + lamb * (c_e * delta_e + c_w * delta_w)

    return S_t[-1]


def main(args):
    cap = cv.VideoCapture(args.filename)
    start_frame, end_frame = check_time(args, cap)
    print('Start Reading...')
    with open(args.savename, 'w') as f:
        f.write('{:s}\n{:d}\n{:d}\n'.format(args.filename, start_frame, end_frame))
        start_time = time.time()
        # read frames
        while cap.get(cv.CAP_PROP_POS_FRAMES) < end_frame:
            former_frames = int(cap.get(cv.CAP_PROP_POS_FRAMES))
            numFrame = int(min(end_frame - former_frames, args.win_len))
            S = get_intersection(cap, numFrame, args.shape)
            S = smooth_curve(S)
            loc, _ = find_peaks(-S, -0.92)
            loc = loc + former_frames * np.ones(loc.shape, np.int32)
            # write in
            for k in range(len(loc)):
                f.write('{:d}\n'.format(loc[k]))
        print('time cost: {:2f}'.format(time.time() - start_time))
    print('Done.')
    cap.release()


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--filename', type=str, default='./test.mp4')
    parser.add_argument('--savename', type=str, default='./index.txt')
    parser.add_argument('--win_len', type=int, default=5000)
    parser.add_argument('--start_sec', type=int, default=0)
    parser.add_argument('--end_sec', type=int, default=60)
    parser.add_argument('--shape', type=list, default=(180, 320))
    args = parser.parse_args()

    main(args)

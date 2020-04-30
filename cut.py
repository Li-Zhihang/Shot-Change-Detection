import argparse
import os

from moviepy.video.io.ffmpeg_tools import ffmpeg_extract_subclip


def check_args(args):
    if not os.path.exists(args.video_path):
        raise FileNotFoundError('Cannot reach original video.')
    if not os.path.exists(args.script_path):
        raise FileNotFoundError('Cannot reach dividing script.')

    os.makedirs(args.save_dir, exist_ok=True)

    args.prefix = os.path.splitext(os.path.basename(args.video_path))[0] + '_shot_'


def main(args):

    with open(args.script_path, 'r') as f:
        f.readline()  # video name
        fps = float(f.readline())
        start_frame = int(f.readline())

        prev_cut = start_frame / fps
        shot_count = 1
        while True:  # loop for each shot
            next_cut = f.readline()
            if next_cut == '' or next_cut is None:  # end of script file
                break

            next_cut = int(next_cut) / fps
            name = os.path.join(args.save_dir, args.prefix + str(shot_count) + '.mp4')
            ffmpeg_extract_subclip(args.video_path, prev_cut, next_cut, name)

            shot_count += 1
            prev_cut = next_cut


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--video_path', type=str, default='./test.mp4')
    parser.add_argument('--script_path', type=str, default='./index.txt')
    parser.add_argument('--save_dir', type=str, default='./output/')
    args = parser.parse_args()

    check_args(args)

    main(args)

# Shot Change Detection

A implementation of shot change detection method described in [1].

### Files

| Filename | Functions                                                    |
| -------- | ------------------------------------------------------------ |
| SCD.m    | search for the changing frames                               |
| histo.m  | function: compute the histogram and intersection of each frame |
| smooth.m | function: smooth the intersection curve                      |
| Cut.m    | re-read the video and clip it into fragments                 |

### Usage

Run `SCD.m` and provide the video path, start time, end time and a output path for the indexing script. Start/end time is the time(seconds) from/to which you process your shot change detection.

The script contains the following: 

```
[1] video path (string)
[2] start time (float)
[3] end time (float)
[4-END] changing frame indexes (int)
```

The changing frame indexes count from `start time`.

If you would like to visually check the separating result, run `Cut.m` with the script path. You can choose to resize the video frame.

### References

1. Subhabrata Bhattacharya et. al., "Towards a Comprehensive Computational Model for Aesthetic Assessment of Videos" , Proceedings of the 21st ACM international conference on Multimedia, 2013
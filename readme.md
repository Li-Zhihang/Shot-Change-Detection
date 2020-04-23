# Shot Change Detection

A implementation of shot change detection method described in [1].

## Matlab Version

Matlab codes runs much slower than the python version (see below) due to the inevitable "for loop" when reading frames. It is not recommended on long and high-resolution videos. Nonetheless, the code here can be use for a quick start.

### Files

| Filename | Functions                                                    |
| -------- | ------------------------------------------------------------ |
| SCD.m    | search for the changing frames                               |
| histo.m  | function: compute the histogram and intersection of each frame |
| smooth.m | function: smooth the intersection curve                      |
| Cut.m    | re-read the video and clip it into fragments                 |

### Usage

Run `SCD.m` and provide the video path, start time, end time and a output path for the indexing script. 

The script contains the following: 

```
[1] video name (string)
[2] start frame (int)
[3] end frame (float)
[4-END] changing frame absolute indexes (int)
```

The changing frame indexes count from `start time`.

If you would like to visually check the separating result, run `Cut.m` with the script path. You can choose to resize the video frame.



## Python Version

### Requirement

```
opencv-python
numpy
scipy
```

### Usage

To get dividing script

```bash
python SCD.py --filename {$yourvideo} --savename {$outputscript}
```

other arguments

```  
--start_sec {$starttime}  // in seconds
--end_sec {$endtime}      // in seconds, negetive value->end of the video
--shape {$yourshape}      // resizing shape, default is 180x320
--win_len {$yourwinlen}   // window length, default is 5000
```



## References

1. Subhabrata Bhattacharya et. al., "Towards a Comprehensive Computational Model for Aesthetic Assessment of Videos" , Proceedings of the 21st ACM international conference on Multimedia, 2013
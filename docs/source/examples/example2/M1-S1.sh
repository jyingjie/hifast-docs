#!/bin/bash

# enable **/
shopt -s globstar

# only need input chunk *0001.fits
files="$(ls RAW_data/*/*/*M01*W_0001.fits)"
# check files
printf "${files}"
echo

# commands
#     "python -m hifast.sep file.hdf5 ..." only supports one file
# run "python -m hifast sep -p 3 file1.hdf5 file2.hdf5 file3.hdf5  ..." run multiple files and 3 files in parallel.
python -m hifast pos_swi -p 5 \
    $files \
   -d 4 -m 4 -n 36 \
   --frange 1378  1410  \
   --smooth gaussian --s_sigma 5 \
   --noise_mode high \
   --t_src 120 --t_ref 120 --t_change 30 --n_repeat 1 \
   --only-off True \
   --outdir output/%[project]s/%[date]s

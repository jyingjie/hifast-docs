#!/bin/bash

# enable **/
shopt -s globstar

# only need input chunk *0001.fits
files="$(ls -v output2/*/202*/*M01*-sw_nobld-flux.hdf5)"
# check files
printf "${files}"
echo
# commands
python -m hifast pos_swi_2 -p 5 \
    $files \
   --frange 1378  1400  \
   --t_src 120 --t_ref 120 --t_change 30 --n_repeat 1 \
   --only-off True
   
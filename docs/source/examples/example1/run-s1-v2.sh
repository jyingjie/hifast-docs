#!/bin/bash

# enable **/
shopt -s globstar
# 1. Temperature calibration
echo "Temperature calibration:"
# only need input chunk *0001.fits
files="$(ls RAW_data/M33_OTF/20210731/M33_OTF_1_*W_0001.fits)"
# check files
printf "${files}"
echo
# commands
# python -m hifast sep -p 3 同时执行5个 python -m hifast.sep
python -m hifast sep -p 3 \
    $files \
   -d 4 -m 4 -n 596 --step 1 \
   --frange 1350 1450 \
   --smooth gaussian --s_sigma 2 \
   --check_cal A --pcal_vary_lim_bin 0.02 \
   --merge_pcals False --cal_dis_lim 2 \
   --save_pcals True \
   --outdir 'output/%(project)s/%(date)s'

# RA-DEC
# # only need beam 01 specs_T.hdf5 file
python -m hifast radec **/*-M01*-specs_T.hdf5

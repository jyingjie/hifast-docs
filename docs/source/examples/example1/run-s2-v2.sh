#!/bin/bash

# enable **/
shopt -s globstar

files="$(ls output/M33_OTF_1_MultiBeamOTF/20210731/M33_OTF_1_MultiBeamOTF-M*_W-*-specs_T.hdf5)"
# check fpatten
printf "${files}"
echo

# using hifast.sh to run multi files
# commands
commands=$(cat <<EOF
python -m hifast.flux  | 
python -m hifast.bld  | --nproc 5 --frange 1400 1440 \
                        --method PLS-asym2 --lam 1e9 \
                        --s_method_freq gaussian --s_sigma_freq 3 \
                        --njoin 50 \
                        --exclude_type auto2
# The `hifast.bld` process below can be replaced by using the `--post_method` parameter in the previous `hifast.bld` command
python -m hifast.bld  | --nproc 5 \
                        --method poly-asym2 --deg 2 \
                        --s_method_freq gaussian --s_sigma_freq 1 \
                        --exclude_type auto2
python -m hifast.rfi  | -c conf/S2-rfi.ini
# `--no_bld True` to keep baseline and only remove standing wave
python -m hifast.sw   | -c conf/S2-sw.ini --no_bld True
# sustract "ref" observation
python -m hifast.ref | --method MedMed --nsection 11 --npart 8 \
                       --post_method poly-asym2 --post_deg 3 \
                       --post_s_method_freq gaussian --post_s_sigma_freq 1 \
                       --post_exclude_type auto2
python -m hifast.multi | --vtype optical --frame LSRK --merge_polar True --replace_rfi True
EOF
)
# check commands
echo "commands: ""$commands"
# run multiple files
hifast.sh "$files" -c "$commands" -n 5

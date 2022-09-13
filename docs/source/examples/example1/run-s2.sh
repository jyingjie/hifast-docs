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
                        --s_method_t gaussian --s_sigma_t 11 \
                        --exclude_type auto2
python -m hifast.bld  | --nproc 5 \
                        --method poly-asym2 --deg 2 \
                        --s_method_freq gaussian --s_sigma_freq 1 \
                        --exclude_type auto2
python -m hifast.rfi  | -c conf/S2-rfi.ini
python -m hifast.sw   | -c conf/S2-sw.ini
python -m hifast.multi | --vtype optical --frame LSRK --merge_polar True --replace_rfi True
EOF
)
# check commands
echo "commands: ""$commands"
# run multiple files
hifast.sh "$files" -c "$commands" -n 5

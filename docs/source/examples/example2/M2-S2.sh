#!/bin/bash

# enable **/
shopt -s globstar

files="$(ls output2/*/202*/*M01*-specs_T.hdf5)"
# check fpatten
printf "${files}"
echo

# using hifast.sh to run multi files
# commands
commands=$(cat <<EOF
# limit frange again
python -m hifast.bld  | --nproc 5 \
                        --frange 1369 1419 \
                        --method PLS-asym2 --lam 1e9 \
                        --njoin 40 \
                        --s_method_freq gaussian --s_sigma_freq 3 \
                        --exclude_type auto2 \
                        --post_method poly-asym2 --post_deg 3 \
                        --post_s_method_freq gaussian --post_s_sigma_freq 3 \
                        --post_exclude_type auto2
python -m hifast.sw   | -c conf/S2-sw.ini --nobld True
python -m hifast.flux  |  
EOF
)
# check commands
echo "commands: ""$commands"
# run multiple files
hifast.sh "$files" -c "$commands" -n 4

#!/usr/bin/env bash

# Enable recursive globbing to allow ** to match all files and directories recursively
shopt -s globstar

# Step 1: Temperature Calibration
# Description: This step involves calibrating the temperature of the spectra.
echo "Temperature calibration:"
# Select the first chunk of each beam
# Note: Assumes naming convention for files as M33_OTF_1_*W_0001.fits where * is a wildcard
files="$(ls RAW_data/M33_OTF/20210731/M33_OTF_1_*W_0001.fits)"
# Display the selected files to verify correct selection
printf "${files}\n"

# Run temperature calibration on selected files
# Note: "python -m hifast.sep file.hdf5 --para1 --para2" processes only one HDF5 file at a time.
#       "python -m hifast sep -p 2 file1.hdf5 file2.hdf5 file3.hdf5 --para1 --para2" allows multiple files to be processed at the same time. 
python -m hifast sep -p 3 \
    $files \
    -d 4 -m 4 -n 596 --step 1 \
    --frange 1400 1440 \
    --smooth gaussian --s_sigma 2 \
    --check_cal A --pcal_vary_lim_bin 0.02 \
    --merge_pcals True --method_merge median --method_interp linear \
    --save_pcals True \
    --outdir output_1/%[project]s/%[date]s

# The output files from this step will be named following the pattern "*-specs_T.hdf5"

# Step 2: Generate RA-DEC File
# Description: This step generates a file containing Right Ascension (RA) and Declination (DEC) information.
# Note: This step only need input the Beam 01 of "*-specs_T.hdf5".
python -m hifast radec output_1/**/*-M01*-specs_T.hdf5 --ky_dir RAW_data/KY/ --plot

# Step 3: Process Baseline, Standing Wave, RFI (Radio Frequency Interference), etc.
# Description: This step involves further processing of the calibrated files to address baseline,
# standing waves, RFI, and other potential issues.
# Note: This step processes all "*-specs_T.hdf5" files.
files="$(ls output_1/**/*-M*-specs_T.hdf5)"
# Display the selected files to ensure correctness
printf "${files}\n"

# Define processing commands for hifast.sh script to handle multiple files and processes
# This block defines a pipeline of hifast module commands to process the files
# Each line represents a step in the processing chain, configured with specific parameters
commands=$(cat <<'EOF'
python -m hifast.flux  | 
python -m hifast.bld  | --nproc 5 --frange 1400 1440 \
                        --method PLS-asym2 --lam 1e8 \
                        --njoin_t 20 \
                        --s_method_freq gaussian --s_sigma_freq 3 \
                        --exclude_type auto2 \
                        --post_method poly-asym2 --post_deg 3 \
                        --post_exclude_type auto2
python -m hifast.rfi  | -c conf/S2-rfi.ini
# use `--nobld True` to keep baseline and only remove standing wave
python -m hifast.sw   | --nobld True -c conf/S2-sw.ini
python -m hifast.bld  | --nproc 5 \
                        --method PLS-asym2 --lam 1e8 \
                        --s_method_t gaussian --s_sigma_t 20 \
                        --s_method_freq gaussian --s_sigma_freq 3 \
                        --exclude_type auto2 \
                        --post_method poly-asym2 --post_deg 2 \
                        --post_exclude_type auto2
python -m hifast.multi | --vtype optical --frame LSRK --merge_polar True --replace_rfi True
EOF
)

# Execute the hifast.sh script with the defined commands to process multiple files concurrently
# -n 5 specifies the number of processes to run in parallel
hifast.sh "$files" -c "$commands" -n 5

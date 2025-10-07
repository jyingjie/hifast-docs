#!/usr/bin/env bash

# Enable recursive globbing to allow ** to match all files and directories recursively.
shopt -s globstar

# --- Step 1: Temperature Calibration ---
# Calibrate the temperature for the raw spectrometer data.
echo "Starting Step 1: Temperature Calibration..."

# Select the first FITS file for each beam as input.
# Note: Assumes naming convention M33_OTF_1_*W_0001.fits
files="$(ls RAW_data/M33_OTF/20210731/M33_OTF_1_*W_0001.fits)"
printf "Selected files for calibration:\n${files}\n"

# Run hifast.sep to perform temperature calibration.
# This converts the raw data into calibrated HDF5 files.
# Note: "-p 3" enables parallel processing with 3 cores.
python -m hifast sep -p 3 \
    $files \
    -d 4 -m 4 -n 596 --step 1 \
    --frange 1400 1440 \
    --smooth gaussian --s_sigma 2 \
    --check_cal A --pcal_vary_lim_bin 0.02 \
    --merge_pcals True --method_merge median --method_interp linear \
    --save_pcals True \
    --outdir output_1/%[project]s/%[date]s

# The output files from this step will be named with the suffix "-specs_T.hdf5".

# --- Step 2: Coordinate Calculation ---
# Generate celestial coordinates (RA, Dec) for the calibrated data.
echo "\nStarting Step 2: Coordinate Calculation..."

# Run hifast.radec on the calibrated file for Beam 01.
# Note: Only the M01 beam file is needed, as it contains the necessary trajectory
# information to calculate coordinates for all other beams.
python -m hifast radec output_1/**/*-M01*-specs_T.hdf5 --ky_dir RAW_data/KY/ --plot

# --- Step 3: Data Processing Pipeline ---
# Process the temperature-calibrated data to handle baseline, standing waves, and RFI.
echo "\nStarting Step 3: Data Processing Pipeline..."

# Select all temperature-calibrated HDF5 files for further processing.
files="$(ls output_1/**/*-M*-specs_T.hdf5)"
printf "Selected files for pipeline processing:\n${files}\n"

# Define the processing pipeline using a series of hifast modules.
# This multi-line string defines the sequence of commands that hifast.sh will execute.
commands=$(cat <<'EOF'
# Apply flux calibration.
python -m hifast.flux  | 
# Perform a first-pass baseline removal.
python -m hifast.bld  | --nproc 5 --frange 1400 1440 \
                        --method PLS-asym2 --lam 1e8 \
                        --njoin_t 20 \
                        --s_method_freq gaussian --s_sigma_freq 3 \
                        --exclude_type auto2 \
                        --post_method poly-asym2 --post_deg 3 \
                        --post_exclude_type auto2
# Flag Radio Frequency Interference (RFI).
python -m hifast.rfi  | -c conf/S2-rfi.ini
# Remove standing waves. Using ``--nobld True`` preserves the baseline from the
# previous step, meaning this command only removes the standing wave component.
python -m hifast.sw   | --nobld True -c conf/S2-sw.ini
# Perform a second, more refined baseline removal after the standing wave is gone.
# This two-step baseline removal is effective for extended sources where a clean
# off-source reference is not available. For point sources, ``hifast.ref`` is used instead (see run_case2.sh).
python -m hifast.bld  | --nproc 5 \
                        --method PLS-asym2 --lam 1e8 \
                        --s_method_t gaussian --s_sigma_t 20 \
                        --s_method_freq gaussian --s_sigma_freq 3 \
                        --exclude_type auto2 \
                        --post_method poly-asym2 --post_deg 2 \
                        --post_exclude_type auto2
# Correct velocities, merge polarizations, and replace RFI flags.
python -m hifast.multi | --vtype optical --frame LSRK --merge_polar True --replace_rfi True
EOF
)

# Execute the pipeline on all selected files using hifast.sh.
# ``-n 5`` runs 5 processes in parallel for efficiency.
echo "\nExecuting pipeline with hifast.sh..."
hifast.sh "$files" -c "$commands" -n 5

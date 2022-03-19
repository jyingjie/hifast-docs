#!/bin/bash
# "=" should not surround by space in variable assignment
fpart="../original_data/M33_OTF/20210731/M33_OTF_1_MultiBeamOTF-M"

#for i in {01..01}
# or 
for i in $(seq -f "%02g" 01 01)
do
python -m hifast.sep "${fpart}${i}_W_0001.fits" -d 4 -m 4 -n 596 --step 5 --frange 1405 1435 \
                                --smooth gaussian --s_sigma 5 --outdir ./data --check_cal A
done

python -m hifast.radec "./data/M33_OTF_1_MultiBeamOTF-M01_W-20210731-specs_T.hdf5" --plot

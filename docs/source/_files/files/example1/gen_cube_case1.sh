#!/usr/bin/env bash

python -m hifast.cube \
     --outname cube.fits  \
     -m gaussian  --type3 vopt \
     --range3 -1000 2000 \
     --share-mem False --step 19 --nproc 4 \
     output_1/M33_OTF_1_MultiBeamOTF/*/*fc.hdf5

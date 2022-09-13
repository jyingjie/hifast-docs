#!/bin/bash

python -m hifast.cube \
     --outname cube.fits  \
     -m bessel_gaussian  --type3 vopt \
     --range3 -1000 2000 \
     --share-mem False --step 38 --nproc 40 \
     output/M33_OTF_1_MultiBeamOTF/*/*fc.hdf5

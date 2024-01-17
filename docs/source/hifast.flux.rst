``hifast.flux`` Flux Calibration
=====================================

``hifast.flux``: Flux Calibration from Teff(K) to Flux(Jy/beam)

- Example

   .. code-block:: bash

      python -m hifast.flux data/XXX_arcdrift-M01_F-specs_T.hdf5

- This command inputs an HDF5 file that hasn't been flux calibrated. 
  For flux calibration, the program currently defaults to the Gain-zenith
  angle function relationship outlined in https://arxiv.org/abs/2002.01786.
  
- Additional Parameters:

   - ``--cali_fname``: Use this parameter to specify the Gain value obtained
     from the calibration source on the same day (Calibration source
     processing is under testing and will be added in future versions).

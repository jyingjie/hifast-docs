``hifast.radec`` Coordinate Transformation
==========================================

``hifast.radec`` is for transforming celestial coordinates (RA, Dec) from the the trajectory of phase centre of the feed stored in a Office Open XML Workbook file(``.xlsx``, feed cabin file).

Example Usage
--------------------

  .. code-block:: bash

     python -m hifast.radec data/XXX_arcdrift-M01_F-specs_T.hdf5
     # Alternatively,
     python -m hifast.radec XXX_arcdrift_11_2020_XX_XX_22_54_09_000.xlsx

- Supported File Types:
  
   - Input the path of an ``hdf5`` file created by ``hifast.sep``. **Only the file for the M01 beam is required** as it contains celestial coordinates for other beams as well.
     According to the file name and ``mjd`` in the file to find the corresponding feed cabin file (.xlsx) and then calculate the RA and Dec of each spectrum.
   
     The program sequentially searches for these directories:
   
     - ``your_HOME_dir/KY/`` (create this directory for local processing; it's unnecessary on the FAST server).
     - ``/data/hw1/FAST/KY/``
     - ``/data31/KY/`` (FAST server directories for feed files).
   
     The program then searches for the relevant feed cabin file in the first directory it finds. It calculates the RA-DEC from the feed file.
     Since the spectral records' time sampling points differ from those in the feed file, interpolation is used to derive the final coordinates of the spectrum.
 
   - Input the path of a feed cabin file with a ``.xlsx`` extension. This is used to calculate the RA and Dec corresponding to the trajectory of feed cabin.



Parameters
----------

- Key Parameters:

   - ``--ky_files``: Manually specify the path of the feed file if the program automatically locates it. You can specify one or multiple files.
   - ``--tol``: Normally, the feed file's time range should cover that of the observed spectral lines. Use ``--tol 5`` to allow extrapolation for RA and Dec when there is a 5-second gap in the celestial file records. Note that spectral data from extrapolated coordinates should be discarded.
   - ``--outdir``: Specify the output file's directory. For ``.hdf5`` file inputs, it defaults to the input file's directory; for ``.xlsx`` inputs, it defaults to the program's run path.
   - ``--ky_fixed``: For early Drift scans where the feed file only recorded a few minutes of feed cabin position, this parameter calculates Right Ascension and Declination for the entire spectrum based on these few minutes. Caution: The feed may not have remained stable during the drift, so this could affect accuracy.
   - ``--plot``: This option plots and saves a figure of RA and Dec.

   .. note::
       
       If your computer does not have internet access, automatic download of IERS data will fail, leading to errors like:
       
       *   ``IERSStaleWarning: leap-second file is expired.``
       *   ``astropy.utils.iers.iers.IERSRangeError: (some) times are outside of range covered by IERS table.``
       *   ``urllib.error.URLError: <urlopen error [Errno -2] Name or service not known>``
       
       To resolve this, please use the `IERS Offline Cache Updater <https://github.com/jyingjie/iers_cache>`_ tool to manually update the offline cache.

- For additional parameter information, use: ``python -m hifast.radec -h | more``.

Output
------

The output file, named with the “-radec” suffix added to the input file, stores the celestial coordinates data. It can be read with h5py. Example:

  .. code-block:: python

     import h5py
     f = h5py.File('data/XXX_arcdrift-M01_F-specs_T-radec.hdf5', 'r')
     S = f['S']
     print(S.keys())
     S['mjd'][:]

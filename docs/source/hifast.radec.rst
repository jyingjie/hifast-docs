``hifast.radec`` Coordinate Calculation
=======================================

.. program:: python -m hifast.radec

Overview
--------

The ``hifast.radec`` module calculates the celestial coordinates (Right Ascension and Declination) for each spectrum in your data. It matches the timestamp of the spectral data with the telescope's feed cabin trajectory log (KY files) to compute coordinates for **all 19 beams** simultaneously.

Processing Workflow
-------------------

1. **Input Data (Two Modes)**
   The module accepts two types of input files, determining the processing mode:

   *   **HDF5 File (Spectral Data)**:
       Pass an HDF5 file (e.g., ``data/*_specs_T.hdf5``) using the ``fname`` argument.
       
       *   **Usage**: The module **only reads the time information** (``S/mjd``) from this file. It does *not* rely on any existing coordinate columns.
       *   **Output**: It generates a new file containing RA/DEC for **all 19 beams**, derived from the feed cabin position and the fixed geometry of the receiver.

   *   **Excel File (Feed Cabin Log)**:
       Pass a KY file (``.xlsx``) directly.
       
       *   **Usage**: Calculates the RA/DEC trajectory of the feed cabin itself.
       *   **Output**: Useful for inspecting the telescope's tracking path independent of spectral data.

2. **Locating Feed Cabin Data (KY Files)**
   To calculate coordinates, the program needs the telescope's position log, known as "KY files" (Excel format).
   
   *   **Automatic Search**: By default, it searches for matching KY files in standard directories, **checking ``~/KY`` first**, followed by others like ``/data/hw1/FAST/KY`` and ``/data31/KY``. You can customize the search directory with :option:`--ky_dir`.
   *   **Manual Specification**: If your KY files are in a non-standard location, you can explicitly list one or more of them using :option:`--ky_files`.

3. **Coordinate Calculation**
   The module interpolates the feed cabin position to the exact time of each spectrum.
   
   *   **Backend**: You can choose between ``astropy`` (default) and ``erfa`` for the coordinate transformation using :option:`--backend`.
       
       *   **Astropy (Recommended)**: Automatically downloads and applies Earth orientation parameters (including **dUT1** and polar motion). If you use this backend, the manual :option:`--dUT1` argument is ignored.
       *   **Erfa**: Requires manual specification of :option:`--dUT1` if special requirement is needed.
       
   *   **Extrapolation**: Ideally, the feed cabin data (KY file) should fully cover the time range of your spectral data. However, small timing offsets can occur.
       
       *   :option:`--tol` (default: 1 second) defines the **maximum allowed time gap** for extrapolation.
       *   If the spectral data starts slightly before or ends slightly after the KY data records (within this tolerance), the coordinates are extrapolated linearly.
       *   **is_extrapo**: The output file will contain a boolean dataset named ``is_extrapo`` marking these extrapolated points.
       *   **Handling in Downstream Analysis**: When processing with ``hifast.multi``, you can use the parameter ``--mask_extrapo True`` to automatically mask these extrapolated data points as NaN.
       *   If the gap exceeds this tolerance, the program will **raise an error** (unable to find a matching KY file).
   *   **Environmental Corrections**: Parameters like :option:`--temperature`, :option:`--phpa` (pressure), and :option:`--humidity` are used for refraction corrections.

4. **Output**
   The result is a new HDF5 file (suffix ``-radec.hdf5``) containing the calculated RA and DEC columns.
   
   *   **Plotting**: Use :option:`--plot` to generate a PDF showing the telescope's trajectory during the observation.

Examples
--------

.. code-block:: bash

   # Basic usage (auto-search for KY files)
   python -m hifast.radec data/observation.hdf5

   # Manually specifying a KY file and enabling plotting
   python -m hifast.radec data/observation.hdf5 --ky_files data/feed_log.xlsx --plot

   # Using a custom tolerance for data with gaps
   python -m hifast.radec data/observation.hdf5 --tol 5.0

   # Processing a KY file directly (to inspect the feed trajectory)
   python -m hifast.radec data/feed_log.xlsx --plot

Full Parameter Reference
------------------------

.. tip::
   You can also view the full list of parameters and their descriptions directly in your terminal by running:
   
   .. code-block:: bash
   
      python -m hifast.radec --help

.. argparse::
   :module: hifast.radec
   :func: parser
   :prog: python -m hifast.radec
   :noepilog:

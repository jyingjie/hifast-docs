``hifast.find`` Search Spectra
==============================

.. program:: python -m hifast.find

Overview
--------

The ``hifast.find`` module is a utility for searching spectral data files for observations near a specific sky coordinate. This is useful for locating all spectra associated with a particular source or region of interest.

Search Workflow
---------------

1. **Target Specification**
   You must specify the target coordinate using the :option:`-p` argument. The coordinate string should be in a format understood by ``astropy.coordinates.SkyCoord`` (e.g., "HH:MM:SS +DD:MM:SS").

2. **Search Radius**
   The search radius is defined by :option:`-r` in arcminutes (default: 1 arcmin). Any beam center within this radius of the target coordinate will be reported.

3. **Input Files**
   Provide one or more HDF5 files to search using the ``fnames`` argument. You can use wildcards (e.g., ``data/*.hdf5``) to search multiple files at once.

Examples
--------

.. code-block:: bash

   # Search for a source at specific coordinates within 1 arcminute (default)
   python -m hifast.find data/*.hdf5 -p "0:48:26.3991 +42:34:08.808"

   # Search using decimal degrees (RA DEC)
   python -m hifast.find data/*.hdf5 -p "12.109 42.569"

   # Search using explicit units
   python -m hifast.find data/*.hdf5 -p "30.3deg 40.44deg"

   # Search with a larger radius (5 arcminutes)
   python -m hifast.find data/*.hdf5 -p "0:48:26.3991 +42:34:08.808" -r 5

Full Parameter Reference
------------------------

.. tip::
   You can also view the full list of parameters and their descriptions directly in your terminal by running:
   
   .. code-block:: bash
   
      python -m hifast.find --help

.. argparse::
   :module: hifast.find
   :func: parser
   :prog: python -m hifast.find
   :noepilog:

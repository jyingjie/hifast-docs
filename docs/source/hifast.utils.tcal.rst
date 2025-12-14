Tcal
=================

Overview
--------
The Tcal module handles the management and retrieval of noise calibration data files. It ensures that the necessary calibration data (matching MJD and Frequency) is available for processing.

Relevant parameters can be set in :doc:`hifast.utils.config`, see the :ref:`tcal_configuration` section for details.

Usage Scenarios
---------------

Online Mode (Default)
~~~~~~~~~~~~~~~~~~~~~
When HiFAST runs on a machine with internet access, it automatically manages calibration data:

*   **On-Demand Download**: When processing data for a specific date, HiFAST checks if the required Tcal files exist locally. If valid files are missing, it automatically attempts to download them from the configured source.
*   **Auto-Update**: It periodically checks for updates to the data index (manifest).

Offline Mode Setup
~~~~~~~~~~~~~~~~~~
If you need to run HiFAST on a machine without internet access (e.g., a secure cluster), follow these steps to prepare the data:

1.  **Download on an Online Machine**:
    Use the ``update-all`` command on a connected machine to download the complete dataset.
    
    .. code-block:: bash

       python -m hifast.utils.tcal update-all

    This will download all available dates to the Tcal data directory (Default: ``~/Tcal/``). You can check or change this path using :doc:`hifast.utils.config`.

2.  **Transfer Data**:
    Copy the entire ``~/Tcal/`` directory (or your custom data directory) to the offline machine.

3.  **Enable Offline Mode**:
    On the offline machine, set the ``HIFAST_GENERAL_OFFLINE`` environment variable. This tells HiFAST to skip all network checks and rely solely on the local files.

    .. code-block:: bash

       # CLI
       python -m hifast.utils.config set general offline true
       # or
       # Environment Variable
       export HIFAST_GENERAL_OFFLINE=1


    .. note::
       In this mode, the :code:`list` command will show "Source: Local Cache (Offline Mode)" and warn that the list might be incomplete if the local data is outdated.


Full Parameter Reference
------------------------

.. argparse::
   :module: hifast.utils.tcal
   :func: get_parser
   :prog: python -m hifast.utils.tcal

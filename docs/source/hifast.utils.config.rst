hifast.utils.config
=============

Overview
--------
The centralized configuration system for HiFAST manages global settings, supporting multiple sources with a clear priority order.

Priority Order (Highest to Lowest)
----------------------------------
1.  **Environment Variables**: ``HIFAST_<SECTION>_<OPTION>``
2.  **Config File**: ``~/.config/hifast/config.ini``
3.  **Defaults**: System hardcoded defaults.

Key Features
------------

Offline Mode
~~~~~~~~~~~~
To disable all network requests (e.g., for working in isolated environments):

.. code-block:: bash

   # CLI
   python -m hifast.utils.config set general offline true

   # Environment Variable
   export HIFAST_GENERAL_OFFLINE=1

Tcal Configuration
~~~~~~~~~~~~~~~~~~
Configure the source for Noise Calibration data:

*   **Source** (``tcal.source``): 'r2' (default) or 'github'.
*   **Data Directory** (``tcal.tcal_dir``): Local storage path (Default: ``~/Tcal/``).

Examples
--------

.. code-block:: bash

   # List all current settings & Env Var names
   python -m hifast.utils.config list

   # Set Tcal source to Github
   python -m hifast.utils.config set tcal source github

   # Check a specific value
   python -m hifast.utils.config get tcal tcal_dir

Full Parameter Reference
------------------------

.. argparse::
   :module: hifast.utils.config
   :func: get_parser
   :prog: python -m hifast.utils.config

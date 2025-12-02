``hifast.flux`` Flux Calibration
================================

.. program:: python -m hifast.flux

Overview
--------

The ``hifast.flux`` module converts spectral data from **Antenna Temperature (Ta)** to **Flux Density (Jy)**. This is a critical step in calibrating the intensity of the observed signal.

Calibration Methods
-------------------

The module supports two primary methods for flux calibration:

1. **Pre-measured Gain Curve (Default)**
   This method uses a standard gain curve model derived from long-term monitoring of calibrators. It is the simplest and most common approach.
   
   *   **Model**: The default model is ``Jiang2020`` (based on `Jiang et al. 2020 <https://arxiv.org/abs/2002.01786>`_), which describes the gain as a function of Zenith Angle (ZA).
   *   **Usage**: Simply run the command without specifying a calibrator file.
   *   **Advanced**: For the ``Liu2024`` model, you can also provide the ambient temperature using :option:`--Atemp`.

2. **Noise Diode Calibration**
   This method uses a specific calibrator observation (e.g., 3C48, 3C286) taken with a noise diode injection to determine the system gain for your specific observing session.
   
   *   **Usage**: Provide the path to the calibrator file using :option:`--cbr_store`.
   *   **Filtering**: If ``--cbr_store`` points to a directory, use :option:`--cbr_name` to select the specific source.
   *   **Corrections**: You can apply corrections for Tcal differences (:option:`--fix_diff_tcal`) and Zenith Angle differences (:option:`--fix_diff_ZA`) between the target and calibrator.

Examples
--------

.. code-block:: bash

   # Method 1: Standard calibration using the Jiang2020 gain curve
   python -m hifast.flux data/spec_Ta.hdf5

   # Method 2: Calibration using a specific noise diode observation file
   python -m hifast.flux data/spec_Ta.hdf5 --cbr_store data/calibrator_3C48.hdf5

   # Method 2 (Advanced): Using a directory of calibrators and filtering by name
   python -m hifast.flux data/spec_Ta.hdf5 --cbr_store data/calibrators/ --cbr_name 3C48

Full Parameter Reference
------------------------

.. tip::
   You can also view the full list of parameters and their descriptions directly in your terminal by running:
   
   .. code-block:: bash
   
      python -m hifast.flux --help

.. argparse::
   :module: hifast.flux
   :func: parser
   :prog: python -m hifast.flux
   :noepilog:

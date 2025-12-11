``hifast.bld`` Baseline Fitting
===============================

.. program:: python -m hifast.bld

Overview
--------

The ``hifast.bld`` module is designed for fitting and subtracting baselines from spectral data. This is a critical step in radio astronomy data reduction to remove instrumental or environmental effects and isolate the astronomical signal.

The module supports various fitting algorithms (e.g., PLS, polynomial, spline) and includes robust methods to exclude signal regions during fitting. It also offers preprocessing options (smoothing, binning) and an interactive mode for parameter tuning.

Workflow
--------

The baseline fitting process typically involves three stages:

.. mermaid::

   %%{init: {'themeVariables': { 'fontSize': '50px'}, 'flowchart': {'diagramPadding': 0}}}%%
   graph TD
      A[Input Data] --> B[Preprocessing]
      B --> C[Baseline Determination]
      A --> D[Subtraction]
      C --> D
      D --> E{Post-processing?}
      E -- Yes --> F[Post-processing]
      E -- No --> G[Output Data]
      F --> G

      subgraph Preprocessing
         B1[Time Averaging/Smoothing]
         B2[Frequency Smoothing/Binning]
      end

      subgraph Fitting
         C1[Method Selection]
         C2[Iterative Reweighting]
         C3[Signal Exclusion]
      end

      B -.-> B1
      B -.-> B2
      C -.-> C1
      C -.-> C2
      C -.-> C3

1. **Preprocessing (Optional)**
   Data can be smoothed or averaged along the time or frequency axis to improve the signal-to-noise ratio for baseline estimation. This is configured using parameters like :option:`--njoin` (time averaging) or :option:`--s_method_freq` (frequency smoothing).

   .. note::
      The preprocessed data is used *only* for determining the baseline. The calculated baseline is then subtracted from the *original* (unprocessed) data, preserving the spectral resolution and signal characteristics.

   .. important:: **Time Domain Fitting (-T)**
   
      You can fit the baseline along the **time axis** instead of the frequency axis by using the :option:`-T` (or :option:`--trans`) flag.
      
      **Crucially**, enabling this option **transposes** the data dimensions, which swaps the physical meaning of the preprocessing parameters:
      
      * **Time-related parameters** (e.g., :option:`--njoin`, :option:`--s_method_t`) will effectively apply to the **Frequency** axis.
      * **Frequency-related parameters** (e.g., :option:`--average_every_freq`, :option:`--s_method_freq`) will effectively apply to the **Time** axis.

2. **Baseline Fitting & Subtraction**
   The core step involves fitting a model to the baseline.
   
   * **Method Selection**: Choose a method using :option:`--method`. Common choices include:
     
     * ``arPLS``: Asymmetrically Reweighted Penalized Least Squares (robust and popular).
     * ``poly-asym1``: Polynomial fitting with asymmetric reweighting.
     * ``spline-asym1``: Spline fitting.
     * ``Gauss-asym1``: Gaussian smoothing based baseline.
     
   * **Parameter Tuning**:
   
     * :option:`--lam`: Smoothing parameter for PLS, Spline, and Gauss methods. Larger values result in a stiffer (smoother) baseline.
     * :option:`--deg`: Degree for polynomial or spline methods.
     
   * **Signal Exclusion**: The module iteratively reweights data to ignore signal regions (lines).
   
     * :option:`--exclude_add`: Additional automatic exclusion logic.
       
       * ``auto1``: Excludes points where weights are very low (< 0.01) and extends the region.
       * ``auto2``: Uses Gaussian filtering on residuals to identify and exclude outliers (> 3 sigma).
       
     * :option:`--src_file`: Provide a catalog to explicitly mask known sources.

3. **Post-processing (Optional)**
   If strong time-averaging was used in preprocessing, a secondary "post-processing" step on individual spectra might be necessary to remove residual baseline structures. This is configured using ``--post_*`` arguments.

Examples
--------

.. code-block:: bash

   # Basic usage with default arPLS method
   python -m hifast.bld data_flux.hdf5

   # Use a polynomial fit of degree 1 (linear)
   python -m hifast.bld data_flux.hdf5 --method poly-asym1 --deg 1

   # Preprocess by averaging 10 time samples for stable baseline estimation
   python -m hifast.bld data_flux.hdf5 --njoin 10

   # Interactive mode to tune parameters
   python -m hifast.bld data_flux.hdf5 -i --length 50

Full Parameter Reference
------------------------

.. tip::
   You can also view the full list of parameters and their descriptions directly in your terminal by running:
   
   .. code-block:: bash
   
      python -m hifast.bld --help

.. argparse::
   :module: hifast.bld
   :func: parser
   :prog: python -m hifast.bld
   :noepilog:
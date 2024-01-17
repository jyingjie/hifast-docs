``hifast.bld`` Baseline fitting
====================================

The ``hifast.bld`` module is designed for fitting and subtracting baselines.

This process involves fitting and subtracting a baseline, considering all components other than the signal. Baselines are typically "smoother" than signals, 
thus methods like PLS and polynomials can be employed for fitting. 
During baseline fitting, signal regions are excluded by iteratively adjusting the weights of each data point to make them zero or very small in the signal areas. 
Noise can impact the quality of baseline fitting. Therefore, optional preprocessing is provided to reduce this effect.

The workflow is: Preprocessing --> Iterative Fitting and Subtraction of Baseline --> Post-processing (optional, depends on preprocessing). 
The output filename will include ``-bld`` or ``-bld_p``.

Workflow
--------

Preprocessing
^^^^^^^^^^^^^

.. note::

   The spectrum after preprocessing is used only for fitting the baseline. The original spectrum is then used for baseline subtraction, thus preserving the original spectrum.

Preprocessing involves operations along both the time axis and frequency direction:

   -  | Along the time axis for each *channel* (*frequency sample*) (post-processing may be required if enabled)
      | Includes merging of spectral lines ``--njoin`` or smoothing ``--s_method_t``, typically using only one of these methods. (``--njoin`` reduces the number of baselines to be fitted, saving time.)
      | Suitable for scenarios where the baseline is stable over the merged or smoothed time range. Post-processing can be done using a low-order polynomial for further baseline correction.
      
      -  ``--njoin``: Number of spectral lines to merge for baseline fitting.
      -  ``--s_method_t``: Smoothing method along the time axis; options include ``median``, ``gaussian``, ``boxcar``; to be used with ``--s_sigma_t``.
      -  ``--s_sigma_t``: Smoothing scale, in terms of the number of spectral lines.

   -  | Along the frequency axis for each spectra line (usually enabled).
      | Includes merging of channels ``--average_every_freq`` or smoothing ``--s_method_freq``, typically using only one of these methods.
      
      -  ``--s_method_freq``: Smoothing each spectral line along the frequency axis; options include ``gaussian``, ``boxcar``; used with ``--s_sigma_freq``.
      -  ``--s_sigma_freq``: Smoothing scale, in terms of the number of sample points. Generally, set to 3 for W band, and 48 for F and N bands.
      -  ``--average_every_freq``: Average every certain number of sample points along the frequency axis.
   
   -  ``--frange``:
      Limits to this frequency range for the spectral lines. Followed by two numbers, space-separated, lower limit first.
      A larger range increases fitting time, and the increase is not linear.

Iterative Baseline Fitting
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

   -  | ``--method``: Fitting method
      | ``arPLS``, ``srPLS``, 
      | ``PLS-asym1``, ``PLS-asym2``, ``PLS-asym3``, ``PLS-sym1``,
      | The prefix in the method names (before ``-``) represents the fitting function, and the suffix indicates the weight adjustment method during iteration (e.g., ``PLS-asym1`` is the same as ``arPLS``).
      | ``PLS`` or ``poly`` (polynomial) are prefixes, with polynomial fitting suitable for simple baselines, such as subtracting off-source spectral lines or continuous spectra.
      | Suffixes ``asym1``, ``asym2``, ``asym3`` assume the signal is on one side of the baseline, which can cause the baseline on both sides of the signal to be elevated. Use ``--exclude_add`` to alleviate this.
        ``sym1`` does not assume the signal is on a specific side, but might be less effective than ``asym`` due to the lack of this prior information.
   -  ``--lam``: Parameter for ``PLS`` method. Adjusts the smoothness; larger values are closer to low-order polynomial (poly) fitting.
   -  ``--deg``: For ``PLS``, use 2; for ``poly``, it's the polynomial order, e.g., ``--deg 1`` for linear fitting.
   -  ``--niter``: Number of iterations for excluding "signal" areas to find the baseline. Default is usually sufficient.
   -  ``--exclude_add``: Alleviates potential elevation of the baseline around the signal. Options: ``none``, ``auto1``, or ``auto2``.
   -  ``--nproc``: Number of processes to use for parallel processing.
   

Post-processing
^^^^^^^^^^^^^^^

Required only if ``--njoin`` or ``--s_method_t`` was enabled in preprocessing. Post-processing involves using a low-order polynomial for further baseline correction, or the output file can be input again into the ``hifast.bld`` module as a substitute.

- ``--post_method``: Options include ``none``, ``poly-asym1``, ``poly-asym2``, ``poly-asym3``, ``poly-sym1``. The default is ``none``.
- ``--post_s_method_freq``: 
- ``--post_s_sigma_freq``: 
- ``--post_average_every_freq``: 
- ``--post_deg``: Polynomial order; should not be too high.
- ``--post_ratio``: 
- ``--post_niter``:
- ``--post_exclude_add``: 

Interactive Parameter Tuning in JupyterLab
----------------------------------------------
   -  ``-i``: Activate interactive mode.
   -  ``--length``: Number of spectral lines to test at a time, default is 20.
   -  ``--figsize``: Output figure size, a parameter in matplotlib.

   ``--nproc`` and ``--frange`` are also supported in this mode.

Parameters
----------

Use the command ``python -m hifast.bld -h | more`` for more parameter details. 
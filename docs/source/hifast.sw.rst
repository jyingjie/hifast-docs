``hifast.sw`` Standing Wave Removal
========================================

``hifast.sw``: Fits and subtracts Standing Waves (SW).

Example
--------

.. code-block:: bash

   python -m hifast.sw data/XXX_arcdrift-M01_W-specs_T-flux-bld.hdf5 --method fft --nproc 5

- Input file should be a ``*-bld*.hdf5`` file processed by ``hifast.bld``.
  In cases of severe RFI, use ``hifast.rfi`` first.

- Output file will have the suffix ``-sw.hdf5`` or ``-sw_nobld.hdf5``.

- Example Notebooks:

   - Interactive: :download:`hifast.sw_example.ipynb <examples/example1/hifast.sw_fft_example-20230309.ipynb>`

   - Non-interactive (for quick review): :download:`hifast.sw_example-uninteract.ipynb <examples/example1/hifast.sw_fft_example-uninteract-20230309.ipynb>`

Parameters
-----------

Main Parameters
^^^^^^^^^^^^^^^^^

   -  ``--nproc``: Followed by a number, specifies the number of processes.

   -  ``--method``: {``sin_poly``, ``fft``}

       - ``sin_poly``: Least squares fitting of polynomial + sinusoidal.

       - ``fft``: Operates in Fourier transform's phase space, retrieves SW 
         by inverse Fourier transform.

   -  ``--njoin``, ``--s_method_t``, ``--s_sigma_t``, 
      ``--s_method_freq``, ``--s_sigma_freq``, ``--average_every_freq`` 
      similar to `hifast.bld <hifast.bld.html>`_, 
      ``--njoin`` not supported with ``--method fft``.

   - ``--nobld``: Return data without baseline removed, only SW removed, 
     suffix '-sw_nobld.hdf5'.

Method 1: Polynomial + Sinusoidal Fitting
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``--method sin_poly``

Parameters:

   -  ``--sin_f``: Initial frequency for sinusoidal fitting. Default 0.929,
      corresponding to a 1.09MHz periodic SW.
   -  ``--bound_f``: Frequency range for sinusoidal fitting.
   -  ``--deg``: Degree of the polynomial. Default is 1. Typically 0 or 1.

Method 2: FFT Filtering (Recommended)
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``--method fft``: Pre-process significant RFI or signals, then removes 
SW components via FFT filtering.

- Preliminary Parameters
   .. - ``--mw_frange``: Milky Way frequency range. Default ``1419 1422``, 
        wide. Narrower range through waterfall diagrams. Outdated, manual 
        setting unnecessary.

   -  ``--rms_frange``: Frequency range for RMS calculation, choose range 
      without signals/interference. E.g., ``--rms_frange 1400 1410``. 
      If not specified, determined automatically.

- First, replace the strong signals and RFI with fake standing wave.

- RFI and strong signals (like Milky Way) create low-frequency interference 
  in Fourier space, affecting SW identification. Substitution necessary.

- hifast's ``--rfi_method`` defaults to `near_ripple`, assumes nearby SW 
  patterns similar, used for filling areas needing substitution.

- First, smooth the original data:
   * First smoothing, to locate positions needing substitution. Utilizes 
     time and frequency directions, preserving weaker signals.
     Parameters: ``--s_method_t``, ``--s_sigma_t``, ``--s_method_freq``, 
     ``--s_sigma_freq``

   * Second smoothing, to identify SW troughs, aligning them with original 
     troughs during substitution. If ``--s_method_t_T``, ``--s_sigma_t_T``, 
     ``--s_method_freq_T``, ``--s_sigma_freq_T`` not given, same parameters 
     used.

   * Temporal smoothing may expand substitution areas. If ``--s_method_t`` 
     not ``none`` and ``restrict_bound True``, third Gaussian smoothing 
     in frequency direction with ``--rms_sigma`` to limit substitution area.
     For smaller signals, omit this step, or if edge accuracy not critical, 
     set ``restrict_bound`` to False.

- Substitution Parameters:

   * ``--times_thr``: Multiples of RMS identified as noise (no smoothing)
   * ``--times_s_thr``: Multiples of RMS for substitution (first iteration)
   * ``--times_s_thr2``: Multiples of RMS for substitution (second iteration)
   * ``--rfi_width_lim``: Width threshold for RFI/signals substitution
   * ``--ext_sec``: Number of channels to extend on both sides
   * ``--ext_freq``: First extend frequency ends (MHz), find lowest points 
     on both sides of strong signals for substitution, default 1.3.

   Note: ``--rfi_width_lim``, ``--ext_sec`` similar in meaning for RFI marking.

hifast sets RMS multiples for substitution areas.

   - First iteration, ``--times_thr`` as non-smoothing threshold for outliers 
     (like narrow-band RFI), and ``--times_s_thr`` as smoothing threshold 
     for SW troughs. If weaker signal flow requirements low, second iteration 
     may be unnecessary.
   
      .. figure:: download/replace1.png

         First iteration substitution diagram (interactive mode).

   - Second iteration (``--iter_twice``) effectively performs SW removal first, 
     then identifies areas for substitution. Only once may result in excessive 
     substitution (as SW amplitude affects results).
   
      ``is_excluded`` includes RFI and potential signal parts. If SW removal 
      first without baseline removal (sw_nobld), and baseline removal (bld) 
      next step, ``is_excluded`` included in bld.py to read its ``is_excluded``, 
      preventing overfitting of baseline to signals.
      
      If ``--save_is_excluded True``, ``is_excluded`` generated, passed in 
      second iteration.

Processing in Fourier Space Post-FFT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Illustrating with post-first substitution.

- Main Parameters

   -  ``--sw_base``: Removes constant components in Fourier space. If baseline 
      deviates from 0, setting True shifts entire spectrum by constant value.

   -  ``--sw_periods``: SW components to be removed. Accepts multiple characters. 
      Default ``1mhz 0_04mhz``. Characters and corresponding SW periods:

         =========   ================
         Character    SW Period (MHz)
         =========   ================
         1mhz         1.08
         2mhz         1.92
         0_04mhz      0.039
         =========   ================

      Note: 2mhz SW rarely seen, only once in M06 YY, so need not be added

   -  ``--check_2mhz``: If True, adds ``2mhz`` to ``--sw_periods`` when inputting 
      Beam 6 files; if not Beam 6, removes ``2mhz`` (if present). Except data from 
      July 31, 2021, do not set this parameter to True.

   -  ``--amp_thr_mean_factor``: Modes by *average amplitude* threshold in Fourier 
      space, identified as known SW types. Input as multiple of median. Corresponds 
      to two thresholds for noise switch off/on.

   -  ``--amp_thr_solo_factor``: SW parts by *individual spectral line amplitude* 
      threshold in Fourier space. Input as multiple of median. Corresponds to two 
      thresholds for noise switch off/on.

   -  ``--chan_wide``: Modes within ±(2 * channel number - 1) channels from SW mode 
      center, selected as part of SW. Used for ``1mhz`` and ``2mhz`` SW. Default 5.

   -  ``--chan_narr``: Similar to above, but for narrow-band parts. Used for 
      ``0_04mhz`` SW and multiples of ``1mhz``. Default 2.

   -  ``--choose_method``: Method for selecting modes in Fourier space as SW, 
      ``all`` or ``interpolate``. Default ``all``.

- Noise Off (Cal_off) Spectral Line Processing

   SW amplitude and phase affected by noise switch changes, need separate processing.

   .. figure:: download/fourier_water.png

         Amplitude in Fourier space, 0.92 microseconds corresponding to 1MHz SW, 
         1.84 microseconds to double frequency.

   - Adjust ``--amp_thr_mean_factor`` through interactive page

      .. figure:: download/select_amp_mean.png

         Average amplitude in Fourier space, peaks for two SW exceed threshold.

   - Adjust ``--amp_thr_solo_factor`` through interactive page
   
      .. figure:: download/select_amp_solo.png

         Individual amplitude in Fourier space, peaks for two SW exceed threshold, 
         ``--chan_wide`` and ``--chan_narr`` cover necessary peaks.

- Noise On (Cal_on) Spectral Line Processing

   Same method to determine thresholds when on.

- Inverse Fourier Transform

   Inverse transform selected Fourier modes yields SW.

- If ``--iter_twice True``, second substitution after SW removal, repeat process. 
  Theoretically better results, see previous explanations.

Notes
^^^^^^
- Post-FFT, data at frequency edges degrade due to truncation in discrete Fourier 
  transforms. Discard 5~10MHz of lower-quality data at ends.

- Larger bandwidth of input file, higher FFT resolution. Minimum 50MHz recommended.

Parameters
-------------

Use command ``python -m hifast.sw -h | more`` for more parameter details.

| Author: astroR2, 2023/3/9 
| References:
|     Xu, Chen, et al. HiFAST: An H I Data Calibration and Imaging Pipeline for 
|     FAST III. Standing Wave Removal, 2023
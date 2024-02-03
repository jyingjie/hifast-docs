``hifast.sep`` Temperature Calibration
======================================

``hifast.sep`` processes raw data from a single beam, differentiating raw spectral data when the noise diode is on (Cal on) and off (Cal off). It computes the antenna temperature using noise diode data.

Processing Overview
-------------------
   1. In FAST's data, each beam's data is stored in multiple file blocks, named ``0001.fits—9999.fits``. Input the path of the first file block (e.g., ``/proj/20211205/XXX_arcdrift-M02_F_0001.fits``) to sequentially process these files.
   2. Determine the noise diode switching cycle using three parameters ``-d, -m, -n``, representing delay time, Cal on time, and Cal off time, each divided by the spectral line sampling time. (\ :doc:`Example <noise_paras>`\ )
   3. Convert power to antenna temperature:
   
      .. math::

        T_\mathrm{a}^{\mathrm{cal\_off}}(\nu) = \frac{{P_{\mathrm{cal\_off}}}(\nu)}{P_{\mathrm{cal}}(\nu)_{\mathrm{smooth}}} \times T_{\mathrm{cal}}(\nu)_{\mathrm{smooth}},\\
        T_\mathrm{a}^{\mathrm{cal\_on}}(\nu) = \frac{{P_{\mathrm{cal\_on}}}(\nu)}{P_{\mathrm{cal}}(\nu)_{\mathrm{smooth}}} \times T_{\mathrm{cal}}(\nu)_{\mathrm{smooth}} - T_{\mathrm{cal}}(\nu)_{\mathrm{smooth}}
   
      These formulas yield the antenna temperature excluding noise diode contributions, requiring noise diode temperature :math:`T_{\mathrm{cal}}` and response :math:`P_{\mathrm{cal}}`.
     
     - :math:`T_{\mathrm{cal}}`: Uses FAST's official noise diode temperature file.
       -  ``--noise_mode``: Noise diode strength during observation. Options: high or low; default: high.
       -  ``--noise_date``: Which day's noise temperature file to use (e.g., 20190115), see :ref:`Tcal Data Configuration <label-tcal_file>`. If set to auto, selects the nearest file to the observation date.

     - :math:`P_{\mathrm{cal}}`: Derived from the noise diode's Cal_on spectral line power minus the adjacent Cal_off spectral line power. Regular noise diode activations provide a :math:`P_{\mathrm{cal}}` each cycle.
      
       - Checking :math:`P_{\mathrm{cal}}`: (``--check_cal A``, supports if Cal_off sampling number ``-n`` is greater than 6).
         If a noise diode activates on a continuous spectral source or experiences Radio Frequency Interference (RFI), it can't be used. The program compares the variation in several Cal_off near Cal_on, with a specific variation threshold. Spectral lines are binned by frequency (``--freq_step_c``), and bins with Cal_off variation exceeding ``--pcal_vary_lim_bin`` are marked damaged. A Cal_on with many damaged bins (``--pcal_bad_lim_freq``) is discarded. Output includes waterfall charts for verification.

          .. figure:: download/sep-pcals.png
       
       - Calibrating each spectral line with :math:`P_{\mathrm{cal}}`:
  
         * Method one: Individual processing (``--merge_pcals False``).
           Each spectral line is calibrated using the nearest :math:`P_{\mathrm{cal}}` (smoothed to reduce noise). If the nearest is damaged, it searches for the next undamaged one. If the distance to the nearest Cal_on exceeds ``--cal_dis_lim``, the line's temperature is marked as nan.

           .. figure:: download/sep-pcals-smooth.png
           
         * Method two: Merge for frequency dependence (``--merge_pcals True``).
           :math:`P_{\mathrm{cal}}`'s frequency dependence over time is relatively stable, only varying in amplitude:
            
            .. math::
               P_{\mathrm{cal}}(t,\nu) = Amp(t)*F(\nu)

           All :math:`P_{\mathrm{cal}}` are merged (``--method_merge MergeFun``) and smoothed to obtain frequency dependence:
           
            .. math::
              F(\nu)_{\mathrm{smooth}} = \mathrm{SmooothFun}(\mathrm{MergeFun}(P_{\mathrm{cal,i}}(\nu)))

           Am

plitude deviations are calculated (``--squeeze_diff_freq SqueezeFreqFun``), and interpolated for each spectral line ``j`` (``--method_interp InterpFun``):
           
            .. math::
              P_{\mathrm{cal,j}}(\nu) = \mathrm{InterpFun}(\mathrm{AmpDiff_{i}})*F(\nu)_{\mathrm{smooth}}
          
           Output images showcase :math:`P_{\mathrm{cal}}` variations and interpolation results.

           .. figure:: download/sep-pcals-merged.png

         * Smoothing parameters (SmooothFun):
           - ``--smooth``: Smoothing method options: gaussian, poly, or mean.
           - ``--s_sigma``: Required for gaussian smoothing, unit MHz.
           - Gaussian smoothing is ideal for large frequency intervals; mean is for smaller intervals; poly fits polynomially with ``--s_deg``.

Parameters
----------
Use ``python -m hifast.sep -h | more`` for detailed parameter descriptions.

   - ``-d, -m, -n``: Delay, Cal on, and Cal off times, divided by spectral line sampling time.
   - ``--step``: Number of file blocks loaded into memory per iteration.
   - ``--frange``: Frequency range processed by the program, in MHz.
   - ``--ext_frange``: Extends ``frange`` for gaussian smoothing.
   - ``--dfactor``: Reduces frequency sampling rate.
   - ``--outdir``: Directory path for output files.
   - ...

Output
------
- Output files end with ``specs_T.hdf5``, readable with h5py. For example:
   
   .. code-block:: python

      import h5py
      f = h5py.File('data/XXX_arcdrift-M02_F-specs_T.hdf5', 'r')
      S = f['S']
      print(list(S.keys()))
      print(S['mjd'][:])

- Additionally, images are generated for Cal verification.
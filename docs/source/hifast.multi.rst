``hifast.multi`` Multi-step Operations (Doppler Correction, etc)
==========================================================================

``hifast.multi``: Multi-step Operations (Doppler Correction, etc)

-  Example:

   ::

       python -m hifast.multi XXX.hdf5 --fc True --frame LSRK

-  Parameters

   -  ``--fc``\ Corrects from the Topocentric reference frame of the telescope to a reference frame centered on the Sun or LSR.

      ``--fc True``

      -  ``--frame``: Choice of reference frame, either HELIOCEN or LSRK.

   -  ``--replace_rfi``:
      If set to True and is_rfi exists in the input file, the value of rfi will be replaced with nan. Default is True.

   -  ``--merge_polar``: If set to True, merge the two polarizations. Default is True.

-  Output filename changes based on input parameters, may include -fc
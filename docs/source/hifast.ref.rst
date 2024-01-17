``hifast.ref`` off-source subtraction
======================================

Similar to on-source/off-source mode in tracking, \ ``hifast.ref`` in scan mode
estimates reference spectra ("off-source"), then subtracts them, reducing the
system temperature. Also, ``hifast.bld -T True`` can have a similar effect.

Processing Flow
----------------

- ``--method MinMed`` or ``--method MedMed``
  
  - Divide all spectra into segments over time ( ``--npart`` ), processing
    each separately.
    
     * Further divide each segment into sub-segments (based on sub-segment
       count ``--nsection`` or length ``--nspec``),
     * Compute median (Med) along time for each sub-segment,
     * Reference spectrum for a segment is median of medians ( ``MedMed`` ) or
       minimum of medians ( ``MinMed`` ),
     * Subtract reference spectrum.
  - Process above steps separately for each frequency.

- Typically, reapply low-order polynomial baseline subtraction to each
  spectrum (add ``--post_*`` parameters or input the output into
  ``hifast.bld`` module)

Parameters
----------

Use command ``python -m hifast.ref -h | more`` for more parameter details.



OnOff Observation
==================
Method 1 and Method 2 primarily differ in whether they consider the drift of the standing wave phase.


Method 1 
---------

  1. Use `hifast.pos_swi` to separate noise diode on, off, and source (src) and reference point (ref) observations, then calibrate using the noise tube, subtract ref from src, and combine into a single spectrum (retain both polarizations).

    :download:`M1-S1.sh <example2/M1-S1.sh>`

    .. literalinclude:: example2/M1-S1.sh
      :language: bash
      :emphasize-lines: 4
      :linenos:
  
  2. Manually remove the baseline, fit the standing wave with a sine function.
  
    | Download: :download:`M1-S2.ipynb <example2/M1-S2.ipynb>`

    .. | View: `notebook <example2/M1-S2.ipynb>`_

  3. Use `hifast.flux` for flux calibration and `hifast.multi --fc True` for coordinate system correction.


Method 2
----------

1. Initially, do not differentiate between source (src) and reference point (ref) observations. Calibrate using the same method as for mapping.
   
   :download:`M2-S1.sh <example2/M2-S1.sh>`

    .. literalinclude:: example2/M2-S1.sh
      :language: bash
      :emphasize-lines: 4
      :linenos:

2. Use the FFT method to remove the standing wave from each spectrum
   
   :download:`M2-S2.sh <example2/M2-S2.sh>`
   :download:`S2-sw.ini <../files/example1/conf/S2-sw.ini>`
  
    .. literalinclude:: example2/M2-S2.sh
      :language: bash
      :emphasize-lines: 4
      :linenos:

3. Use `hifast.pos_swi_2` to separate source (src) and reference point (ref) observations, then subtract ref from src and combine into a single spectrum (retain both polarizations).
   
   :download:`M2-S3.sh <example2/M2-S3.sh>`

    .. literalinclude:: example2/M2-S3.sh
      :language: bash
      :emphasize-lines: 4
      :linenos:

4. Manually remove the baseline
   
   | Download: :download:`M2-S4.ipynb <example2/M2-S4.ipynb>`
   
   .. | View: `notebook <example2/M2-S4.ipynb>`_

5. Use `hifast.multi --fc True` for coordinate system correction.
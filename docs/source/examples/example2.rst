Example: On-Off Observation
===========================

This example demonstrates how to process On-Off observation data with HiFAST. In this mode, the telescope observes a target source ("On") and then a nearby empty region of the sky ("Off"). Subtracting the "Off" spectrum from the "On" spectrum removes background noise and instrumental effects, leaving the clean signal from the source.

This page presents two different methods for processing On-Off data, which primarily differ in how they handle the removal of instrumental standing waves.

Download Sample Data
--------------------

First, download the sample dataset from this link: https://pan.cstcloud.cn/s/LdEsxTHRY

Method 1: Sine-fitting for Standing Waves
-----------------------------------------
This method is suitable when the standing wave phase is stable over time. It involves fitting and subtracting a sine wave from the spectrum.

**1. Separate, Calibrate, and Subtract**

The first script uses `hifast.pos_swi` to separate the On-source, Off-source, and noise diode observations. It then performs a temperature calibration and subtracts the Off-source spectrum from the On-source spectrum.

- **Script:** :download:`M1-S1.sh <example2/M1-S1.sh>`

.. literalinclude:: example2/M1-S1.sh
    :language: bash
    :emphasize-lines: 4
    :linenos:

**2. Manual Baseline and Standing Wave Removal**

The next step is to manually remove the baseline and fit the standing wave using a Jupyter notebook.

- :download:`Download Notebook: M1-S2.ipynb <example2/M1-S2.ipynb>`

.. note::

   The notebook for this step is available for download but is not rendered on this page to keep the layout clean.

**3. Final Corrections**

The final step is to perform flux calibration and a coordinate system correction.

.. code-block:: bash

   python -m hifast.flux
   python -m hifast.multi --fc True


Method 2: FFT for Standing Waves
--------------------------------
This method uses a Fast Fourier Transform (FFT) approach to remove the standing wave. This can be more effective if the standing wave phase is not stable.

**1. Initial Calibration**

First, calibrate the data in the same way as for mapping, without separating the On and Off observations yet.

- **Script:** :download:`M2-S1.sh <example2/M2-S1.sh>`

.. literalinclude:: example2/M2-S1.sh
    :language: bash
    :emphasize-lines: 4
    :linenos:

**2. FFT Standing Wave Removal**

Next, use the FFT method to remove the standing wave from each spectrum.

- **Script:** :download:`M2-S2.sh <example2/M2-S2.sh>`
- **Configuration:** :download:`S2-sw.ini <../files/example1/conf/S2-sw.ini>`

.. literalinclude:: example2/M2-S2.sh
    :language: bash
    :emphasize-lines: 4
    :linenos:

**3. Separate and Subtract**

Now, use `hifast.pos_swi_2` to separate the On and Off observations and perform the subtraction.

- **Script:** :download:`M2-S3.sh <example2/M2-S3.sh>`

.. literalinclude:: example2/M2-S3.sh
    :language: bash
    :emphasize-lines: 4
    :linenos:

**4. Manual Baseline Removal**

Finally, manually remove any remaining baseline residuals in a Jupyter notebook.

- :download:`Download Notebook: M2-S4.ipynb <example2/M2-S4.ipynb>`

.. note::

   The notebook for this step is available for download but is not rendered on this page to keep the layout clean.

**5. Final Correction**

The final step is to perform the coordinate system correction.

.. code-block:: bash

   python -m hifast.multi --fc True
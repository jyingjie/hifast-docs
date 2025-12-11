Example: On-The-Fly (OTF) Mapping of the M33 Region
=======================================================

This example demonstrates the process of calibrating and imaging On-The-Fly (OTF) mapping data of the M33 galactic region using HiFAST. The goal is to produce a final data cube suitable for scientific analysis.

Download Sample Data
--------------------

First, download the sample dataset from this link: https://pan.cstcloud.cn/s/u6u3iyfdRqo

The downloaded data contains the raw FITS files from the FAST telescope and a feed cabin position file (`.xlsx`). This `.xlsx` file records the trajectory of the feed's phase center, which is used by `hifast.radec` to calculate the celestial coordinates for the observation. The directory structure looks like this:

.. code-block:: console

    $ ls RAW_data/*
    RAW_data/KY:
    M33_OTF_2021_07_31_05_14_00_000.xlsx

    RAW_data/M33_OTF:
    20210731

Processing Workflow
-------------------

The FAST telescope has a wide frequency coverage. Within the observed M33 region, the data contains signals from both the extended structure of the M33 galaxy itself and various point sources at other frequencies. The optimal data processing strategy differs for these two types of sources, so we present two separate cases.

Case 1: Extended Source (M33 Galaxy)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This case is optimized for the extended, diffuse emission from the M33 galaxy. The processing is tailored for the frequencies corresponding to M33. The workflow consists of two main scripts.
(See Section 3.2 of the arXiv:2401.17364 for details)

**1. Calibration**

The main calibration workflow is executed by the `run_case1.sh` script.

- **Script:** :download:`run_case1.sh <../files/example1/run_case1.sh>`
- **Configuration:** :download:`S2-sw.ini <../files/example1/conf/S2-sw.ini>` and :download:`S2-rfi.ini <../files/example1/conf/S2-rfi.ini>`

.. literalinclude:: ../files/example1/run_case1.sh
    :language: bash
    :linenos:

**2. Cube Generation**

After running the calibration pipeline, this final script takes all the processed HDF5 files and grids them into a FITS data cube named `cube.fits`.

- **Script:** :download:`gen_cube_case1.sh <../files/example1/gen_cube_case1.sh>`

.. literalinclude:: ../files/example1/gen_cube_case1.sh
    :language: bash
    :linenos:

Case 2: Point Sources in the M33 Field
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
This case is optimized for identifying and analyzing point sources that appear at other frequencies within the observed M33 field.

- **Calibration Script:** :download:`run_case2.sh <../files/example1/run_case2.sh>`
- **Configuration Files:** Same as in Case 1.
- **Cube Generation:** The `gen_cube_case1.sh` script from Case 1 is also used for this case.

The full calibration workflow is executed by the `run_case2.sh` script:

.. literalinclude:: ../files/example1/run_case2.sh
    :language: bash
    :linenos:

Viewing the Results
-------------------

The following Jupyter notebook demonstrates how to inspect the calibrated data and the final data cube from these processing workflows.

:download:`example1.ipynb <../files/example1/example1.ipynb>`:

.. toctree::
   :maxdepth: 2
   
   ../files/example1/example1.ipynb

.. Additional Notebooks
.. --------------------
.. (These notebooks provide more detailed, step-by-step examples of RFI flagging and standing wave removal.)

.. .. toctree::
..    :maxdepth: 2

..    example1/hifast.rfi_example-20230309
..    example1/hifast.sw_fft_example-20230309
..    example1/hifast.sw_fft_example-uninteract-20230309
Mapping
========

Download Sample Data
--------------------

Link: https://pan.cstcloud.cn/s/u6u3iyfdRqo

.. code-block:: console

    $ ls RAW_data/*
    RAW_data/KY:
    M33_OTF_2021_07_31_05_14_00_000.xlsx

    RAW_data/M33_OTF:
    20210731

Case 1: large extended sources
-------------------------------
(See Section 3.2 of the arXiv:2401.17364 for details)

- Calibration script: :download:`run_case1.sh <../files/example1/run_case1.sh>`
- Use file to input parameters for `hifast.sw` and `hifast.rfi`: :download:`S2-sw.ini <../files/example1/conf/S2-sw.ini>` :download:`S2-rfi.ini <../files/example1/conf/S2-rfi.ini>`
- Script to generate cubes: :download:`gen_cube_case1.sh <../files/example1/gen_cube_case1.sh>`

 **Content in run_case1.sh**
.. literalinclude:: ../files/example1/run_case1.sh
    :language: bash
    :linenos:

Case 2: points source or small extended sources
--------------------------------------------------
(See Section 3.2 of the arXiv:2401.17364 for details)

 :download:`run_case2.sh <../files/example1/run_case2.sh>`
 (S2-sw.ini, S2-rfi.ini and script to generate cubes are same as Case 1)

.. literalinclude:: ../files/example1/run_case2.sh
    :language: bash
    :linenos:

Results (shown in a Jupyter notebook file) 
--------------------------------------------------

:download:`example1.ipynb <../files/example1/example1.ipynb>`:

.. toctree::
   :maxdepth: 2
   
   ../files/example1/example1.ipynb
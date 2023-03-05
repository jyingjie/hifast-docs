Mapping
========

下载示例数据
-------------

链接：https://pan.cstcloud.cn/s/u6u3iyfdRqo

.. code-block:: console

    $ ls RAW_data/*
    RAW_data/KY:
    M33_OTF_2021_07_31_05_14_00_000.xlsx

    RAW_data/M33_OTF:
    20210731

噪音管定标、RA-DEC
------------------


- 方法一
  
 :download:`run-s1-v1.sh <example1/run-s1-v1.sh>`

.. literalinclude:: example1/run-s1-v1.sh
    :language: bash
    :emphasize-lines: 4, 14-22, 25
    :linenos:

- 方法二
  
  :download:`run-s1-v2.sh <example1/run-s1-v2.sh>`

.. literalinclude:: example1/run-s1-v2.sh
    :language: bash
    :emphasize-lines: 20
    :linenos:


基线、驻波、RFI ...
-------------------
- 方法一 
  
  用去基线的方法扣除系统温度

:download:`run-s2-v1.sh <example1/run-s2-v1.sh>`
:download:`S2-sw.ini <example1/conf/S2-sw.ini>`
:download:`S2-rfi.ini <example1/conf/S2-rfi.ini>`

.. literalinclude:: example1/run-s2-v1.sh
    :language: bash
    :emphasize-lines: 4
    :linenos:

- 方法二 
  
  减去Ref来扣除系统温度。S2-sw.ini 和 S2-rfi.ini 这两个参数文件与方法一的一致即可。

  :download:`run-s2-v1.sh <example1/run-s2-v2.sh>`

.. literalinclude:: example1/run-s2-v2.sh
    :language: bash
    :emphasize-lines: 4
    :linenos:

Imaging
-----------
.. literalinclude:: example1/gen_cube.sh
    :language: bash
    :linenos:
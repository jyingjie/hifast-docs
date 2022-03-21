hifast.cube 生成FITS Cube
=========================


``hifast.cube``

::

   python -m hifast.cube **/data/*-fc*.hdf5 --outname ./test_cubes.fits --bwidth 60 -p SIN

-  这里用 ``hifast.cube`` 来生成fits
   cubes文件，程序先生成ra、dec格点，然后找到距离格点中央为\ ``--r_cut``\ 范围内的谱线然后按\ ``--method``\ 处理谱线，最后保存在fits文件里。
-  ``python -m hifast.cube``

   -  后面跟参考系修正后生成的hdf5文件，支持多个文件路径（空格隔开），支持通配符。程序运行后会首先输出要处理的文件路径，请检查无重复无错误。
   -  ``--outname``: 输出的fits cubes文件路径，需要指定。
   -  ``--bwidth``: ra dec 分格点时的间隔大小，单位为
      角秒，默认为60。如果ra和dec采用一样间隔，参数后接一个数字即可，如果不一样，参数后接两个数，空格隔开。ra的间隔在前。
   -  ``--r_cut``: 考虑距离格点中心r_cut范围内谱线。单位为
      角秒，默认为90.
   -  ``--method``:
      r_cut范围内谱线处理方法（不同卷积方法的影响和差别还在测试中）

      -  ``mean``: 对谱线求平均.
      -  ``median``: 对谱线求median值.
      -  ``reweight``: Barnes el. al. 2001, MNRAS 322, 486
         https://ui.adsabs.harvard.edu/abs/2001MNRAS.322..486B/abstract
         .
      -  ``gaussian``: truncated Gaussian.

   -  ``--proj``: 投影方式: SIN, AIT, TAN.
   -  ``--ra_range``:
      ra的范围，后接两个数，空格隔开，下限在前，单位为度。默认值为输入文件里ra的最小值和最大值。
   -  ``--dec_range``: 类似\ ``--ra_range``\ 。
   -  ``--range3``: 限制第三轴（速度）的范围，类似\ ``--ra_range``\ 。
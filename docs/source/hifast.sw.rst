hifast.sw 驻波拟合
====================

``hifast.sw`` : 拟合并扣除驻波(**s**\ tanding \ **w**\ ave)。

- 参考文献：
    Xu, Chen, et al. HiFAST: An H I Data Calibration and Imaging Pipeline for FAST III. Standing Wave Removal, 2023

-  示例

.. code-block:: bash

   python -m hifast.sw data/XXX_arcdrift-M01_F-specs_T-flux-bld.hdf5 --method fft --nproc 5

-  输入已经 ``hifast.bld``\ 后的\ ``*-bld*.hdf5``\ 文件，RFI严重的情况下最好先 ``hifast.rfi``。

-  输出后缀为'-sw.hdf5'

-  示例Notebook：
   - 可交互的 :download:`hifast.sw_example.ipynb <examples/example1/hifast.sw_fft_example-20230309.ipynb>`

   - 不可交互的(适合快速检查) :download:`hifast.sw_example-uninteract.ipynb <examples/example1/hifast.sw_fft_example-uninteract-20230309.ipynb>`

参数
--------

-  主要参数

   -  ``--nproc``: 后接一个数，使用多少个进程来并行。

   -  ``--method``: {``sin_poly``, ``fft``}

       - ``sin_poly``: 最小二乘法拟合 多项式+正弦函数

       - ``fft``: 在傅里叶变换后的相空间里操作再反傅里叶变换得到驻波

   -  ``--njoin``, ``--s_method_t``, ``--s_sigma_t``,
      ``--s_method_freq``, ``--s_sigma_freq``,
      ``--average_every_freq``\ 与  `hifast.bld <hifast.bld.html>`_ 中的类似，
      ``--method fft`` 时不支持 ``--njoin``\ 。

   - ``--nobld``: 是否返回到未去基线只去了驻波的数据，后缀为'-sw_nobld.hdf5'.先去驻波再去基线可能获得更好的基线效果

多项式+正弦函数拟合
--------------------

   -  ``--method sin_poly``\ 的参数:

       -  ``--sin_f``: 拟合时正弦函数的频率的初值。默认值为0.929,对应1.09Mhz周期的驻波。
       -  ``--bound_f``: 拟合时正弦函数的频率的范围。
       -  ``--deg``: 多项式的阶数。默认1。一般设为0或者1.

(推荐)FFT filter滤波
----------------------
``--method fft``\ : 预先处理大的RFI或者信号，再通过FFT滤波除去驻波成分的影响。

- 前提参数
   - ``--mw_frange``: 银河系的频率范围。默认值为 ``1419 1422``\ ，比较宽。可以在瀑布图中查看找到更窄的范围。Deprecated, 无需手动设置银河系频率范围。

   -  ``--rms_frange``: 计算rms用的频率范围，选一个没有信号和干扰范围。用于判断大的信号。例如\ ``--rms_frange 1400 1410``。不指定则会尝试自动判定。

先进行RFI，强源的替代Replacement
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

- RFI, 强源（如银河系）会在傅里叶空间中形成大量的低频成分干扰，影响驻波成分的判断，所以需要先替代。

- hifast的````--rfi_method``默认为'near_ripple'， 假设邻近的的驻波形态相似，使用它们来填充需要被替代的区域。

- 首先对原始数据进行平滑：
   * 第一次平滑，用于寻找需要替代的位置。使用了时间和频率两个方向，尽量保留弱源。对应``--s_method_t``,``--s_sifma_t``,``--s_method_freq``,``--s_sigma_freq``

   * 第二次平滑，用于寻找驻波的波谷(Trough)，以实现替代时驻波波谷与波谷的对齐。如果不给定``--s_method_t_T``,``--s_sifma_t_T``,``--s_method_freq_T``,``--s_sigma_freq_T``,使用与上一组相同的。

   * 由于时间上的平滑可能扩大应该替代的区域，一旦`'s_method_t'!='none`且`restrict_bound = True`，将进行只有freq方向sigma为`rms_sigma`的第三次高斯平滑来限定替代区域。对于小源，可以不使用这一步，或者对信号边缘要求不高，也可以`restrict_bound = False`

- replace参数：
   * ``--times_thr``:大于RMS这么多倍的会被置为噪声(不平滑)
   * ``--times_s_thr``:大于RMS这么多倍的会被替代(第一次迭代)
   * ``--times_s_thr2``:大于RMS这么多倍的会被替代(第二次迭代)
   * ``--rfi_width_lim``: 要替换的rfi/源，频率上的宽度应该大于一阈值(通道数)
   * ``--ext_sec``: 并向两边扩展的通道数
   * ``--ext_freq``: 先扩展边缘(MHz)，再寻找强流量两边的最低点，先使用左/右边的一段更干净一点的代替强流量处，默认1.3即可。

   可以发现后 ``--rfi_width_lim``， ``--ext_sec``参数与rfi标记含义相同。

hifast通过设置RMS的倍数来决定哪些区域会被替代。

   - 第一次迭代中, ``--times_thr``作为非平滑阈值用于识别异常值(比如narrow band RFI)，``--times_s_thr``是平滑的阈值，用于寻找驻波的波谷。如果对弱源流量要求不高，可以不进行第二次迭代。
   
      .. figure:: download/replace1.png

         第一次迭代中替代的示意图(交互模式)。


   - 第二次迭代(``--iter_twice``)相当于先去了一次驻波，再确定哪些区域应该被替代，只用一次可能替代范围偏多(因为驻波的幅度影响)。 此时用``--times_s_thr2``才是平滑的阈值，用于寻找驻波的波谷。
      
      ``is_excluded``试图包含rfi和可能是源的部分，如果去驻波但不去基线(sw_nobld)，下一步再去基线(bld)，可以设置bld.py会读取其中的``is_excluded``，防止基线对信号的过拟合.
      
      如果 ``--save_is_excluded = True``, ``is_excluded``在第二次迭代中生成并传递。

FFT后傅里叶空间的处理
^^^^^^^^^^^^^^^^^^^^^^^^^^

这里以第一次替代后为例。

- 主要参数

   -  ``--sw_base``: 去除傅里叶空间的常数成分。如果基线整体偏离0, 此参数设为True可将谱线整体移动一个常数值。

   -  ``--sw_periods``:
      去除的驻波成分。后可接多个字符。默认为\ ``1mhz 0_04mhz``.
      字符与对应的驻波周期为：

         =======     ============
            字符        驻波周期(MHz)
         =======     ============
         1mhz        1.08
         2mhz        1.92
         0_04mhz     0.039
         =======     ============

       需要注意，2mhz驻波后来很罕见，只有一次出现再M06 YY，所以不用添加

   -  ``--check_2mhz``: 若为True，如果输入Beam 6文件，将在\ ``--sw_periods``\ 中添加 ``2mhz``,
      如果输入的不是Beam 6文件，则删除 ``2mhz`` (如果存在)。所以除了2021年7月31日的数据，不要设为True

   -  ``--amp_thr_mean_factor``:
      傅里叶空间的 *平均振幅* 大于阈值的模，会被识别为已知的几种驻波。这里输入的是中值的倍数。输入时noise off/on分别对应两个阈值

   -  ``--amp_thr_solo_factor``:
      傅里叶空间的 *每一谱线的振幅* 大于阈值，会被选中为驻波一部分被去除。这里输入的是中值的倍数。输入时noise off/on分别对应两个阈值

   -  ``--chan_wide``: 距离驻波的模的中心左右各(2 \* chann - 1)个通道数的模，作为驻波的一部分被选中.
      用于 ``1mhz`` 和 ``2mhz`` 的驻波。默认为5

   -  ``--chan_narr``: 同上，窄一些的.
      用于 ``0_04mhz`` 的驻波和 ``1mhz``的倍频。默认为2

   -  ``--choose_method``:
      选择傅里叶空间中哪些模作为驻波的方法， ``all`` 或者 ``interpolate``.
      默认为 ``all``.

- Noise Off
   由于噪音管的开关会改变驻波的振幅和相位，这里是分开处理的。

   .. figure:: download/fourier_water.png

         Fourier空间的振幅，横轴0.92微秒的是1-MHz驻波，1.84微秒的是其倍频。

   - 通过交互页面调节 ``--amp_thr_mean_factor``

      .. figure:: download/select_amp_mean.png

         Fourier空间的平均振幅，两个驻波所对应的峰都超过了阈值

   - 通过交互页面调节 ``--amp_thr_solo_factor``
   
      .. figure:: download/select_amp_solo.png

         Fourier空间的单条振幅，两个驻波所对应的峰都超过了阈值， ``--chan_wide``与 ``--chan_narr``能基本覆盖所需的峰。

- Noise On
   
   相同的方法，确定on的两个阈值

- iFFT
   将选出来的Fourier mode逆变换回去即得到驻波。

- 如果``--iter_twice=True``,则在去过一次驻波的基础上再次替代，重复以上过程。理论上效果更好，如前所述。

注意
^^^^^^
- FFT处理后数据频率两端的效果比较差，因为对于离散的FT，两边是截断，建议适当扔掉效果不好的5~10 MHz。

- 输入的文件包含频率带宽越长，FFT分辨率越高，建议至少50MHz。


在JupyterLab中命令行交互调参
---------------------------
目前只支持sin_poly拟合的方法。FFT请使用示例Notebook

   -  ``-i``: 执行交互模式
   -  ``--length``: 每次用多少条谱线来测试，默认20
   -  ``--figsize``: 输出图片大小，为matplotlib中的参数。

   同时\ ``--nproc``\ 和\ ``--frange``\ 在这一模式中也支持


wrote by astroR2, 2023/3/9
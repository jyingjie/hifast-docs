``hifast.sw`` 驻波拟合
======================

``hifast.sw`` : 驻波（Standing Wave）拟合并扣除。


示例
-----

.. code-block:: bash

   python -m hifast.sw data/XXX_arcdrift-M01_W-specs_T-flux-bld.hdf5 --method fft --nproc 5

- 输入文件应为已经经过 ``hifast.bld`` 处理的 ``*-bld*.hdf5`` 文件。在出现严重射频干扰的情况下，最好首先使用 ``hifast.rfi`` 进行处理。

- 输出文件的后缀为 ``-sw.hdf5`` 或者 ``-sw_nobld.hdf5``。

- 示例 Notebook：

   - 可交互的 :download:`hifast.sw_example.ipynb <examples/example1/hifast.sw_fft_example-20230309.ipynb>`

   - 不可交互的（适合快速检查）:download:`hifast.sw_example-uninteract.ipynb <examples/example1/hifast.sw_fft_example-uninteract-20230309.ipynb>`

参数
--------

主要参数
^^^^^^^^^^^^

   -  ``--nproc``: 后接一个数字，指定用多少个进程并行处理。

   -  ``--method``: {``sin_poly``, ``fft``}

       - ``sin_poly``: 采用最小二乘法拟合多项式+正弦函数的方式。

       - ``fft``: 在傅里叶变换后的相空间中进行操作，再通过反傅里叶变换得到驻波。

   -  ``--njoin``, ``--s_method_t``, ``--s_sigma_t``,
      ``--s_method_freq``, ``--s_sigma_freq``,
      ``--average_every_freq`` 与  `hifast.bld <hifast.bld.html>`_ 中的类似，
      在使用 ``--method fft`` 时不支持 ``--njoin``。

   - ``--nobld``: 是否返回未去除基线只去除了驻波的数据，后缀为'-sw_nobld.hdf5'。（在先去除驻波后再去基线的情况下，可能会获得更好的基线效果）

方法一：多项式+正弦函数拟合
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``--method sin_poly``

参数:

   -  ``--sin_f``: 拟合时正弦函数的频率的初值。默认值为0.929，对应1.09MHz周期的驻波。
   -  ``--bound_f``: 拟合时正弦函数的频率的范围。
   -  ``--deg``: 多项式的阶数。默认为1。一般设为0或者1。

方法二：FFT滤波（推荐）
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
``--method fft``：预先处理大规模射频干扰或信号，然后通过FFT滤波除去驻波对成分的影响。

- 前提参数
   .. - ``--mw_frange``: 银河系的频率范围。默认为 ``1419 1422``，比较宽。可以通过瀑布图寻找更窄的范围。已过时，不必手动设置银河系频率范围。

   -  ``--rms_frange``: 用于计算RMS的频率范围，选择一个没有信号和干扰的范围。用于判断大的信号。例如 ``--rms_frange 1400 1410``。如果不指定，将尝试自动判定。

- 首先进行射频干扰处理，强信号的替代替换
  
- RFI（射频干扰），强信号（如银河系）会在傅里叶空间中形成大量低频成分的干扰，影响驻波成分的判定，因此需要首先进行替代替换。

- hifast 的 ``--rfi_method`` 默认为 `near_ripple` ，假设邻近的驻波形态相似，使用它们来填充需要被替代的区域。

- 首先对原始数据进行平滑：
   * 第一次平滑，用于寻找需要替代的位置。同时使用了时间和频率两个方向，尽量保留较弱的信号。
     相应的参数为 ``--s_method_t``, ``--s_sigma_t``, ``--s_method_freq``, ``--s_sigma_freq``

   * 第二次平滑，用于寻找驻波的谷底，以实现替代时驻波的谷底与原谷底的对齐。如果不给定 ``--s_method_t_T``, ``--s_sigma_t_T``, ``--s_method_freq_T``, ``--s_sigma_freq_T``，则采用与上述相同的参数。

   * 由于时间上的平滑可能导致需替代的区域扩大，如果 ``--s_method_t`` 不为 ``none`` 且 ``restrict_bound True``，将进行仅在频率方向进行标准差为 ``--rms_sigma`` 的第三次高斯平滑来限定替代区域。
     对于较小的信号，可以不使用此步骤，或者如果对信号边缘的要求不高，也可以将 ``restrict_bound`` 设为 False。

- 替代参数：

   * ``--times_thr``: 超过RMS的多少倍将被置为噪声（不进行平滑）
   * ``--times_s_thr``: 超过RMS的多少倍将被替代（第一次迭代）
   * ``--times_s_thr2``: 超过RMS的多少倍将被替代（第二次迭代）
   * ``--rfi_width_lim``: 需要替代的RFI/信号，在频率上的宽度应大于特定阈值（频道数）
   * ``--ext_sec``: 两侧扩展的频道数
   * ``--ext_freq``: 首先扩展频率端（MHz），然后寻找强信号两侧的最低点，先使用较干净的两端代替强信号，默认可设为1.3。

   可以注意到，在后 ``--rfi_width_lim`` 和 ``--ext_sec`` 参数与RFI标记的含义相同。

hifast 通过设置RMS的倍数来决定哪些区域会被替代。

   - 在第一次迭代中，``--times_thr`` 作为非平滑阈值用于识别异常值（例如窄带RFI），``--times_s_thr`` 作为平滑阈值，用于寻找驻波的谷底。如果对较弱的信号的流量要求不高，可以不进行第二次迭代。
   
      .. figure:: download/replace1.png

         第一次迭代替代的示意图（交互模式）。

   - 第二次迭代（``--iter_twice``）相当于先进行了一次去驻波，然后确定哪些区域应该被替代，只用一次可能会替代得过多（因为驻波的幅度会影响结果）。
   
      ``is_excluded`` 试图包含RFI和可能是信号的部分，如果先进行去驻波而不进行去基线（sw_nobld），下一步再进行去基线（bld），此参数包含在bld.py读取其中的 ``is_excluded``，以防止基线对信号进行过度拟合。
      
      如果 ``--save_is_excluded True``，则 ``is_excluded`` 在第二次迭代中会生成并传递。

对FFT后的傅里叶空间进行处理
^^^^^^^^^^^^^^^^^^^^^^^^^^

这里以第一次替代后为例。

- 主要参数

   -  ``--sw_base``: 去除傅里叶空间的常数成分。若基线整体偏离0，则设置此参数为True可将整个频谱线移动一个常数值。

   -  ``--sw_periods``:
      需要去除的驻波成分。可接受多个字符作为参数。默认为 ``1mhz 0_04mhz``。
      字符及对应的驻波周期为：

         =======     ============
            字符        驻波周期(MHz)
         =======     ============
         1mhz        1.08
         2mhz        1.92
         0_04mhz      0.039
         =======     ============

       需要注意，2mhz的驻波后来很少见，只有一次出现在M06 YY中，因此无需添加

   -  ``--check_2mhz``: 若为True，在输入Beam 6文件时，将在 ``--sw_periods`` 中添加 ``2mhz``；
      若输入不是Beam 6文件，则删除 ``2mhz``（如果存在）。因此，除了2021年7月31日的数据外，不要将此参数设为True。

   -  ``--amp_thr_mean_factor``:
      由傅里叶空间的*平均振幅*阈值确定的模，会被识别为已知的几种驻波。此处输入为中值的倍数。设置时，分别对应噪声开关关/开时两个阈值

   -  ``--amp_thr_solo_factor``:
      由傅里叶空间的*每条频谱线的振幅*阈值确定的驻波部分。此处输入为中值的倍数。设置时，分别对应噪声开关关/开时两个阈值

   -  ``--chan_wide``: 距离驻波模的中心左右各（2 * 通道数 - 1）个通道数的模，作为驻波的一部分被选择。
      用于 ``1mhz`` 和 ``2mhz`` 的驻波。默认为5

   -  ``--chan_narr``: 作为上述类似选项的窄频带部分。
      用于 ``0_04mhz`` 的驻波和 ``1mhz`` 的倍频。默认为2

   -  ``--choose_method``:
      选择傅里叶空间中哪些模作为驻波的方法， ``all`` 或者 ``interpolate``。
      默认为 ``all``。

- 噪声管关闭的(Cal_off)谱线处理

   由于噪声开关的变化会影响驻波的振幅和相位，因此需要分开处理。

   .. figure:: download/fourier_water.png

         傅里叶空间中的振幅，0.92微秒对应1MHz驻波，1.84微秒对应其倍频。

   - 通过交互页面对 ``--amp_thr_mean_factor`` 进行调节

      .. figure:: download/select_amp_mean.png

         傅里叶空间中的平均振幅，两个驻波所对应的峰值均超过了阈值。

   - 通过交互页面对 ``--amp_thr_solo_factor`` 进行调节
   
      .. figure:: download/select_amp_solo.png

         傅里叶空间中的单条振幅，两个驻波所对应的峰值均超过了阈值， ``--chan_wide`` 和 ``--chan_narr`` 能够基本覆盖所需的峰值。

- 噪声开启的(Cal_on)谱线处理

   使用相同的方法，确定开启时的两个阈值

- 逆傅里叶变换

   对选定的傅里叶模式进行逆变换，即可得到驻波。

- 如果 ``--iter_twice True``，则在去驻波后再进行一次替代，重复上述过程。理论上效果更好，详见前述说明。

注意
^^^^^^
- 经FFT处理后，数据两端频率效果较差，因为对于离散的傅里叶变换，两端会被截断。建议适当舍弃效果较差的5~10MHz。

- 输入文件的频率带宽越大，FFT分辨率也越高，建议至少50MHz。

参数
------

使用命令 ``python -m hifast.sw -h | more`` 查看更多参数说明。

| 作者：astroR2, 2023/3/9 
| 参考文献：
|     Xu, Chen, 等. HiFAST: An H I Data Calibration and Imaging Pipeline for FAST III. Standing Wave Removal, 2023
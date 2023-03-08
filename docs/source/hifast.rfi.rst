hifast.rfi 标记RFI
====================

``hifast.rfi`` : 标记RFI

-  示例：

   .. code-block:: bash

      fname=XXX-bld.hdf5
      python -m hifast.rfi $fname --nr True --sf True --sf_frange 1300 1500 --lf False

-  输入去完基线得到的文件。目前不能处理频率在1155到1295MHz之间的RFI。
  
    .. figure:: download/rfi.png

       RFI示意图。A: 窄RFI, B: 短RFI, C: 银河系, D: 长RFI

-  输出文件名中包含 ``-rfi``。


RFI类型参数与优先顺序
-------------------------

- 主要参数:一般来说优先选用 ``--nr``, ``--sf``, 谨慎使用 ``--pr``，非低赤纬不要使用 ``--lf``
- 通用参数：
   -  ``--replace_rfi``: 是否将输出的RFI设为NAN

   -  ``--rms_frange``:
      计算rms用的频率范围，选一个没有信号和干扰范围。
      例如\ ``--rms_frange 1400 1410``。不指定则会尝试自动判定。
      ``--nr``, ``--sf``, ``--lf`` 为True时需要此参数。

   -  ``--all_beams``: 
      将19波束做一个平均，更容易找出19波束同时存在的RFI。目前用于``--sf``和人工标记环节。
      *请注意*， ``all_beams=True`` 时 *不要使用波束并行* ，建议先对M01单独处理，这样会生成'xxx-M01-xxx-19rfi.hdf5'后缀的文件(可能比较慢)，后续的处理会直接应用19rfi文件。
      如果用了并行，则会产生大量的19rfi文件，后续的处理则会 *报错* (因为当前输出路径下只应该有一个19rfi文件)。 *所以如果不熟悉此功能的话请谨慎使用。*

人工标记的RFI
^^^^^^^^^^^^^
首先是先标记人工标记过的RFI。标记方法见/工具/手动标记RFI

- ``--reg_from``参数以下用法：
   -  ``none``：不做任何处理。
   -  ``default``: 将寻找名为 输入文件名+'.reg'的DS9格式region文件。如果未发现则跳过。适合用于只有个别波束有问题的RFI。
   -  ``shared``: 一些波束将会共用同一个region文件，适合用于RFI同时出现的一些波束。 
         - ``--reg_shared_beams``：
             用于指定哪些波束会共用同一个名称为‘*-19rfi.hdf5.reg'的且输出路径下唯一的region文件，默认为 ``all``,即19波束都需要。这也就要求在xxx-M01-xxx-19rfi.hdf5上进行人工标记才行。
             
             如果是逗号间隔的字符串，如 ``--reg_shared_beams 4,9,14``，则只有遇到4,9,14三个波束才会应用后缀与输入文件相同的且输出路径下唯一的region文件。这也就要求在*-bld.hdf5(类似的)上进行人工标记才行。
         
         听起来很复杂对不对？RFI就是很难搞，俺也想减轻人工工作量。。。

   -  ``路径``: 直接输入一个reg文件路径

`lf`, `sf`, `nr` 的搜索原理
^^^^^^^^^^^^^
bulabula



`lf`: Long-freq time RFI
^^^^^^^^^^^^^
频率范围很大的时域RFI，可能是低赤纬的同步卫星导致的。高赤纬一般看不到，所以设成False。

具体参数见示例notebook：
- ``--lf``: 设为True时标记\ *长RFI*。
    *  ``--lf_frange``: 在此频率区间寻找 *长RFI*
    *  ``--lf_ext_add``: 向两边扩大RFI的标记范围。
    *  ``--lf_mask_rms_times``: 
         如果是-1，会标记整条谱线；
         如果为0，只标记存在RFI谱线的frange区域(不过注意如果frange区域占比过大，余下的部分做FFT去驻波效果可能变差)；
         如果大于0，则只标记存在RFI谱线的大于RMS一个倍数阈值的部分，频率方向用ext_add扩展边缘。

`sf`: Short-freq time RFI
^^^^^^^^^^^^^^
短横条样子的时域RFI，是GPS L3导致的，常常出没于1380~1382MHz，影响附近的3~10MHz。

具体参数见示例notebook：
- ``--sf``: 设为True时标记\ *短RFI*。
   * ``--sf_frange``: 在此频率区间寻找 *短RFI*
   * ``--sf_ext_add``: 向两边扩大RFI的标记范围，单位为channel数。
   * ``--sf_mask_rms_times``: 这里是一个正数，mask小区间frange内，从rfi峰值向两边以半高全宽扩展，为了防止mask过多，通常扩展到2~2.5倍的RMS停止。

`nr`: Narrowband RFI
^^^^^^^^^^^^^^
单通道RFI

具体参数见示例notebook：
- ``--nr``: 设为True时标记\ *窄RFI*。观测数据为W带的情况下， *窄RFI* 一般占据一到两个channel。
   * ``--nr_mask_rms_times``: 如果是0，会标记整个通道；如果大于0，则只标记存在RFI通道的大于RMS一个倍数阈值的部分，时间方向用ext_add扩展边缘。

`pr`: periodic RFI
^^^^^^^^^^^^^^
8.1 MHz周期RFI，2021年7月后就没有了。

去除参数过多难以详细介绍，这里只说原理是从
  

.. - ``--pr``: 设为True时，比较两个偏振，如果偏差过大则标记对应channel为RFI。

..    *  ``--pr_s_sigma``: 沿时间维度高斯平滑（以pr_s_sigma为sigma）谱线以提高信噪比
..    *  ``--pr_times``: 至少大于等于5
..    *  ``--pr_times_s``: 大于1

.. - ``--tr``: 设为True时，通过找出每条谱线超出噪音的“信号”，然后在沿时间轴比较，如果一个“信号”持续很久(大于\ ``--tr_n_continue``)，则认为是RFI。不适用于银河系频段。

..    -  ``--tr_s_sigma``: 沿时间维度高斯平滑（以tr_s_sigma为sigma）谱线以提高信噪比
..    -  ``--tr_times``: 至少大于等于5
..    -  ``--tr_times_s``: 大于1.5
..    -  ``--tr_n_continue``: 一个“信号”持续多少条就标记为rfi


 


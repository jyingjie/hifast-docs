hifast.rfi 标记RFI
====================

``hifast.rfi`` : 标记RFI

-  示例：

   .. code-block:: bash

      fname=XXX-bld.hdf5
      python -m hifast.rfi $fname --nr True --sf True --lf False --all_beams False

-  输入去完基线得到的文件。目前不能处理频率在1155到1295MHz之间的RFI。
  
    .. figure:: download/rfi.png

       RFI示意图。A: 窄RFI, B: 短RFI, C: 银河系, D: 长RFI

-  输出文件名中包含 ``-rfi``。

-  示例Notebook：:download:`hifast.rfi_example.ipynb <examples/example1/hifast.rfi_example-20230309.ipynb>`


RFI类型参数与优先顺序
-------------------------

- 主要参数:
   一般来说优先选用 ``--nr``, ``--sf``, 谨慎使用 ``--pr``，非低赤纬不要使用 ``--lf``
- 通用参数：
   -  ``--replace_rfi``: 是否将输出的RFI设为NAN

   -  ``--rms_frange``:
      计算rms用的频率范围，选一个没有信号和干扰范围。
      例如\ ``--rms_frange 1400 1410``。不指定则会尝试自动判定。
      ``--nr``, ``--sf`` 为True时需要此参数。
   -  ``--mw_frange``:
      一个大致的银河系范围，防止把它当成RFI

   -  ``--all_beams``: 
      将19波束做一个平均，更容易找出19波束同时存在的RFI。目前用于``--sf``和人工标记环节。
      *请注意*， ``all_beams=True`` 时 *不要使用波束并行* ，建议先对M01单独处理，这样会生成'xxx-M01-xxx-19rfi.hdf5'后缀的文件(可能比较慢)，后续的处理会直接应用19rfi文件。
      如果用了并行，则会产生大量的19rfi文件，后续的处理则会 *报错* (因为当前输出路径下只应该有一个19rfi文件)。 *所以如果不熟悉此功能的话请谨慎使用。*

- hifast.rfi.py处理的优先级顺序：
   - 人工标记的RFI
   - ``lf``: Long-freq time RFI. 类似于上图中频率范围很大的时域RFI，可能是卫星
   - ``sf``: Short-freq time RFI. 类似于上图中1380MHz的频率范围很小的时域RFI，主要是GPS
   - ``tr``: Time domain continuous RFI. 时域上连续出现的RFI。最早为8MHz的RFI设计，可能标记不全所以现在 *不推荐使用*了。
   - ``nr``: Narrowband single channel RFI. 单通道频域RFI，如上图的竖线
   - ``pdr``: Periodic 8 MHZ RFI. 间隔8MHz的高斯型RFI，来自于压缩机，2021年7月已消除
   - ``pr``: Polarized RFI. 偏振上差异过大的RFI


人工标记的RFI
^^^^^^^^^^^^^
首先是先标记人工标记过的RFI。标记方法见/工具/手动标记RFI

- ``--reg_from`` 参数有以下用法：
   -  ``none``：不做任何处理。
   -  ``default``: 将寻找名为 输入文件名+'.reg'的DS9格式region文件。如果未发现则跳过。适合用于只有个别波束有问题的RFI。
   -  ``shared``: 一些波束将会共用同一个region文件，适合用于RFI同时出现的一些波束。 
      ``--reg_shared_beams``：
          用于指定哪些波束会共用同一个名称为‘*-19rfi.hdf5.reg'的且输出路径下唯一的region文件，默认为 ``all``,即19波束都需要。这也就要求在xxx-M01-xxx-19rfi.hdf5上进行人工标记才行。
      
          如果是逗号间隔的字符串，如 ``--reg_shared_beams 4,9,14``，则只有遇到4,9,14三个波束才会应用后缀与输入文件相同的且输出路径下唯一的region文件。这也就要求在*-bld.hdf5(类似的)上进行人工标记才行。
         
         听起来很复杂对不对？RFI就是很难搞，俺也想减轻人工工作量。。。

   -  ``路径``: 直接输入一个reg文件路径

lf, sf, nr 的搜索原理
^^^^^^^^^^^^^
- 他们三个看似参数复杂，实则都共用了同一个函数/原理。它们的共同参数是：

   *  ``lf_frange``, ``sf_frange``: 在此频率区间寻找RFI，即只对这个频率区间做平均。nr则是对所有时间做平均。
   *  ``--lsn_thr_type``: 阈值的选取方法，默认设为 ``input_absmed_times``即使用中值的绝对值作为阈值。
   *  ``--lf_mean_times``, ``--sf_mean_times``, ``--nr_mean_times``: 通过平均后的找到异常谱线/通道所需的阈值
   *  ``--lf_diff_times``, ``--sf_diff_times``, ``--nr_diff_times``: lf的rfi边界平缓(所以设为0).sf和nr边缘一般比较陡峭，所以用平均后谱线的差的绝对值来限定陡峭的为sf/nr，防止标记可能的信号。
   *  ``--lf_rfi_last``, ``--sf_rfi_last``, ``--nr_rfi_width_lim``: rfi的持续时间(条数)/宽度(通道数)，lf通常较宽，nr则非常窄
   *  ``--lf_ext_add``, ``--sf_ext_add``: 向两边扩大RFI的标记范围，单位为channel数。

- 以sf为例

   .. figure:: download/1380RFI.png

      这张图片代表了标记1380MHz RFI的方法,即``--sf`` 

- 输出
   .. code-block:: bash
      
      rfi starts at tn = [4886 5684 6063], ends in tn = [5030 5759 6137]
      After extension, rfi starts at tn = [4883 5681 6060], ends in tn = [5033 5762 6140]
      Median value is 0.00793326087296009. mean_thr = 0.023799782618880272. diff_thr = 0.0006346608698368073
      INFO: Looking for short-freq time RFI in [1378, 1385] ... [hifast.ripple.mark_timeRFI]
      tn = [4882, 5034] mask frange: [1375.28610229 1386.79122925]
      tn = [5680, 5763] mask frange: [1376.3885498  1386.84082031]
      tn = [6059, 6141] mask frange: [1376.98745728 1384.87625122]
      Found :D
      Finish

   
- 图中蓝色线是frange内所有谱线沿频率方向的平均， 平均阈值(黑色虚线)为中值的 ``--xx_mean_times``倍；

- 绿色线是后一个通道减前一个通道取绝对值，sf会需要此作为差的阈值(黑色虚线)，为中值的 ``--xx_diff_times``倍。

- 画图时绿线有向下平移一个蓝线的最大值，为了把它们画在一个图里。

- ``rfis start at ... end in ...``表示有哪些谱线满足了rfi_width_lim和大于times倍阈值条件，最后输出的只有3个mask frange，说明最后有三个满足边缘陡峭条件.

- 橙色线为标记的范围。

*可以通过示例Notebook了解具体参数*，这里建议不熟悉的话还是通过Jupyter先调参.

lf: Long-freq time RFI
^^^^^^^^^^^^^
频率范围很大的时域RFI，可能是低赤纬的同步卫星导致的。高赤纬一般看不到，所以设成False。

具体参数见示例notebook：

- ``--lf``: 设为True时标记\ *长RFI*。

    *  ``--lf_mask_rms_times``: 如果是-1，会标记整条谱线；如果为0，只标记存在RFI谱线的frange区域(不过注意如果frange区域占比过大，余下的部分做FFT去驻波效果可能变差)；如果大于0，则只标记存在RFI谱线的大于RMS一个倍数阈值的部分，频率方向用ext_add扩展边缘。

sf: Short-freq time RFI
^^^^^^^^^^^^^^
短横条样子的时域RFI，是GPS L3导致的，常常出没于1380~1382MHz，影响附近的3~10MHz。

具体参数见示例notebook：

- ``--sf``: 设为True时标记\ *短RFI*。

   * ``--sf_mask_rms_times``: 这里是一个正数，mask小区间frange内，从rfi峰值向两边以半高全宽扩展，为了防止mask过多，通常扩展到2~2.5倍的RMS停止。 

nr: Narrowband RFI
^^^^^^^^^^^^^^
单通道RFI

具体参数见示例notebook：

- ``--nr``: 设为True时标记\ *窄RFI*。观测数据为W带的情况下， *窄RFI* 一般占据一到两个channel。

   * ``--nr_mask_rms_times``: 如果是0，会标记整个通道；如果大于0，则只标记存在RFI通道的大于RMS一个倍数阈值的部分，时间方向用ext_add扩展边缘。


pdr: Periodic RFI
^^^^^^^^^^^^^^
8.1 MHz周期RFI，2021年7月后就没有了。

去除参数过多, notebook有详细介绍，这里只说原理：
从超过噪声一定水平的所有峰中选取最大的一个，在其前后范围内以大约8.1MHz的间隔寻找同样超过噪声水平的峰，
列为一组。余下的用相同的方法再选出第二组，第三组。
通过最小二乘拟合得到每组RFI的精确频率，然后依据推测的频率标记RFI的范围。
  
pr: Polarized RFI
^^^^^^^^^^^^^^
利用两个偏振XX,YY差别很大来判断是否是RFI。需要注意有时银河系也可能被标记，请小心使用。
但是pr对于偏振差异极大的RFI还是好用的，RFI边缘则容易标记不全。

- ``--pr``: 设为True时，比较两个偏振，如果偏差过大则标记对应channel为RFI。

   *  ``--pr_s_sigma``: 沿时间维度高斯平滑（以pr_s_sigma为sigma）谱线以提高信噪比
   *  ``--pr_times``: 至少大于等于5
   *  ``--pr_times_s``: 大于1


.. - ``--tr``: 设为True时，通过找出每条谱线超出噪音的“信号”，然后在沿时间轴比较，如果一个“信号”持续很久(大于\ ``--tr_n_continue``)，则认为是RFI。不适用于银河系频段。

..    -  ``--tr_s_sigma``: 沿时间维度高斯平滑（以tr_s_sigma为sigma）谱线以提高信噪比
..    -  ``--tr_times``: 至少大于等于5
..    -  ``--tr_times_s``: 大于1.5
..    -  ``--tr_n_continue``: 一个“信号”持续多少条就标记为rfi

Tips
--------
- 建议先用M01测试，如果希望sf都被标记而没有遗漏，可以尝试使用 ``--all_beams``,之后 ``--sf_use_time_only``可以直接使用xxx-M01-xxx-19rfi中标记了的条数但是mask范围分波束确定。如果不熟悉还是不要``--all_beams``，使用各自波束确定mask范围。

- 如果有很长频率的RFI(可能比较窄，就几百条，应该也是卫星导致的，类似于连续谱)会导致sf标记多，建议此时先手动CARTA标记，然后再跑sf。如果只是个别波束有问题，也不要使用 ``--all_beams``，可能连累其他波束。

- 建议使用hifast.waterfall检查mask的效果(mask过多过少)，必要时可以生成cube后人工检查，迭代以上过程。

   .. code-block:: bash

      fname=XXX-bld-rfi.hdf5
      python -m hifast.waterfall $fname --outdir ./waterplot/ --replace_rfi --polar -1


 
wrote by astroR2, 2023/3/9

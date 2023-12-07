``hifast.cube`` 栅格化生成Data Cube
=====================================

``hifast.cube``

::

   python -m hifast.cube **/data/*-fc*.hdf5 --outname ./test_cubes.fits --bwidth 60 -p SIN


处理流程
----------------------

1. 输入经过多普勒(坐标系)修正后的谱线文件，文件名字中包含 ``-fc`` 。(目前需要所有文件中的谱线采样时间一致)
2. 读取输入文件的坐标信息，以此生成 ``WCS`` 头文件，即RA-DEC平面网格。网格点的间隔由 ``--bwidth`` 指定。
   默认 ``WCS`` 的RA和DEC范围由输入的文件决定，也可以通过 ``--ra_range`` 和 ``--dec_range`` 指定。
   
   - ``--type3``： 第三轴： ``vopt``， ``vrad`` 或 ``freq`` (默认: ``vrad``)
   - ``--range3``： 第三轴的范围 (默认: None)
   - ``-p``： 天球投影方式。参见 arXiv:astro-ph/0207413，第 7.2 节。投影的选择 (默认: AIT)
  
3. “卷积”
   - ``--r_cut``：每个格点用到的谱线距离其中心的距离在此范围内，单位：角秒。
   - ``--beam_fwhw``: 望远镜波束大小（全宽半高）；单位：角分 (默认: 2.9)
   - ``--method``：卷积核类型 ``gaussian``， ``bessel_gaussian`` 或 ``sinc_gaussian`` (默认: ``gaussian``, Mangum et. al. arXiv:0709.0553)
      * ``gaussian``: 用到参数：
  
        - ``--gaussian_fwhw``: 单位：角分；默认： ``beam_fwhw/2``
        - ``--r_cut``: 此时默认为 ``3*gaussian_sigma``，即 ``3*(gaussian_fwhw/(sqrt(8ln(2))))``
      * ``bessel_gaussian``: 用到参数：
  
        - ``--bsize``: 单位：角分；默认： ``1.55*beam_fwhw/3``
        - ``--gsize``: 单位：角分；默认： ``2.52*beam_fwhw/3``
        - ``--r_cut``: 此时默认为 ``3.8317059702075*bsize/pi``
      * ``sinc_gaussian``: 用到参数：

        - ``--bsize``: 单位：角分；默认： ``1.55*beam_fwhw/3``
        - ``--gsize``: 单位：角分；默认： ``2.52*beam_fwhw/3``
        - ``--r_cut``: 此时默认为 ``bsize``
   - ``--frac_finite_min FRAC_FINITE_MIN``: 假设某个格点在 ``r_cut`` 内有 ``n`` 条光谱，如果某个频率（通道）中的 ``finite value`` （非nan且非无穷） 的数量小于 ``FRAC_FINITE_MIN * n``，则该通道的输出值将被设置为 ``nan`` (默认: 1)
   - ``--polar {XX,YY,M}``: 极化 (默认为 ``M`` , 即为合并两个偏振。)

参数
------

使用命令 ``python -m hifast.cube -h | more`` 查看更多参数说明。
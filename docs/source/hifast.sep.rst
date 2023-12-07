``hifast.sep`` 噪音管定标
=======================

``hifast.sep`` 用于处理一个波束的原始数据，它可以将噪音管的开启（Cal on）和关闭（Cal off）的原始谱线数据分离，并利用噪音管数据计算出天线温度。

处理流程
--------
   1. FAST的数据中，每个波束被存储为多个文件块，文件名以 ``0001.fits——9999.fits`` 结尾。
      本程序只需要输入第一个文件块的路径（例如 ``/proj/20211205/XXX_arcdrift-M02_F_0001.fits``），程序将按顺序读取和处理这些文件。
   2. 通过使用三个整数参数 ``-d, -m, -n`` 来确定噪音管开关的周期，这三个参数分别代表延迟时间、Cal on时间和Cal off时间除以谱线的采样时间。(\ :doc:`示例 <noise_paras>`\ )
   3. 将功率转换为天线温度
   
      .. math::

        T_\mathrm{a}^{\mathrm{cal\_off}}(\nu) &= \frac{{P_{\mathrm{cal\_off}}}(\nu)}{P_{\mathrm{cal}}(\nu)_{\mathrm{smooth}}} \times T_{\mathrm{cal}}(\nu)_{\mathrm{smooth}},\\
        T_\mathrm{a}^{\mathrm{cal\_on}}(\nu) &= \frac{{P_{\mathrm{cal\_on}}}(\nu)}{P_{\mathrm{cal}}(\nu)_{\mathrm{smooth}}} \times T_{\mathrm{cal}}(\nu)_{\mathrm{smooth}} - T_{\mathrm{cal}}(\nu)_{\mathrm{smooth}}
   
      上述公式得到了不包括噪音管贡献的天线温度。此过程需要噪音管温度 :math:`T_{\mathrm{cal}}` 和 噪音管的响应 :math:`P_{\mathrm{cal}}` 。
     
     - :math:`T_{\mathrm{cal}}` 使用FAST官方提供的噪音管温度文件。
  
       -  ``--noise_mode``: 观测时用的噪音管强度。high 或 low，默认值 high。
       -  ``--noise_date``: 选用哪天的噪音温度文件。例如 20190115，参见 :ref:`Tcal数据配置 <_label-tcal_file>` 。
                            如果设为 auto，则选取与谱线观测时间最近的噪音温度文件来定标。


     - :math:`P_{\mathrm{cal}}` 是通过使用噪音管 Cal_on 的谱线功率，并减去相邻的 Cal_off 的谱线功率得到的。噪音管一般间隔几分钟开启几秒，因此每个周期都能得到一条 :math:`P_{\mathrm{cal}}`：
      
       - 检查每条 :math:`P_{\mathrm{cal}}` （ ``--check_cal A``，目前仅支持噪音管 Cal_off 的谱线采样数量 ``-n`` 大于6 ）
       
         噪音管可能开在了连续频谱源上，或者受到射频干扰（RFI）的污染，这样就无法使用。程序目前通过比较噪音管 Cal_on 附近的几条 Cal_off 的变化来判断，要求这个变化要小于指定的阈值。
         判断时先把谱线按频率分 bin （ ``--freq_step_c`` ），每个 bin 里 Cal_off 的变化比例大于 ``--pcal_vary_lim_bin`` 就会被标记为损坏，
         如果一条噪音管 Cal_on 有太多 bin 被标记（ ``--pcal_bad_lim_freq`` ），则整条被丢弃。
         输出类似下图的瀑布图展示检查结果：上面两个 panel 是原始的 :math:`P_{\mathrm{cal}}`，下面两个则显示了被 mask 后的；左右分别为两个偏振。

          .. figure:: download/sep-pcals.png
       
       - 每条谱线定标时使用哪条 :math:`P_{\mathrm{cal}}`？
  
         * 方法一：单独处理 ( ``--merge_pcals False`` )
     
           每条谱线使用最近的 :math:`P_{\mathrm{cal}}` （先对其平滑以降低泊松噪音）来进行定标。如果最近那条被标记为损坏，则延伸寻找最近没有被标记的那条。
           如果谱线和找到的 Cal_on 的距离超过 ``--cal_dis_lim``，则这条谱线的温度将被标记为 nan。（这个过程依据 ``--check_cal A`` 时的频率bin（ ``--freq_step_c``）分别处理。）。

           .. figure:: download/sep-pcals-smooth.png
           
         * 方法二：合并求频率依赖 ( ``--merge_pcals True`` )
     
           一段时间内，:math:`P_{\mathrm{cal}}` 随频率依赖比较稳定，只有整体幅度上的变化:
            
            .. math::

               P_{\mathrm{cal}}(t,\nu) = Amp(t)*F(\nu)

           因此可以合并（ ``--method_merge MergeFun``）所有 :math:`P_{\mathrm{cal}}` 降低泊松噪音（合并完依然需要做平滑）来得到 :math:`P_{\mathrm{cal}}` 随频率的依赖:
           
           .. math::

             F(\nu)_{\mathrm{smooth}} = \mathrm{SmooothFun}(\mathrm{MergeFun}(P_{\mathrm{cal,i}}(\nu)))
           
           然后每条与合并的幅度偏差为（ ``--squeeze_diff_freq SqueezeFreqFun``）：
           
           .. math::

             \mathrm{AmpDiff_{i}} = \mathrm{SqueezeFreqFun}(P_{\mathrm{cal,i}}(\nu) / F(\nu)_{\mathrm{smooth}})
             
          
          最后通过插值（ ``--method_interp InterpFun``）得到每条谱线 ``j`` 用到的 :math:`P_{\mathrm{cal}}` :
           
           .. math::
             P_{\mathrm{cal,j}}(\nu) = \mathrm{InterpFun}(\mathrm{AmpDiff_{i}})*F(\nu)_{\mathrm{smooth}}
          
          输出的图片展示了几条 :math:`P_{\mathrm{cal}}` 、合并后的（红线）、合并后并平滑的（黑线），以及各条偏离值的插值结果（下 panel）。
          
          .. figure:: download/sep-pcals-merged.png

         * 以上用到的平滑参数(SmooothFun)
       
           - ``--smooth``: 平滑方法。可以选择 gaussian, poly 或者 mean。需配合\ ``--frange``\ 进行设置。

           -  gaussian：适用于频率区间比较大，需要同时加\ ``--s_sigma``\ 参数，频率区间一般大于\ ``s_sigma``\ 的3倍。平滑结果在频率两端可能不太准确(另外hifast.sw用fft方法去驻波时两端效果也会差一些)，
              可以配合\ ``--ext_frange``\ 参数怎加处理频率范围，或者设置\ ``--frange``\ 时使用比科学需要更宽的频率范围，然后在成图前把两端去掉一点。
           -  mean:
              适用于频率区间（\ ``--frange``\ ）比较小（至少小于20）。对频率内的所有功率值进行平均。
           -  poly:
              适用于频率区间比较小。进行多项式拟合，需要同时加\ ``--s_deg``\ 参数，\ ``s_deg``\ 为
              1 时为线性拟合，为0时等同于mean， 默认值为1。

           -  ``--s_sigma``\ ：单位为MHz。\ ``--smooth gaussian``\ 时使用。

参数
------

使用命令 ``python -m hifast.sep -h | more`` 查看更多参数说明。

   - ``-d, -m, -n``: 分别代表延迟时间、Cal on时间和Cal off时间除以谱线的采样时间。可以从观测日志中获得: :doc:`示例 <noise_paras>`\  。
   -  ``--step`` ：每次读入内存的文件块数量。
   -  ``--frange``\ ：程序提取和处理的频率范围(单位MHz)：后接两个数，分别是频率的下限和上限(需配合\ ``--smooth``\ 来设置)。后面的大部分处理步骤也包含此参数。
   -  ``--ext_frange``\ ：后接True或者False，默认为True。如果为True，并且\ ``--smooth gaussian``\ ，则自动将\ ``frange``\ 前后扩大1个\ ``s_sigma``\ 。例如\ ``--frange 1350 1430``\ 和\ ``--s_sigma 5``\ 实际处理的频率区间为1345Mhz到1435Mhz。
   -  ``--dfactor``\ ：降低频率的采样率。例如\ ``--dfactor 16``\ ：每16个采样点平均以降低采样，\ ``--dfactor W``\ ：降低F带或N带采样到W带。
   -  ``--outdir`` ：输出文件存放的目录路径。这一步这个参数必须设置。
   -  ...

输出
-----

-  输出文件名以 ``specs_T.hdf5``\ 结尾。可以用h5py来读取。例如：
   
   .. code-block:: python

      import h5py
      f = h5py.File('data/XXX_arcdrift-M02_F-specs_T.hdf5', 'r')
      S = f['S']
      print(list(S.keys()))
      print(S['mjd'][:])

-  同时会输出图片用来检查Cal。
hifast.sep 噪音管定标
=======================

``hifast.sep`` : 处理一个beam的谱线数据，分开噪音管(Cal)
on和off的谱线，然后利用噪音管定出谱线的亮温度。

过程
-----
   1. FAST的数据里每个beam是存成了很多块文件，以0001.fits——9999.fits结尾。程序仅需要输入第一个块文件的路径，程序会从这个文件开始依次读取处理。
   2. 根据噪音管的开关周期来分离标记谱线。通过 ``-d, -m, -n``这三个整数参数来确定周期， 它们分别代表 delay时间、Cal on时间和Cal off时间除以谱线的采样时间。
   3. Power -> T
   
      .. math::

        T_\mathrm{a}^{\mathrm{cal\_off}}(\nu) &= \frac{{P_{\mathrm{cal\_off}}}(\nu)}{P_{\mathrm{cal}}(\nu)_{\mathrm{smooth}}} \times T_{\mathrm{cal}}(\nu)_{\mathrm{smooth}},\\
        T_\mathrm{a}^{\mathrm{cal\_on}}(\nu) &= \left (\frac{{P_{\mathrm{cal\_on}}}(\nu)}{P_{\mathrm{cal}}(\nu)_{\mathrm{smooth}}}-1 \right ) \times T_{\mathrm{cal}}(\nu)_{\mathrm{smooth}}
   
      定标通过以上公式。需要噪音管温度 :math:`T_{\mathrm{cal}}` 和 噪音管的响应 :math:`P_{\mathrm{cal}}` .
      
      
      
     - :math:`P_{\mathrm{cal}}` 是用噪音管Cal on的谱线Power，然后减去相邻的Cal off的谱线Power。
      
         - 检查 （ ``--check_cal A``，需要噪音管Cal_off的采样数量 ``-n`` 大于6 ）
         
           噪音管有可能打在了连续谱源上或者被RFI污染，这样就无法使用。
           程序通过比较噪音管Cal_on附近的几条Cal_off的变化来判断。判断时先把谱线按频率分bin （ ``--freq_step_c``），
           每个bin里Cal_off的变化比例大于 ``--pcal_vary_lim_bin`` 就会被标记为损坏，
           如果一条噪音管Cal_on有太多bin被标记（ ``--pcal_bad_lim_freq`` ），则整条被扔掉。
           
         
         - 分配给每条谱线

           * 单独处理 ( ``--merge_pcals False`` )
       
             每条谱线使用最近的 :math:`P_{\mathrm{cal}}` （先对其平滑以降低泊松噪音）来定标。如果最近那条被标记为损坏，则延申寻找最近没有被标记的那条。如果谱线和找到的Cal_on的
             距离超过 ``--cal_dis_lim``, 则这条谱线的温度将被标记为nan。（这个过程对每个频率采样分别处理。）。
             
           * 合并求频率依赖 ( ``--merge_pcals True`` )
       
             一段时间内，:math:`P_{\mathrm{cal}}` 随频率依赖比较稳定，只有整体幅度上的变化。因此可以合并（ ``--method_merge``）所有 :math:`P_{\mathrm{cal}}` 降低泊松噪音（
             合并完依然需要做平滑）来得到:math:`P_{\mathrm{cal}}` 随频率的依赖。而整体幅度则可以用每条的幅度（ ``--squeeze_diff_freq``）来插值（ ``--method_interp``）。
           
           * `用到的平滑参数`
         
             - ``--smooth``: 平滑方法。gaussian, poly 或者 mean。需配合\ ``--frange``\ 进行设置。

             -  gaussian：适用于freq区间比较大，需要同时加\ ``--s_sigma``\ 参数，freq区间一般大于\ ``s_sigma``\ 的3倍。平滑结果在频率两端会不太准(另外hifast.sw用fft方法去驻波时两端效果也会差一些)，可以配合\ ``--ext_frange``\ 参数来减轻这一影响。
             -  mean:
                适用于freq区间（\ ``--frange``\ ）比较小（至少小于20?）。对freq内的所有流量值平均。
             -  poly:
                适用于freq区间比较小。多项式拟合，需要同时加\ ``--s_deg``\ 参数，\ ``s_deg``\ 为
                1 时为线性拟合，为0时等同于mean， 默认值为1。

             -  ``--s_sigma``\ ：单位为MHz。\ ``--smooth gaussian``\ 时使用，一般设为5或者10。

     - :math:`T_{\mathrm{cal}}` 使用FAST提供的文件。
  
        -  ``--noise_mode``: 噪音管强度。 high 或者 low，默认为high。
        -  ``--noise_date``: 选用哪天的噪音温度文件。例如设为 20190115 或
           20200531.
           如果设为auto则选取与谱线观测时间最近的噪音管文件来定标。(20200531的噪音管文件Beam19
           XX 偏振 在约1060MHz处有个大的gap。)   

其他参数
------
   -  ``--step`` ：每次读入内存的块文件数量。

   -  ``--frange``\ ：程序提取和处理的频率范围(单位MHz)：后接两个数，分别是频率的下限和上限(需配合\ ``--smooth``\ 来设置)。后面的大部分处理步骤也包含此参数。
   -  ``--ext_frange``\ ：后接True或者False，默认为True。如果为True，并且\ ``--smooth gaussian``\ ，则自动将\ ``frange``\ 前后扩大1个\ ``s_sigma``\ 。例如\ ``--frange 1350 1430``\ 和\ ``--s_sigma 5``\ 实际处理的频率区间为1345Mhz到1435Mhz。
   -  ``--dfactor``\ ：降低频率的采样率。例如\ ``--dfactor 16``\ ：每16个采样点平均以降低采样，\ ``--dfactor W``\ ：降低F带或N带采样到W带。
   -  ``--outdir`` ：输出文件存放的目录路径。这一步这个参数必须设置。
   -  ...



输出
-----

-  输出文件名以 ``specs_T.hdf5``\ 结尾。可以用h5py来读取。例如：

   >>> import h5py
   >>> f = h5py.File('data/XXX_arcdrift-M02_F-specs_T.hdf5','r')
   >>> S = f['S']
   >>> print(S.keys())
   >>> S['mjd'][:]

-  同时会输出pdf图片用来检查Cal。
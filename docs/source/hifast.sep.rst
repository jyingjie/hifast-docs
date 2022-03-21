hifast.sep 噪音管定标
=======================

``hifast.sep`` : 输入一个beam的谱线数据，分开噪音管(Cal)
on和off的谱线，然后利用噪音管定出谱线亮温度。

-  示例

   .. code-block:: bash

      fname="/data/fast_data/3047/GAMA_G15/20191215/XXX_0001.fits"
      python -m hifast.sep $fname -d 0 -m 1 -n 120 --step 5 --frange 1329 1429 --smooth poly --s_deg 1 --outdir ./data
      # or
      python -m hifast.sep $fname -d 0 -m 1 -n 120 --step 5 --frange 1020 1445 --smooth gaussian --s_sigma 5 --outdir ./data
      # or 
      #对于F或N带，可以加 --dfactor W 降低采样到 W 带，减小文件大小，提高信噪比。
      python -m hifast.sep $fname -d 0 -m 1 -n 120 --step 5 --frange 1020 1445 --smooth gaussian --s_sigma 5 --dfactor W --outdir ./data

   程序先找到所有噪音管Cal on的谱线，然后减去相邻的Cal
   off的谱线得到Cal的Power。然后每条谱线使用时间上最近的Cal
   Power结合噪音管温度文件(Tcal)得出每条谱线的亮温度（两个偏振分开处理）。

   在每一个Cal on off的周期里, 定标得到的温度在不同频率的值为

-  后面接是数据文件的绝对路径。
   FAST的数据里每个beam是存成了很多块文件，以0001.fits——9999.fits结尾。这里仅需要给第一个块文件的文件名即可，程序会从第一个文件开始依次读取处理。

-  主要参数：

   -  ``-d -m -n``\ ：后面分别指定一个整数， 分别为delay时间、Cal
      on时间和Cal off时间除以谱线的采样时间。delay默认为0。
   -  ``--noise_mode``: 噪音管强度。 high 或者 low，默认为high。
   -  ``--noise_date``: 选用哪天的噪音温度文件。例如设为 20190115 或
      20200531.
      如果设为auto则选取与谱线观测时间最近的噪音管文件来定标。(20200531的噪音管文件Beam19
      XX 偏振 在约1060MHz处有个大的gap。)
   -  ``--step`` ：每次读入内存的块文件数量。
   -  ``--frange``\ ：程序提取和处理的频率范围：后接两个数，分别是频率的下限和上限(需配合\ ``--smooth``\ 来设置)。后面的大部分处理步骤也包含此参数。
   -  ``--smooth``: 平滑方法。gaussian, poly 或者 mean。用来对Cal
      Power和Cal
      Temperature沿频率轴进行平滑以提高信噪比。需配合\ ``--frange``\ 进行设置。

      -  gaussian：适用于freq区间比较大，需要同时加\ ``--s_sigma``\ 参数，freq区间一般大于\ ``s_sigma``\ 的3倍。平滑结果在频率两端会不太准(另外hifast.sw用fft方法去驻波时两端效果也会差一些)，可以配合\ ``--ext_frange``\ 参数来减轻这一影响。
      -  mean:
         适用于freq区间（\ ``--frange``\ ）比较小（至少小于20?）。对freq内的所有流量值平均。
      -  poly:
         适用于freq区间比较小。多项式拟合，需要同时加\ ``--s_deg``\ 参数，\ ``s_deg``\ 为
         1 时为线性拟合，为0时等同于mean， 默认值为1。

   -  ``--s_sigma``\ ：单位为Mhz。\ ``--smooth gaussian``\ 时使用，一般设为5或者10。
   -  ``--ext_frange``\ ：后接True或者False，默认为True。如果为True，并且\ ``--smooth gaussian``\ ，则自动将\ ``frange``\ 前后扩大1个\ ``s_sigma``\ 。例如\ ``--frange 1350 1430``\ 和\ ``--s_sigma 5``\ 实际处理的频率区间为1345Mhz到1435Mhz。
   -  ``--check_cal``:
      扫描模式(OTF或Drift)使用此参数。如果设置为\ ``A``, 会检查Cal
      on周围的几条Cal off谱线的最大差别不超过5%，若超过，则不会使用此Cal
      on来定标。
   -  ``--dfactor``\ ：降低频率的采样率。例如\ ``--dfactor 16``\ ：每16个采样点平均以降低采样，\ ``--dfactor W``\ ：降低F带或N带采样到W带。
   -  ``--outdir`` ：输出文件存放的目录路径。这一步这个参数必须设置。

-  输出文件名以 ``specs_T.hdf5``\ 结尾。可以用h5py来读取。例如：

   ::

       import h5py
       f= h5py.File('data/XXX_arcdrift-M02_F-specs_T.hdf5','r')
       S=f['S']
       print(S.keys())
       S['mjd'][:]

-  同时会输出pdf图片用来检查Cal on off的分离是否正确。
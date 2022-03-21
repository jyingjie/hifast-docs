hifast.radec 坐标转换
======================


``hifast.radec``: 转换馈源（KY）位置到RA DEC

-  示例

.. code-block:: bash

   python -m hifast.radec data/XXX_arcdrift-M01_F-specs_T.hdf5
   # or
   python -m hifast.radec XXX_arcdrift_11_2020_XX_XX_22_54_09_000.xlsx

-  输入 ``hifast.sep``\ 生成的hdf5文件，\ **仅需beam
   M01的即可**\ ，其它beam的RA DEC会存在这同一个文件里。
   或者输入一个.xlsx结尾的馈源舱文件来计算馈源舱文件里记录时间点对应的RADEC。

-  程序会先依次检测是否存在
   *``your_HOME_dir/KY/``*\ (本地处理时建立此目录，FAST服务器上不要建立此目录),
   *``/data/hw1/FAST/KY/``*, *``/data31/KY/``*
   (FAST服务器馈源文件所在目录)文件夹。
   然后在最先检测到存在的文件夹里自动寻找对应的馈源舱文件。然后计算馈源舱文件文件里记录的RA
   DEC，由于谱线记录的时间采样点和馈源舱文件的不一致，因此会插值最后得到谱线的RA
   DEC。

-  主要参数：

   -  ``--ky_files``\ ：如果程序不能成功找到对应馈源舱文件，加此参数来手动指定馈源舱文件。参数后加馈源舱文件的路径，一个或多个。
   -  ``--tol``:
      正常情况下，馈源舱文件内记录的时间覆盖谱线记录的时间范围。加\ ``--tol 5``\ 可在馈源舱文件少记录\ ``5``\ 秒的情况下进行外插计算RA
      DEC。不过这部分谱线最终需扔掉。
   -  ``--outdir``
      ：指定输出文件存放的目录。如果输入hdf5文件默认与输入文件一致，如果输入.xlsx文件则默认为程序运行路径。
   -  ``--ky_fixed``:
      早期的一些Drift观测，馈源舱文件只记录开始的几分钟内的馈源舱位置，加此参数只利用这开始的几分钟来计算整个谱线的RA-DEC。由于Drift过程中馈源舱并不能完全稳定不动，这样计算出的RA
      DEC可能会不准确。(一般不建议使用)
   -  ``--plot``\ ：加此参数来画RA DEC分布图，保存为pdf图片。

-  存放radec的输出文件名是在输入文件名上加radec。可以h5py来读取，例如：

   ::

      import h5py
      f= h5py.File('data/XXX_arcdrift-M01_F-specs_T-radec.hdf5','r')
      S=f['S']
      print(S.keys())
      S['mjd'][:]
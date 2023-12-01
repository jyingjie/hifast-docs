``hifast.radec`` 坐标转换
======================

``hifast.radec``: 将天区（Right Ascension, Declination）坐标进行转换

-  示例

.. code-block:: bash

   python -m hifast.radec data/XXX_arcdrift-M01_F-specs_T.hdf5
   # 或者
   python -m hifast.radec XXX_arcdrift_11_2020_XX_XX_22_54_09_000.xlsx

-  可以输入两种文件路径:
  
   - 输入 ``hifast.sep`` 生成的 ``hdf5`` 文件，**仅需要 M01 波束的文件**，
     其他波束的天区坐标将存在同一个文件中。
   - 输入以 ``.xlsx`` 结尾的馈源舱文件，计算其中记录的时间点对应的天区坐标。

-  程序首先依次检测是否存在以下文件夹：
   ``your_HOME_dir/KY/`` （本地处理时需创建此目录，FAST服务器上则不需要）,
   ``/data/hw1/FAST/KY/``, ``/data31/KY/``
   （FAST服务器上馈源文件存放目录）。然后程序会自动在首个检测到的文件夹中查找对应的天区文件。
   随后，程序将计算馈源文件中记录的 Right Ascension 和 Declination。由于频谱记录的时间采样点与馈源文件中的不一致，因此将进行插值以获得最终的谱线的天球坐标。

-  主要参数：

   -  ``--ky_files`` ：如果程序自动找到对应的馈源文件，可以使用此参数手动指定馈源文件的路径。可以指定一个或多个文件。
   -  ``--tol``:
      正常情况下，馈源文件中记录的时间范围将覆盖观测谱线记录的时间范围。加上 ``--tol 5`` 可允许在天区文件记录缺少 5 秒的情况下进行外插计算 Right Ascension 和 Declination使得程序能够运行。
      但最终外插坐标的谱线数据需要扔掉。
   -  ``--outdir``：
      指定输出文件存放的目录。如果输入为 hdf5 文件，则默认与输入文件相同；如果输入为 .xlsx 文件，则默认为程序运行路径。
   -  ``--ky_fixed``:
      在早期的一些 Drift（漂移）扫描中，馈源文件仅记录了开始几分钟内的天区位置。使用此参数将仅利用这几分钟内的馈源位置记录来计算整个频谱的 Right Ascension 和 Declination。
      需要注意的是，在漂移过程中，馈源可能并不会完全稳定不动，因此利用此方法计算得到的天区坐标可能不够准确。（请谨慎使用）
   -  ``--plot`` ：使用此参数可绘制 Right Ascension 和 Declination 的分布图，并将其保存为图片文件。


参数
------

使用命令 ``python -m hifast.radec -h | more`` 查看更多参数说明。


输出
----------

存放天区坐标数据的输出文件名称是在输入文件名后附加后缀“-radec”。可使用 h5py 进行读取，例如：
   
   .. code-block:: python

      import h5py
      f = h5py.File('data/XXX_arcdrift-M01_F-specs_T-radec.hdf5', 'r')
      S = f['S']
      print(S.keys())
      S['mjd'][:]
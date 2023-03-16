瀑布图
======================

使用\ `CARTA <https://carta.readthedocs.io/en/latest/index.html>`__\
-----------------------------------------------------------------------------
1.  选中hdf5文件中的 ``HDU 0``
  
   .. figure:: download/CARTA_1.png

2. 如下图
   
   .. figure:: download/CARTA_2.png

hifast.waterfall
-----------------
``hifast.waterfall``: 画瀑布图保存成pdf

-  示例

  .. code-block:: bash

      python -m hifast.waterfall data_S/M33_OTF_1_MultiBeamOTF-M*_W-XXX-specs_T-flux.hdf5

-  输入hifast处理过程中生成的hdf5文件，可用通配符指定多个文件。
-  主要参数：

   -  ``-s``\ ：默认情况是把输入的文件分组，把同一天观测的19波束文件画到一张图上输出。
      加 ``-s`` 后每个文件单独画一张图保存在文件里。
   -  ``--vmin, --vmax``：图中colormap所用的数据区间。可以指定一个数字，也可以指定百分比。默认设置为
      ``--vmin per0.01 --vmax per95``。
   -  ``--interpolation``：即为plt.imshow里的参数。
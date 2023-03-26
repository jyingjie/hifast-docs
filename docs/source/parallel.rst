并行
====

hifast.sh 组合脚本
-------------------

绝大多数 ``hifast.xxx`` 命令只能处理一个beam的文件。下面 ####
用hifast.sh来对多个文件执行相同的\ ``python -m hifast.xxx``\ 操作

::

   hifast.sh /data/inspur_disk06/fast_data/3047/G15_drift_5/20200606/*_W*0001.fits -n 10 -c "python -m hifast.sep | -d 0 -m 1 -n 1  --step 5  --frange 1369 1394 --smooth poly --s_deg 1 --outdir ./data"

-  这里用通配符来指定19个beam的文件.

-  ``-c`` 参数指定用到的\ ``python -m hifast.xxx``\ 操作。 \ ``-c``
   后引号内的内容用 ``|`` 分割hifast命令和输入参数，省略输入的文件名。

-  ``-n`` 指定多少个文件同时执行。

-  另外可以用.txt文件来输入文件列表，用.par文件来输入要执行的命令。

   例如:

   -  *files.txt* 内容如下：

      ::

         /data/inspur_disk06/fast_data/3047/G15_drift_5/20200606/G15_drift_5_arcdrift-M01_W_0001.fits
         /data/inspur_disk06/fast_data/3047/G15_drift_5/20200606/G15_drift_5_arcdrift-M02_W_0001.fits
         /data/inspur_disk06/fast_data/3047/G15_drift_5/20200606/G15_drift_5_arcdrift-M03_W_0001.fits
         /data/inspur_disk06/fast_data/3047/G15_drift_5/20200606/G15_drift_5_arcdrift-M04_W_0001.fits
         /data/inspur_disk06/fast_data/3047/G15_drift_5/20200606/G15_drift_5_arcdrift-M05_W_0001.fits

   -  *commands.par* 内容如下：

   ::

      python -m hifast.sep | -d 0 -m 1 -n 1  --step 5  --frange 1369 1394 --smooth poly --s_deg 1 --outdir ./data

   -  可以执行：

   ``hifast.sh -i files.txt -n 10 -c commands.par``

hifast.sh 示例
--------------

- hifast.sh计算radec

  ::

     hifast.sh data/*M01*specs_T.hdf5 -c "python -m hifast.radec |  "

-  hifast.sh 组合 ``hifast.bld`` 和 ``hifast.multi``
  
  -  *commands.par* 内容如下：

  ::

     # 续行符 "\" 之后不能有空格
     python -m hifast.bld | --method arPLS --lam 1e7 --nproc 5 --outdir ./
     python -m hifast.multi  |  --tr --tr_method smooth --tr_s_sigma 5 --tr_n_continue 100 --fc \
           --keep_rfi --keep_polar

  -  执行：

  ``hifast.sh data/*M*specs_T.hdf5  -n 10 -c commands.par``
  先运行\ ``python -m hifast.bld``\ 这行去基线，然后\ ``hifast.sh``\ 会自动把生成的文件输入到\ ``python -m hifast.multi``
  这行。 注意 ``python -m hifast.bld``\ 这行执行时会占用 ``3 * 5 = 15``
  个线程。

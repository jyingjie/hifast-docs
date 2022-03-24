hifast.xxx 通用参数
=====================

-  大部分 ``hifast`` 的命令 ``hifast.xxx`` 可以在终端中用\ ``python -m hifast.xxx``\
   来执行，后面接 文件路径
   和\ ``-``\ 加一个字母或\ ``--``\ 加多个字符的参数。
-  ``python -m hifast.xxx -h`` 显示帮助。
-  生成的文件一般为hdf5格式, 在终端执行

   -  ``h5dump -g /Header XXX.hdf5`` 显示生成该文件时用的参数。
   -  ``h5dump -n XXX.hdf5`` 显示文件中有什么内容
   -  可以用 `CARTA2.0 <https://carta.readthedocs.io/en/latest/index.html>`__\ 打开查看“瀑布图(waterfall)”。




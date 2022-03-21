hifast.flux 流量定标
======================

``hifast.flux``: 流量定标Teff(K) → Flux(Jy/beam)

-  示例

::

   python -m hifast.flux data/XXX_arcdrift-M01_F-specs_T.hdf5

-  输入未流量定标的hdf5文件。程序会整合RADEC，在输入的文件的所在目录下去读取对应的radec的文件。即\ ``hifast.radec``\ 输出的文件名中有’M01’的radec文件。
   程序目前默认使用https://arxiv.org/abs/2002.01786
   中给出的Gain与天顶角的函数关系来流量定标。
-  其他参数：

   -  ``--cali_fname``\ ：此参数来指定当天定标源得出的Gain值(定标源的处理还在测试中，后续版本添加)。

hifast.bld 扣除基线
====
 

``hifast.bld`` : 拟合并扣除基线(**b**\ ase\ **l**\ ine\ **d**)。

-  示例

.. code-block:: bash

   python -m hifast.bld data/XXX_arcdrift-M01_F-specs_T-flux.hdf5 --method arPLS --nproc 5

-  输入
   ``hifast.sep``\ 产生的\ ``specs_T.hdf5``\ 文件或者\ ``hifast.flux``\ 产生的\ ``specs_T-flux.hdf5``\ 文件
   也可以输入它自己生成的文件，进行二次去基线。
-  拟合前处理

   -  沿时间轴对每个channel(freq);
      需要基线比较稳定，随时间变化小，谨慎使用

      -  ``--njoin``: 多少条谱线合并处理来拟合基线
      -  ``--s_method_t``: 沿时间轴平滑的方法
      -  ``--s_sigma_t``: 平滑尺度；\ ``--s_method_t`` 为
         median,gaussian,boxcar 卷积时使用

   -  沿频率轴对每条谱线

      -  ``--s_method_freq``: 每条谱线沿频率轴平滑方法
      -  ``--s_sigma_freq``:
         平滑尺度，单位是采样点的数量。一般W带可设为3,
         F和N带可设为48。\ ``--s_method_freq`` 为 median,gaussian,boxcar
         卷积时使用
      -  ``--average_every_freq``:
         沿频率轴每多少个点进行平均从而降低频率采样提高信噪比。

-  其他参数

   -  ``--nproc``: 后接一个数，使用多少个进程来并行。

   -  ``--frange``\ ：
      只用这个频率范围内谱线。后接两个数，空格隔开，下限在前。
      范围越大，拟合用时越长，并且不是线性增长。

   -  ``--method``: 拟合方法： ‘arPLS’, ‘srPLS’, ‘Chebyshev’, ‘poly’。

      ::

                     * 'arPLS'适合只有发射线的情况
                     * 'srPLS'适合发射线和吸收线，但是如果基线过于复杂则效果不好
                     * 'Chebyshev'和'poly'为多项式拟合，适用于基线比较简单的情况。

   -  ``--lam , --deg , --offset``\ ：
      去基线时的参数，–lam调整平滑度，越大越接近低阶多项式(poly)拟合。

   -  输出文件名会包含\ ``bld``\ 的hdf5文件。可以用h5py来读取。

-  在JupyterLab中交互调参

   -  ``-i``: 执行交互模式
   -  ``--length``: 每次用多少条谱线来测试，默认20
   -  ``--figsize``: 输出图片大小，为matplotlib中的参数。

   同时\ ``--nproc``\ 和\ ``--frange``\ 在这一模式中也支持 ## 拟合驻波

hifast.rfi 标记RFI
====================

``hifast.rfi`` : 标记RFI

-  示例：

   .. code-block:: bash

      fname=XXX-bld.hdf5
      python -m hifast.rfi $fname --nr True --sf True --sf_frange 1300 1500 --lf True

-  输入去完基线得到的文件。目前不能处理频率在1155到1295MHz之间的RFI。

-  主要参数，一般来说优先选用 ``--nr``, ``--sf``, ``--lf``  
   
   -  ``--rms_frange``:
      计算rms用的频率范围，选一个没有信号和干扰范围。
      例如\ ``--rms_frange 1400 1410``。不指定则会尝试自动判定。
      ``--nr``, ``--sf``, ``--lf`` 为True时需要此参数。
   - ``--nr``: 设为True时标记\ *窄RFI*。观测数据为W带的情况下， *窄RFI* 一般占据
     一到两个channel。
   - ``--sf``: 设为True时标记\ *短RFI*。

      * ``--sf_frange``: 在此频率区间寻找 *短RFI*
      * ``--sf_ext_add``: 向两边扩大RFI的标记范围，单位为channel数。

   - ``--lf``: 设为True时标记\ *长RFI*。
     
      *  ``--lf_frange``: 在此频率区间寻找 *长RFI*
      *  ``--lf_ext_add``: 向两边扩大RFI的标记范围。
  
   .. - ``--pr``: 设为True时，比较两个偏振，如果偏差过大则标记对应channel为RFI。

   ..    *  ``--pr_s_sigma``: 沿时间维度高斯平滑（以pr_s_sigma为sigma）谱线以提高信噪比
   ..    *  ``--pr_times``: 至少大于等于5
   ..    *  ``--pr_times_s``: 大于1

   .. - ``--tr``: 设为True时，通过找出每条谱线超出噪音的“信号”，然后在沿时间轴比较，如果一个“信号”持续很久(大于\ ``--tr_n_continue``)，则认为是RFI。不适用于银河系频段。

   ..    -  ``--tr_s_sigma``: 沿时间维度高斯平滑（以tr_s_sigma为sigma）谱线以提高信噪比
   ..    -  ``--tr_times``: 至少大于等于5
   ..    -  ``--tr_times_s``: 大于1.5
   ..    -  ``--tr_n_continue``: 一个“信号”持续多少条就标记为rfi

-  输出文件名中包含 ``-rfi``。



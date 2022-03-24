hifast.rfi 标记RFI
====================

``hifast.rfi`` : 标记RFI

-  示例：

   .. code-block:: bash

      fname=XXX-bld.hdf5
      python -m hifast.rfi $fname --pr True --pr_s_sigma 5 --pr_times 5 --pr_times_s 1.1
      #or
      python -m hifast.rfi $fname --tr True --tr_s_sigma 5 --tr_times 5 --pr_times_s 1.6 --tr_n_continue 50 --ext_add 0

-  输入去完基线得到的文件。目前不能处理频率在1155到1295MHz之间的RFI。

-  主要参数，一般来说优先选用 ``--nr``, ``--sf``, ``--lf``
  
   - ``--nr``: 设为True时标记\ *窄RFI*。观测数据为W带的情况下， *窄RFI* 一般占据
     一到两个channel。
   - ``--sf``: 设为True时标记\ *短RFI*。

      * ``--sf_frange``: 在此频率区间寻找 *短RFI*
      * ``--sf_ext_add``: 向两边扩大RFI的标记范围，单位为channel数。

   - ``--lf``: 设为True时标记\ *长RFI*。
     
      *  ``--lf_frange``: 在此频率区间寻找 *长RFI*
      *  ``--lf_ext_add``: 向两边扩大RFI的标记范围，单位为channel数。
  
   - ``--pr``: 设为True时，比较两个偏振，如果偏差过大则标记对应channel为RFI。

      *  ``--pr_s_sigma``: 沿时间维度高斯平滑（以pr_s_sigma为sigma）谱线以提高信噪比
      *  ``--pr_times``: 至少大于等于5
      *  ``--pr_times_s``: 大于1

   - ``--tr``: 设为True时，通过找出每条谱线超出噪音的“信号”，然后在沿时间轴比较，如果一个“信号”持续很久(大于\ ``--tr_n_continue``)，则认为是RFI。不适用于银河系频段。

      -  ``--tr_s_sigma``: 沿时间维度高斯平滑（以tr_s_sigma为sigma）谱线以提高信噪比
      -  ``--tr_times``: 至少大于等于5
      -  ``--tr_times_s``: 大于1.5
      -  ``--tr_n_continue``: 一个“信号”持续多少条就标记为rfi

-  输出文件名中包含 ``-rfi``。



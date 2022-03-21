hifast.rfi 标记rfi
====================

``hifast.rfi`` : rfi标记

-  示例：

   ::

      fname=XXX-bld.hdf5
      python -m hifast.rfi $fname --pr True --pr_s_sigma 5 --pr_times 5 --pr_times_s 1.1
      #or
      python -m hifast.rfi $fname --tr True --tr_s_sigma 5 --tr_times 5 --pr_times_s 1.6 --tr_n_continue 50 --ext_add 0

-  输入去完基线得到的文件。

-  参数

   -  ``--pr``, ``--tr`` 分别为 时域rfi和偏振rfi标记，会生成 is_rfi
      这项存在输出文件里。

      ``--pr True``: 比较两个偏振，如果偏差过大则标记对应channel为RFI。

      -  ``--pr_s_sigma``:
         沿时间维度高斯平滑（以pr_s_sigma为sigma）谱线以提高信噪比

      -  ``--pr_times`` : 至少大于等于5

      -  ``--pr_times_s``\ : 大于1

         ``--tr True``: 找出每条谱线超出噪音的“信号”，然后在沿时间轴比较，如果一个“信号”持续很久(大于\ ``--tr_n_continue``)，则认为是RFI。不适用于银河系频段。

      -  ``--tr_s_sigma``:
         沿时间维度高斯平滑（以tr_s_sigma为sigma）谱线以提高信噪比

      -  ``--tr_times``: 至少大于等于5

      -  ``--tr_times_s``: 大于1.5

      -  ``--tr_n_continue``: 一个“信号”持续多少条就标记为rfi

-  输出文件名中包含rfi。

-  对于1300到1450Mhz的短时RFI的处理将在下一版本更新。



hifast.multi 坐标系修正等
====

``hifast.multi``：静止坐标系（frame）修正等

-  示例：

   ::

       python -m hifast.multi XXX.hdf5 --fc True --frame LSRK

-  参数

   -  ``--fc``\ 从望远镜所在的地平参考系修正到太阳或者LSR为中心的参考系。

      ``--fc True``

      -  ``--frame``: 参考系选择，HELIOCEN 或者 LSRK

   -  ``--replace_rfi``:
      如果设为True并且输入文件中存在is_rfi，则会把rfi的值替换为nan。默认为True

   -  ``--merge_polar``: 如果设为True，合并两个偏振。默认为True

-  输出文件名根据输入参数改变，可能包含 fc
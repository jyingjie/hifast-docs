OnOff观测
========
方法一 和 方法二 主要区别在 是否考虑驻波相位的漂移。


方法一 
---------
  
  1. 用 `hifast.pos_swi` 分离噪音管on、off 和 源（src）和参考点（ref）观测，然后噪音管定标，src减去ref后合并成一条谱线（保留两个偏振）。

    :download:`M1-S1.sh <example2/M1-S1.sh>`

    .. literalinclude:: example2/M1-S1.sh
      :language: bash
      :emphasize-lines: 4
      :linenos:
  
  2. 手动去基线，sin拟合驻波。
  
    | 下载: :download:`M1-S2.ipynb <example2/M1-S2.ipynb>`
    | 查看: `notebook <example2/M1-S2.ipynb>`_

  3. 用 `hifast.flux` 流量定标 和 `hifast.multi --fc True` 坐标系修正。


方法二
----------

1. 先不区分 源（src）和参考点（ref）观测。用跟mapping一样的方法来定标。
   
   :download:`M2-S1.sh <example2/M2-S1.sh>`

    .. literalinclude:: example2/M2-S1.sh
      :language: bash
      :emphasize-lines: 4
      :linenos:

2. 用fft方法对每条谱线去驻波
   
   :download:`M2-S2.sh <example2/M2-S2.sh>`
   :download:`S2-sw.ini <example1/conf/S2-sw.ini>`
    .. literalinclude:: example2/M2-S2.sh
      :language: bash
      :emphasize-lines: 4
      :linenos:

3. 用 `hifast.pos_swi_2` 分离源（src）和参考点（ref）观测，然后src减去ref后合并成一条谱线（保留两个偏振）。
   
   :download:`M2-S3.sh <example2/M2-S3.sh>`

    .. literalinclude:: example2/M2-S3.sh
      :language: bash
      :emphasize-lines: 4
      :linenos:

4. 手动去基线
   
   | 下载: :download:`M2-S4.ipynb <example2/M2-S4.ipynb>`
   | 查看: `notebook <example2/M2-S4.ipynb>`_

5. `hifast.multi --fc True` 坐标系修正。
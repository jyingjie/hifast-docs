更新说明
=======

v1.1a1
-----

- hifast.sep 增加处理Power Cal的方法
- hifast.radec 默认使用astropy来从地平坐标系转换到RA DEC，astropy会考虑UT1-UTC的短期变化，坐标计算与之前的差别会有几个角秒。
- hifast.radec 增加了温度，压强等参数。
- hifast.sw 提高FFT方法在强源附件的效果。
- hifast.rfi 增加了对特定种类RFI的识别，比之前的方法效果好。
- hifast.cube 增加了bessel*gaussian卷积核。增加-f参数。
- 修复了一些bug。
安装
=====

## 配置环境： \* 方法一：用conda配置环境

如果没有conda，请安装\ `miniconda3 <https://docs.conda.io/en/latest/miniconda.html>`__\ 或\ `Miniforge3 <https://github.com/conda-forge/miniforge>`__

下载或者在解压后的hifast.xxx.tar.gz文件目录中找到环境配置文件\ `hifast_env.yml <../hifast_env.yml>`__\ ，(ARM架构CPU使用\ `hifast_env.ARM64.yml <../hifast_env.ARM64.yml>`__)

-  用conda新建一个环境：
   ``$ conda env create -n myenv --file hifast_env.yml``
   可以修改myenv为其他字符。之后用 ``$ conda activate myenv`` 或
   ``$ source activate myenv`` 来切换到对应的环境。

-  或 更新已存在的conda环境使其满足hifast的依赖库：
   ``$ conda env update --file hifast_env.yml -n ENV_NAME``
   替换\ ``ENV_NAME``\ 为已存在的conda
   env名字，如果是主环境，则\ ``ENV_NAME``\ 为\ ``base``

-  方法二：使用离线包配置环境（测试中，可能会有bug） 下载
   https://pan.cstcloud.cn/s/QmkBVYgyRO8 中的hifast_env.XXX.tar.gz

   首次配置：

   ::

      $ mkdir ~/hifast_env
      $ tar -zxvf hifast_env.XXX.tar.gz -C ~/hifast_env
      $ source ~/hifast_env/bin/activate
      (hifast_env) $ conda-unpack
      (hifast_env) $ source ~/hifast_env/bin/deactivate

   之后激活环境用：

   ::

       $ source ~/hifast_env/bin/activate

   移除环境用：

   ::

       (hifast_env) $ source ~/hifast_env/bin/deactivate

   ## 安装hifast

-  方法一： 用pip联网直接安装：

   见 `wikis/Install <../../wikis/Install>`__

-  方法二： 下载后安装

   下载安装包解压后\ **先 cd 切换到代码(setup.py)所在目录下**

   确认已激活之前配置好的环境

   -  安装

      ::

         $ python -m pip install . --upgrade 

   -  卸载

      ::

         $ pip uninstall hifast

   -  提示 由于包文件里包括c代码，因此必须安装后才能正确
      import。另外由于Python在 import 时是从当前路径开始搜索包，
      因此不要在安装包（setup.py）所在目录下执行 hifast相关命令。

## 相关数据下载 \* 噪音管温度文件

::

   下载 Tcal文件夹( https://pan.cstcloud.cn/s/AfnCB96cT2s 提取码：cqwy ) 放到你的家目录。如有新的噪音管文件，会一并更新到此目录。

使用流程
========

**Note:**

-  大部分hifast.xxx可以在终端中用 ``python -m hifast.xxx``
   来执行，后面接 文件路径
   和\ ``-``\ 加一个字母或\ ``--``\ 加多个字符的参数。
-  ``python -m hifast.xxx -h`` 显示帮助。
-  对于生成的hdf5文件，在终端执行

   -  ``h5dump -g /Header XXX.hdf5`` 显示生成该文件时用的参数。
   -  ``h5dump -n XXX.hdf5`` 显示文件中有什么内容

   也可以用\ `CARTA
   2.0 <https://carta.readthedocs.io/en/latest/index.html>`__\ 打开查看“瀑布图(waterfall)”。







  ##
   




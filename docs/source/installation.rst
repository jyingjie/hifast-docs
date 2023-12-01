安装
=====

配置环境
--------
方法一: 使用离线包配置环境
   从 https://pan.cstcloud.cn/s/QmkBVYgyRO8 下载 ``hifast_env.XXX.tar.gz`` （XXX为对应的版本号）
  
  配置：

  .. code-block:: console

   $ mkdir ~/hifast_env
   $ tar -zxvf hifast_env.XXX.tar.gz -C ~/hifast_env
   $ source ~/hifast_env/bin/activate
   (hifast_env) $ conda-unpack
   (hifast_env) $ source ~/hifast_env/bin/deactivate
   
  之后激活环境：

  .. code-block:: console

   $ source ~/hifast_env/bin/activate
   
  移除环境：
  
  .. code-block:: console

   (hifast_env) $ source ~/hifast_env/bin/deactivate

* 方法二：用conda配置环境

  如果没有conda，请安装 `miniconda3 <https://docs.conda.io/en/latest/miniconda.html>`_
  或者 `Miniforge3 <https://github.com/conda-forge/miniforge>`_

  使用环境配置文件 :download:`hifast_env.yml <download/hifast_env.yml>`
  (ARM架构使用 :download:`hifast_env.ARM64.yml <download/hifast_env.ARM64.yml>`)

  * 新建一个环境:

     .. code-block:: console
      
      $ conda env create -n hifast_env --file hifast_env.yml 
     
    ``hifast_env`` 可以修改为其他字符。之后用

     .. code-block:: console

        $ conda activate hifast_env

    或

     .. code-block:: console
       
       $ source activate hifast_env
      
    来切换到对应的环境.

  * 或更新已存在环境:
  
     .. code-block:: console
      
      $ conda env update --file hifast_env.yml -n ENV_NAME
     
    替换 ``ENV_NAME`` 为已存在的conda env名字, 如果是主环境，则 ``ENV_NAME`` 为 ``base``
   
安装hifast
----------

获得hifast的安装包(https://pan.cstcloud.cn/s/WD56MPBjTDs), 文件名一般为 ``hifast-XXX.whl`` (XXX为包括版本号的字符；一般不要修改文件名)
  
安装:

  .. code-block:: console

   # 请替换 hifast-XXX.whl 为下载的安装包文件名
   $ python -m pip install hifast-XXX.whl --upgrade

卸载:
  
  .. code-block:: console

   $ pip uninstall hifast

相关数据下载
------------

* 噪音管温度文件:
  
  下载 Tcal文件夹: https://pan.cstcloud.cn/s/AfnCB96cT2s (备用地址：https://share.weiyun.com/fFynlcX0) 放到你的家目录。
  如有新的噪音管文件，会一并更新到此链接。

 .. code-block:: console

  (hifast_env) $ ls ~/Tcal
  20190115  20200531  20201014

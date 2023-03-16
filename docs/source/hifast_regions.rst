手动标记RFI 
===============
使用CARTA在瀑布图上标记出RFI的区域（region），导出后把文件输入到 ``hifast.rfi`` 中进行标记。

标记区域示例
-------------
  
  .. figure:: download/regions1.png
    
    标记形状示例。

  .. figure:: download/regions2.png
    
    Mask效果。白色区域代表被替换为nan。

  用CARTA打开去过基线的谱线数据，如图。目前支持的区域形状有两种：

  - 方形（Rectangle）：区域内谱线会被标记
  - 线段（line）：（CART v3.0版本支持）图中展示了水平和垂直两种，分别用来标记整个频率区间或者整条谱线。
    操作时线段无需画得完全水平或者垂直，可以稍有倾斜角度。（注：示例图中被线段标记的并不是RFI，只是为了展示效果。）
  
  在CARTA中通过放大和拖动来更好定位需要标记的区域，然后在CARTA的 Z Profile 里切换到另外一个偏振继续标记。

导出标记区域到文件
---------------------

  - 方法一：File --> Export regions --> 导出文件格式选 DS9 & Pixel，
    文件名推荐使用谱线的文件名加上".reg"后缀，例如 ``XXX-bld.hdf5.reg``
  - 方法二：使用下面的Snippets代码（CART v3.0版本支持：Preference --> Global --> Enable Code Snippets）
    
    .. code-block:: javascript

        let dir=app.activeFrame.frameInfo.directory;
        let fname=app.activeFrame.frameInfo.fileInfo.name + '.reg';

        app.fileBrowserStore.exportCoordinateType = 0;
        app.fileBrowserStore.exportFileType = 2;

        app.fileBrowserStore.exportRegionIndexes = Array.from(app.activeFrame.regionSet.regions.keys()).slice(1);

        await app.exportRegions(dir, fname, app.fileBrowserStore.exportCoordinateType,
        app.fileBrowserStore.exportFileType, app.fileBrowserStore.exportRegionIndexes);

导出的文件输入到 ``hifast.rfi``
-----------------------------------

使用 ``--reg_from`` 参数来指定上一步导出的文件。

``--reg_from default`` 自动查找同目录下对应的 ``XXX-bld.hdf5.reg`` 文件：

.. code-block:: bash

  python -m hifast.rfi XXX-bld.hdf5 --reg_from default

或者指定其他路径

.. code-block:: bash

  python -m hifast.rfi XXX-bld.hdf5 --reg_from XXX.reg

其他
-------
  可能有用的CARTA设置
  
  -  Preference --> Region --> Create Mode
  -  Preference --> Region --> Line Witdth
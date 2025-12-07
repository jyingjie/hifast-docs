HiFAST
===================================


.. warning::

   **注意：** 您当前查看的是旧版本文档。
   
   请访问新版文档以获取最新内容： https://hifast.readthedocs.io


.. note::

   此项目目前处于开发中

流程图
--------------

.. diagrams.net->File->Embed->HTML->uncheck Lightbox.Edit
.. raw:: html

   <div class="mxgraph" style="max-width:100%;border:1px solid transparent;" data-mxgraph="{&quot;highlight&quot;:&quot;#0000ff&quot;,&quot;nav&quot;:true,&quot;resize&quot;:true,&quot;toolbar&quot;:&quot;zoom layers tags lightbox&quot;,&quot;xml&quot;:&quot;&lt;mxfile host=\&quot;app.diagrams.net\&quot; modified=\&quot;2022-03-19T12:50:26.162Z\&quot; agent=\&quot;5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/99.0.4844.74 Safari/537.36\&quot; etag=\&quot;erxWGjcrfuKUn5IZLSWv\&quot; version=\&quot;17.1.3\&quot; type=\&quot;google\&quot;&gt;&lt;diagram id=\&quot;81lsNb7HLeybAqhUtNnT\&quot; name=\&quot;Page-1\&quot;&gt;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&lt;/diagram&gt;&lt;/mxfile&gt;&quot;}"></div>
   <script type="text/javascript" src="_static/viewer-static.min.js"></script>

.. <script type="text/javascript" src="https://viewer.diagrams.net/js/viewer-static.min.js"></script>


目录
--------

.. toctree::
   :maxdepth: 2

   安装 <installation>
   示例 <examples/index>
   流程 <flow>
   并行 <parallel>
   工具 <tools>
   changelog
   帮助 <help>


:notoc:
:html_theme.sidebar_secondary.remove:

HiFAST
===================================


**HiFAST** is a powerful, Python-based pipeline designed for the calibration and imaging of HI (neutral hydrogen) data from the Five-hundred-meter Aperture Spherical radio Telescope (FAST).

It provides a comprehensive suite of tools for radio astronomers to process raw observational data into science-ready data cubes. To learn more about the pipeline and its underlying methods, please see our :doc:`publications and citation guidelines <citations>`.

Getting started is easy: begin with the :doc:`Installation guide<installation>`, explore the :doc:`Examples<examples/index>`, or try it directly in your browser on `Colab <https://colab.research.google.com/drive/10NVtnRmb-POxl6ESl0yy7b52WcEU82Cd>`_.

.. note::

   Unofficial tutorials in 中文 are also available at `This link <https://zhuanlan.zhihu.com/p/611842606>`_, `This link <https://zhuanlan.zhihu.com/p/679377110>`_, and `This link <https://zhuanlan.zhihu.com/p/681687989>`_.

Flowchart
--------------


.. mermaid::
   :caption: This flowchart illustrates the standard data processing workflow in HiFAST, from raw data to final data cubes. While it shows a typical path, remember that these modules are adaptable for custom tasks. (Click on nodes to view detailed documentation)

   %%{init: {'themeVariables': { 'fontSize': '18px'}, 'flowchart': {'htmlLabels': false, 'wrappingWidth': 500, 'nodeSpacing': 20, 'padding': 5, 'rankSpacing': 18, 'diagramPadding': 5}}}%%
   flowchart TB
      
      Load("Load raw data from FITS file")
      Temp("Temperature calibration")
      Stand("Standing wave removal")
      Off("Off‑source subtraction")
      Cont("Continuum removal")
      Base("Baseline removal")
      Flux("Flux density calibration")

      Load --> Temp --> Stand
      Stand -- Option 1 --> Off --> Cont --> Flux
      Stand -- Option 2 --> Base --> Flux

      Pos("Read the position of feed")
      RADEC("RA DEC calculation")
      Doppler("Doppler correction")
      RFI("RFI flagging")
      Stray("Stray radiation correction")
      Grid("Gridding")
      Cube[(Data cube)]

      Pos --> RADEC --> Stand
      RFI --> Doppler
      Doppler --> Grid
      Stray -.-> Grid
      Grid -.-> Stray
      Grid --> Cube

      %% Inter-row connection
      Flux --> RFI

      %% Links
      click Load "hifast.sep.html"
      click Temp "hifast.sep.html"
      click Stand "hifast.sw.html"
      click Off "hifast.ref.html"
      click Cont "hifast.bld.html"
      click Base "hifast.bld.html"
      click Flux "hifast.flux.html"
      click Pos "hifast.radec.html"
      click RADEC "hifast.radec.html"
      click Doppler "hifast.multi.html"
      click RFI "hifast.rfi.html"
      click Stray "hifast.sr.html"
      click Grid "hifast.cube.html"
      click Cube "hifast.cube.html"


Table of Contents
------------------

Explore the documentation to learn more about installing and using HiFAST, from following the standard workflow to using its tools for custom tasks.

.. toctree::
   :maxdepth: 2

   Installation <installation>
   Examples <examples/index>
   Command-Line <hifast.xxx>
   
.. toctree::
   :maxdepth: 3
   
   Core Modules <core_workflow>
   
.. toctree::
   :maxdepth: 2
   
   parallel
   tools
   citations
   changelog
   help

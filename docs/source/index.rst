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

   %%{init: {'themeVariables': { 'fontSize': '50px'}, 'flowchart': {'nodeSpacing': 25, 'padding': 6, 'rankSpacing': 25, 'diagramPadding': 0}}}%%
   flowchart TB
      classDef default font-size:50px;
      %% Define subgraphs to enforce stacked layout
      subgraph TopRow [" "]
         direction LR
         Load["Load&nbsp;raw&nbsp;data&nbsp;from&nbsp;FITS&nbsp;file"]
         Temp["Temperature&nbsp;calibration"]
         Stand["Standing&nbsp;wave&nbsp;removal"]
         Off["Off‑source&nbsp;subtraction"]
         Cont["Continuum&nbsp;removal"]
         Base["Baseline&nbsp;removal"]
         Flux["Flux&nbsp;density&nbsp;calibration"]

         Load --> Temp --> Stand
         Stand -- Option 1 --> Off --> Cont --> Flux
         Stand -- Option 2 --> Base --> Flux
      end

      subgraph BottomRow [" "]
         direction LR
         Pos["Read&nbsp;the&nbsp;position&nbsp;of&nbsp;feed"]
         RADEC["RA&nbsp;DEC&nbsp;calculation"]
         Doppler["Doppler&nbsp;correction"]
         RFI["RFI&nbsp;flagging"]
         Stray["Stray&nbsp;radiation&nbsp;correction"]
         Grid[Gridding]
         Cube[(Data cube)]

         Pos --> RADEC --> Doppler
         RFI --> Doppler
         Doppler --> Grid
         Stray -.-> Grid
         Grid -.-> Stray
         Grid --> Cube
      end

      %% Inter-row connection
      Flux --> RFI

      %% Hide subgraph borders/titles
      style TopRow fill:none,stroke:none
      style BottomRow fill:none,stroke:none

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
   
   Tools <advanced_tools>
   citations
   changelog
   help

Manually mask RFI
====================
Use CARTA to mask the RFI areas (regions) on the waterfall plot, then export and input the file into ``hifast.rfi`` for masking.

Example of masking Areas
------------------------

  .. figure:: download/regions1.png
    
    Example of masking shapes.

  .. figure:: download/regions2.png
    
    Mask effect. White areas represent those replaced with nan.

  Open the baseline-subtracted spectral line data with CARTA, as shown in the figure. Currently supported region shapes include:

  - Rectangle: Spectral lines within the area will be masked.
  - Line: (Supported in CARTA v3.0) The figure shows both horizontal and vertical lines, used to mask the entire frequency range or an entire spectral line.
    When operating, the line does not need to be perfectly horizontal or vertical, a slight tilt is acceptable. (Note: The lines masked in the example are not RFI, they are just for demonstration purposes.)
  
  Use zoom and drag in CARTA to better locate the area to be masked, then switch to another polarization in CARTA's Z Profile to continue masking.

Exporting masked Areas to a File
--------------------------------

  - Method 1: File --> Export regions --> Choose DS9 & Pixel as the export file format,
    the file name is recommended to use the spectral line's file name with a ".reg" suffix, for example, ``XXX-bld.hdf5.reg``
  - Method 2: Use the following Snippets code (Supported in CARTA v3.0: Preference --> Global --> Enable Code Snippets)
    
    .. code-block:: javascript

        let dir = app.activeFrame.frameInfo.directory;
        let fname = app.activeFrame.frameInfo.fileInfo.name + '.reg';

        app.fileBrowserStore.exportCoordinateType = 0;
        app.fileBrowserStore.exportFileType = 2;

        app.fileBrowserStore.exportRegionIndexes = Array.from(app.activeFrame.regionSet.regions.keys()).slice(1);

        await app.exportRegions(dir, fname, app.fileBrowserStore.exportCoordinateType,
        app.fileBrowserStore.exportFileType, app.fileBrowserStore.exportRegionIndexes);

Input the Exported File into ``hifast.rfi``
-------------------------------------------

Use the ``--reg_from`` parameter to specify the file exported in the previous step.

``--reg_from default`` automatically searches for the corresponding ``XXX-bld.hdf5.reg`` file in the same directory:

.. code-block:: bash

  python -m hifast.rfi XXX-bld.hdf5 --reg_from default

Or specify another path:

.. code-block:: bash

  python -m hifast.rfi XXX-bld.hdf5 --reg_from XXX.reg

Other
-----
  Useful CARTA Settings
  
  - Preference --> Region --> Create Mode
  - Preference --> Region --> Line Width
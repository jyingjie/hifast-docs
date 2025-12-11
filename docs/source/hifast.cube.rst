``hifast.cube`` Spectral Cube Regridding
========================================

.. program:: python -m hifast.cube

Overview
--------

The ``hifast.cube`` module is designed to regrid a collection of spectra (usually from multiple files) into a single 3D data cube (RA, DEC, Velocity/Frequency). It handles the spatial convolution of point-like spectral data onto a regular grid using various kernels.

Processing Workflow
-------------------

The regridding process involves several key steps. Understanding these steps will help you choose the right parameters.

1. **Input Selection**
   The module accepts a list of HDF5 files or a glob pattern (e.g., ``data/*.hdf5``) via the ``fpatterns`` argument. It automatically detects the data field (Flux, Ta, or Power), but you can force a specific field using ``-k`` / :option:`--key`.

2. **Grid Definition (WCS)**
   The spatial grid of the output cube is defined by the World Coordinate System (WCS).
   
   *   **Range**: By default, the module calculates the bounding box of all input data. You can manually restrict the area using :option:`--ra_range` and :option:`--dec_range`.
   *   **Pixel Size**: The grid spacing is controlled by :option:`--bwidth`. This determines the sampling interval, which should be smaller than the beam size to properly sample the resolution (e.g., 1/3 to 1/5 of the beam FWHM). The default is 60 arcseconds.
   *   **Projection**: The default projection is ``AIT`` (Aitoff). You can select others via :option:`-p` / :option:`--proj`.
       
       *   ``SIN`` / ``TAN``: Common tangent plane projections.
       *   ``rCAR``: A special mode of **CAR**. This specific configuration results in a grid where **RA and DEC lines are straight and orthogonal**.
       
       For other projections and their details, please refer to `Calabretta & Greisen (2002) <https://arxiv.org/abs/astro-ph/0207413>`_.
   *   **Spectral Axis**: The third axis type is set by :option:`--type3` (default: ``vrad``). Note that velocities are always calculated from the **frequency** information in the input files; any existing velocity columns in the input are ignored.

3. **Convolution**
   This is the core of the imaging process. Each spectrum contributes to nearby grid pixels based on a convolution kernel.

   *   **Kernel**: The convolution method is set by :option:`-m` / :option:`--method`. The default is ``gaussian``.
   *   **Beam Size**: The kernel width is determined by the telescope's beam size, specified by :option:`--beam_fwhw` (default: 2.9 arcmin).
   *   **Cutoff Radius**: To optimize performance, the convolution is limited to a specific radius, controlled by :option:`--r_cut`. Spectra outside this radius from a pixel center are ignored. The default is **3 * sigma**, where sigma is derived from the Gaussian FWHM (:math:`\sigma \approx \text{FWHM} / 2.355`).

Beam Correction (New in v1.4)
-----------------------------

.. note::
   Starting from version 1.4, the :option:`--apply_beam_correction` argument is **mandatory**.

Convolution naturally smoothes the data, degrading the **effective spatial resolution** of the final cube. This parameter controls how this effect is handled, which is critical for subsequent physical analysis.

**If set to True (Recommended):**

*   **Header Update**: The ``BMAJ`` and ``BMIN`` keywords in the FITS header are updated to reflect the **effective spatial resolution** (convolution of the telescope beam + gridding kernel).
*   **Flux Scaling**: Pixel values (if in Jy/beam) are scaled up by the ratio of the beam areas :math:`(\Omega_{effective} / \Omega_{telescope})`.

**Implications for Analysis:**

1.  **Flux Density & Column Density**:
    Since both the pixel values (Jy/beam) and the resolution area increase by the same factor, the **Surface Brightness** (Jy/sr or Kelvin) remains conserved.
    
    .. math::
       T_B \propto \frac{S_{\nu}}{\Omega_{beam}}

    This ensures that calculating **Column Density** (:math:`N_{HI}`) or converting to **Jy/pixel** using the header's ``BMAJ`` will yield correct results.

2.  **Spatial Resolution & Deconvolution**:
    Because ``BMAJ``/ ``BMIN`` correctly records the map's resolution, calculations involving spatial extent are accurate.
    
    *   **Deconvolution**: When measuring the intrinsic size of a source (:math:`\theta_{source}^2 = \theta_{obs}^2 - \theta_{resolution}^2`), using the correct ``BMAJ``/ ``BMIN`` prevents overestimating the source size.
    *   **Physical Quantities**: Derived quantities like dynamical mass or physical diameter will be accurate.

**If set to False (or for legacy data):**
The header retains the *original* telescope beam size, and pixel values are not scaled.

*   **Flux Quantities**: Integrated flux measurements (e.g., total Jy of a source) are **consistent with the result when set to True**. This is because when set to True, both the pixel values and the beam area (used for conversion) increase by the same factor, canceling out in the flux calculation.
*   **Size Quantities**: The ``BMAJ``/ ``BMIN`` in the header represents the **telescope resolution**, which is **smaller** than the actual map resolution.

.. code-block:: bash

   # Recommended: Apply correction to ensure header and flux are correct
   python -m hifast.cube ... --apply_beam_correction True

4. **Output**
   The result is saved as a FITS file specified by :option:`--outname`. If the file exists, use :option:`-f` to overwrite it.

Examples
--------

**Basic Usage**
Process all HDF5 files in the current directory and save to ``cube.fits``:

.. code-block:: bash

   python -m hifast.cube *.hdf5 --outname cube.fits

**Custom Grid and Resolution**
Create a cube with 30-arcsecond pixels, covering a specific RA/DEC range:

.. code-block:: bash

   python -m hifast.cube data/*.hdf5 --outname high_res.fits \
       --bwidth 30 \
       --ra_range 120 125 --dec_range 30 35

**Force Overwrite**
If you are iterating on parameters, use ``-f`` to overwrite the output file:

.. code-block:: bash

   python -m hifast.cube *.hdf5 --outname test.fits -f

Full Parameter Reference
------------------------

.. tip::
   You can also view the full list of parameters and their descriptions directly in your terminal by running:
   
   .. code-block:: bash
   
      python -m hifast.cube --help

.. argparse::
   :module: hifast.cube
   :func: parser
   :prog: python -m hifast.cube
   :noepilog:
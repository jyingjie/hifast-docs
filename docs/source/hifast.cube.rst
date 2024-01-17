``hifast.cube`` Data Cube regridding
=====================================

``hifast.cube``

::

   python -m hifast.cube **/data/*-fc*.hdf5 --outname ./test_cubes.fits --bwidth 60 -p SIN --method gaussian


Workflow
----------------------

1. Input files containing spectra corrected for Doppler (coordinate system) shifts,
   identified by ``-fc`` in their filenames. (For now, all files need have the same
   spectral sampling times.)

2. Read the input files' coordinates to create a ``WCS`` header, forming the
   RA-DEC grid. Grid point spacing is set by ``--bwidth``.
   By default, the ``WCS`` RA and DEC range is defined by the input files, but
   can also be set using ``--ra_range`` and ``--dec_range``.
   
   - ``--type3``: The third axis: ``vopt``, ``vrad``, or ``freq`` (default: ``vrad``)
   - ``--range3``: Third axis range (default: None)
   - ``-p``: Celestial projection method. See arXiv:astro-ph/0207413, section 7.2,
     for choices (default: AIT)
   - ``--wcs_ra_center``, ``--wcs_dec_center``: manually set "CRVAL1" and "CRVAL2" in ``WCS`` header.
  
3. "Convolution"
   - ``--r_cut``: The range within which spectral lines contribute to each grid point, in arcseconds.
   - ``--beam_fwhw``: Beam size (FWHM); unit: arcminutes (default: 2.9)
   - ``--method``: Convolution kernel types: ``gaussian``, ``bessel_gaussian``, or ``sinc_gaussian`` (default: ``gaussian``, Mangum et al., arXiv:0709.0553)
      
      * ``gaussian``: Used parameters:
  
        - ``--gaussian_fwhw``: Unit: arcminutes; default: ``beam_fwhw/2``
        - ``--r_cut``: Defaults to ``3*gaussian_sigma``, i.e., 
          ``3*(gaussian_fwhw/(sqrt(8ln(2))))``
      
      * ``bessel_gaussian``: Used parameters:
  
        - ``--bsize``: Unit: arcminutes; default: ``1.55*beam_fwhw/3``
        - ``--gsize``: Unit: arcminutes; default: ``2.52*beam_fwhw/3``
        - ``--r_cut``: Defaults to ``3.8317059702075*bsize/pi``
      
      * ``sinc_gaussian``: Used parameters:

        - ``--bsize``: Unit: arcminutes; default: ``1.55*beam_fwhw/3``
        - ``--gsize``: Unit: arcminutes; default: ``2.52*beam_fwhw/3``
        - ``--r_cut``: Default is ``bsize``
   
   - ``--frac_finite_min FRAC_FINITE_MIN``: For a grid point with ``n`` spectra
     within ``r_cut``, if the count of ``finite value`` (neither nan nor infinite)
     at a channel (frequency sampling) is below ``FRAC_FINITE_MIN * n``, the output for
     that channel is set as ``nan`` (default: 1)
   
   - ``--polar {XX,YY,M}``: Polarization choice (default is ``M``, merging both
     polarizations.)

Parameters
--------------

To view more parameter details, use ``python -m hifast.cube -h | more``.
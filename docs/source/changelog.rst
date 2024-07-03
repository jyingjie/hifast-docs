Change log
============

v1.1a1
------

- hifast.sep now includes a method for processing Power Cal.
- hifast.radec now defaults to using astropy for converting from horizontal to RA DEC coordinates. Astropy considers short-term variations in UT1-UTC, resulting in a few arcseconds of difference in coordinate calculations compared to previous methods.
- hifast.radec has added parameters for temperature, pressure, etc.
- hifast.sw has improved the effectiveness of the FFT method near strong sources.
- hifast.rfi now recognizes specific types of RFI, providing better results than previous methods.
- hifast.cube has added a bessel*gaussian convolution kernel. Added the -f parameter.
- Fixed some bugs.

v1.2
-----

- Fixed hifast.bld -T
- Added hifast.ref
- Refactored hifast.cube, added parallel processing, etc.
- Improved the pcal check effect in hifast.sep
- Fixed some bugs.

v1.3
--------

v1.3a1
^^^^^^^^^^^^
- add ObsLogParser (hifast.func.obs_log)
- add ``--ky_dir`` to ``hifast.radec``
- bugs fixed

v1.3a2
^^^^^^^^^^^^
- use `%[...]s` pattern instead of `%(...)` in ``--outdir``

v1.3a3
^^^^^^^^^^^^
- add new pre-measured flux gains from :doc:`Liu et al. (2024) <fluxgain>`,
- add an option to improve output clarity during multi-file operations by setting the environment variable ``export HIFAST_MAKE_OUTPUT_CLEAR=1``.
- bug fixed
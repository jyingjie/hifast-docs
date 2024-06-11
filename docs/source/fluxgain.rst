Pre-Measured Flux Gains
===========================

This section provides pre-measured flux gains derived from `Liu et al. (2024) <https://iopscience.iop.org/article/10.1088/1674-4527/ad5398>`_. The data were collected under the following reference conditions:

* **Ambient Temperature:** 15 degrees Celsius
* **Zenith Angle:** 10.15 degrees

Corrections for temperature and zenith angle are necessary if your observation conditions differ.

Data
------------------------
The data are available in HDF5 format at `This link <https://download.scidb.cn/download?fileId=5a612e328587f62c27a3435aac1af0fa>`_ and include the following:

* **Ambient_Temperature:** Ambient temperature (°C)
* **ZA:** Zenith angle (°)
* **freq:** Frequency sample (MHz)
* **K_Jy1...K_Jy19:** Flux gain (K/Jy)
* **err_K_Jy1...err_K_Jy19:** Flux gain error

Usage
------------------------
**Method 1: Simplified Approach**

Use the `hifast.flux` function (in developing), which automatically handles ambient temperature and zenith angle corrections.

**Method 2: Manual Correction**

1. Read the flux gain data from the HDF5 file.
2. Apply the appropriate corrections for your specific observation conditions. 

The following example shows the basic procedure.

  .. toctree::
   :maxdepth: 1
   :name: `example1.ipynb <../files/fluxgain/read.ipynb>`:
   
   ../files/fluxgain/read.ipynb





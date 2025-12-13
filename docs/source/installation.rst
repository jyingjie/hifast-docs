Installation
============

Environment Setup
----------------------
The environment setup involves configuring the dependencies with specific versions.

* Method 1: Configure Environment Using Offline Package
   Download ``hifast_env.centos7.x86_64.v1.tar.gz`` (for Most Linux distributions) and (``threadpoolctl-3.1.0-py3-none-any.whl``) from https://pan.cstcloud.cn/s/QmkBVYgyRO8.

   Install the environment package (this step is only required once):

   .. code-block:: console

      $ mkdir ~/hifast_env
      $ tar -zxvf hifast_env.centos7.x86_64.v1.tar.gz -C ~/hifast_env
      $ source ~/hifast_env/bin/activate
      (hifast_env) $ conda-unpack
      (hifast_env) $ # install additional package 
      (hifast_env) $ pip install threadpoolctl-3.1.0-py3-none-any.whl 
      (hifast_env) $ source ~/hifast_env/bin/deactivate

   To activate the environment:

   .. code-block:: console

      $ source ~/hifast_env/bin/activate

   To deactivate the environment:

   .. code-block:: console

      (hifast_env) $ source ~/hifast_env/bin/deactivate

* Method 2: Environment Configuration with Conda
   If conda is not installed, install `miniconda3 <https://docs.conda.io/en/latest/miniconda.html>`_
   or `Miniforge3 <https://github.com/conda-forge/miniforge>`_. 
   Use the configuration file :download:`hifast_env.yml <download/hifast_env.yml>`
   (For ARM architecture, use :download:`hifast_env.ARM64.yml <download/hifast_env.ARM64.yml>`).

  * To create a new environment:

     .. code-block:: console

      $ conda env create -n hifast_env --file hifast_env.yml

    Replace ``hifast_env`` with a preferred name. Then, activate the environment:

     .. code-block:: console

      $ conda activate hifast_env

    Or

     .. code-block:: console

       $ source activate hifast_env

  * To update an existing environment:

     .. code-block:: console

      $ conda env update --file hifast_env.yml -n ENV_NAME

    Substitute ``ENV_NAME`` with the name of an existing conda environment. Use ``base`` for the main environment.

Installing hifast
-----------------

Download the hifast installation package from `<https://pan.cstcloud.cn/s/IfTYaVysS6k>`_. 
The file is typically named ``hifast-XXX.whl`` (XXX represents the version number; avoid altering the file name).

To install:

  .. code-block:: console

   (hifast_env) $ # Replace hifast-XXX.whl with the actual file name of the downloaded package
   (hifast_env) $ python -m pip install hifast-XXX.whl --upgrade

To uninstall:

  .. code-block:: console

   (hifast_env) $ python -m pip uninstall hifast

Data Dependencies
-------------------

.. _label-tcal_file:

* Noise diode temperature File:
  
  From v1.4, HiFAST will automatically check and download the required Tcal files (from R2 or GitHub) when processing data. You generally do not need to download them manually.

  **For Offline Environments:**
  If you need to use HiFAST in an environment without internet access, please refer to the :doc:`hifast.utils.tcal` documentation for instructions on how to prepare the data using the ``update-all`` command and configure the offline mode.
  
  (The data source is `this link <https://fast.bao.ac.cn/cms/category/telescope_performance/noise_diode_calibration_report/>`_)
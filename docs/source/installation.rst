Installation
============

HiFAST maintains strict dependency versions and is tested primarily on **Python 3.9**. It is highly recommended to configure a dedicated Python environment.

Method 1: Online Installation
-------------------------------------------

If your server has internet access, create a fresh environment and install HiFAST directly from PyPI.

**Option A: Using uv (Fastest)**

1. **Install uv** (if not installed):

   .. code-block:: console

      $ curl -LsSf https://astral.sh/uv/install.sh | sh
   
   (See `uv documentation <https://github.com/astral-sh/uv>`_ for more details)

2. **Create environment and install**:

   .. code-block:: console

      $ uv venv ~/hifast_env --python 3.9
      $ source ~/hifast_env/bin/activate
      $ uv pip install hifast
      $ # For interactive features (Jupyter/Widgets):
      $ # uv pip install "hifast[interaction]"

**Option B: Using conda**

1. **Install conda** (if not installed):
   
   It is recommended to use `Miniconda3 <https://docs.conda.io/en/latest/miniconda.html>`_ or `Miniforge3 <https://github.com/conda-forge/miniforge>`_.

2. **Create environment and install**:

   .. code-block:: console

      $ conda create -n hifast_env python=3.9
      $ conda activate hifast_env
      $ pip install hifast
      $ # For interactive features (Jupyter/Widgets):
      $ # pip install "hifast[interaction]"

Method 2: Offline Installation
------------------------------

For servers without internet access (e.g., CentOS 7), follow this full procedure to set up the environment and install HiFAST.

1. **Configure Environment** (using pre-packaged env):

   Download ``hifast_env.centos7.x86_64.v1.tar.gz`` and ``threadpoolctl-3.1.0-py3-none-any.whl`` from `<https://pan.cstcloud.cn/s/QmkBVYgyRO8>`_.

   Install the environment (only once):

   .. code-block:: console

      $ mkdir ~/hifast_env
      $ tar -zxvf hifast_env.centos7.x86_64.v1.tar.gz -C ~/hifast_env
      $ source ~/hifast_env/bin/activate
      (hifast_env) $ conda-unpack
      (hifast_env) $ pip install threadpoolctl-3.1.0-py3-none-any.whl 

2. **Download HiFAST Package**:

   * On a machine *with* internet access, visit the `HiFAST PyPI page <https://pypi.org/project/hifast/>`_.
   * Click **Release history** (left sidebar) -> Select version.
   * Click **Download files** (left sidebar), scroll to the bottom, and download the corresponding ``.whl`` file (e.g., ``hifast-1.4.0-py3-none-any.whl``).
   
   .. warning::
      Do not modify the file name of the downloaded ``.whl`` package, otherwise ``pip`` may fail to install it.

3. **Install HiFAST**:

   Transfer the ``.whl`` file to your offline server and install:

   .. code-block:: console

      $ source ~/hifast_env/bin/activate
      (hifast_env) $ pip install hifast-X.Y.Z-py3-none-any.whl --upgrade

Method 3: Legacy Conda Environment File
---------------------------------------

If you prefer using a specific ``yml`` configuration file:

1. Download :download:`hifast_env.yml <download/hifast_env.yml>` (or :download:`hifast_env.ARM64.yml <download/hifast_env.ARM64.yml>` for ARM).

2. Create environment and install:

   .. code-block:: console

      $ conda env create -n hifast_env --file hifast_env.yml
      $ conda activate hifast_env
      $ pip install hifast

Data Dependencies
-------------------

.. _label-tcal_file:

* Noise diode temperature File:
  
  From v1.4, HiFAST will automatically check and download the required Tcal files (from R2 or GitHub) when processing data. You generally do not need to download them manually.

  **For Offline Environments:**
  If you need to use HiFAST in an environment without internet access, please refer to the :doc:`hifast.utils.tcal` documentation for instructions on how to prepare the data using the ``update-all`` command and configure the offline mode.
  
  (The data source is `this link <https://fast.bao.ac.cn/cms/category/telescope_performance/noise_diode_calibration_report/>`_)
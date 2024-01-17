Parallel
========

hifast.sh Composite Script
--------------------------

Most of the ``hifast.<subcommand>`` commands can only process a file of one beam. Below ####
use hifast.sh to execute the same \ ``python -m hifast.<subcommand>``\ operation on multiple files

::

   hifast.sh /data/inspur_disk06/fast_data/3047/G15_drift_5/20200606/*_W*0001.fits -n 10 -c "python -m hifast.sep | -d 0 -m 1 -n 1  --step 5  --frange 1369 1394 --smooth poly --s_deg 1 --outdir ./data"

-  Here, wildcards are used to specify files of 19 beams.

-  The ``-c`` parameter specifies the \ ``python -m hifast.xxx``\ operation to use. \ ``-c``
   The content inside the quotation marks after is split by ``|`` separating the hifast command and input parameters, omitting the input file name.

-  ``-n`` specifies how many files to execute simultaneously.

-  Additionally, .txt files can be used to input the list of files, and .par files to input the commands to be executed.

   For example:

   -  *files.txt* content is as follows:

      ::

         /data/inspur_disk06/fast_data/3047/G15_drift_5/20200606/G15_drift_5_arcdrift-M01_W_0001.fits
         /data/inspur_disk06/fast_data/3047/G15_drift_5/20200606/G15_drift_5_arcdrift-M02_W_0001.fits
         /data/inspur_disk06/fast_data/3047/G15_drift_5/20200606/G15_drift_5_arcdrift-M03_W_0001.fits
         /data/inspur_disk06/fast_data/3047/G15_drift_5/20200606/G15_drift_5_arcdrift-M04_W_0001.fits
         /data/inspur_disk06/fast_data/3047/G15_drift_5/20200606/G15_drift_5_arcdrift-M05_W_0001.fits

   -  *commands.par* content is as follows:

   ::

      python -m hifast.sep | -d 0 -m 1 -n 1  --step 5  --frange 1369 1394 --smooth poly --s_deg 1 --outdir ./data

   -  To execute:

   ``hifast.sh -i files.txt -n 10 -c commands.par``

hifast.sh Examples
------------------

- hifast.sh calculates radec

  ::

     hifast.sh data/*M01*specs_T.hdf5 -c "python -m hifast.radec |  "

-  hifast.sh combines ``hifast.bld`` and ``hifast.multi``
  
  -  *commands.par* content is as follows:

  ::

     # Continuation character "\" should not have spaces after it
     python -m hifast.bld | --method arPLS --lam 1e7 --nproc 5 --outdir ./
     python -m hifast.multi  |  --tr --tr_method smooth --tr_s_sigma 5 --tr_n_continue 100 --fc \
           --keep_rfi --keep_polar

  -  To execute:

  ``hifast.sh data/*M*specs_T.hdf5  -n 10 -c commands.par``
  First, run \ ``python -m hifast.bld``\ to baseline, then \ ``hifast.sh``\ will automatically input the generated file into \ ``python -m hifast.multi``.
  Note that the execution of ``python -m hifast.bld``\ will occupy ``3 * 5 = 15``
  threads.

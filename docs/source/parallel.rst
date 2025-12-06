.. _parallel:

Parallel
======================================

Many ``hifast`` subcommands are designed to process a single input file at a time (e.g., data from one telescope beam). However, a typical observation may produce dozens of files that need to be processed with the same parameters. To handle this, HiFAST provides a shell script, ``hifast.sh``, to execute commands on multiple files in parallel, significantly speeding up the workflow.

The ``hifast.sh`` script is included with the ``hifast`` package. If you have installed HiFAST, this script should be available in your shell's ``PATH`` automatically.

.. note::
   The ``hifast.sh`` script is designed for complex parallel workflows, such as chaining multiple commands together.

   For simpler cases where you only need to run a single command on multiple files, HiFAST provides a more direct, built-in parallel syntax. Please see the :doc:`hifast.xxx` for details on this alternative method.

Basic Syntax
------------

The basic structure of a ``hifast.sh`` command is:

.. code-block:: bash

   hifast.sh [file-list] -n <num_processes> -c "<hifast-command> | <arguments>"

- ``[file-list]``: A list of input files, specified using wildcards (e.g., ``data/*_W.fits``) or a text file via the ``-i`` flag.
- ``-n <num_processes>``: The number of files to process simultaneously.
- ``-c "..."``: The HiFAST command and its parameters, enclosed in quotes or stored in a ``.par`` file.

Key Parameters
--------------

- **File Input**:
    - **Wildcards**: Provide a list of files directly on the command line (e.g., ``*.fits``).
    - ``-i <files.txt>``: Provide a text file containing a list of input file paths, with one path per line.

- **Parallelism**:
    - ``-n <integer>``: Specifies the number of parallel processes. Defaults to 1. Choose a number appropriate for the CPU cores available on your machine.

- **Command Specification**:
    - ``-c "<command>"`` or ``-c <command.par>``: Defines the command(s) to be executed. This can be a string or a path to a ``.par`` file.

- **Logging**:
    - ``-s`` or ``--save_log``: When this flag is present, the script will save the standard output and error for each process to a separate file in a ``./log/`` directory.

Understanding the Command (`-c`) Syntax
-----------------------------------------

The ``-c`` parameter uses a special syntax to tell the script where to insert the input filename: a pipe character (``|``).

**Syntax**: ``"python -m hifast.<subcommand> | <arguments>"``

- **Part 1**: ``python -m hifast.<subcommand>`` is the HiFAST module to execute.
- **Part 2**: ``<arguments>`` are the parameters for that subcommand.

The ``hifast.sh`` script automatically inserts the input filename between the command and its arguments for each file it processes.

Use Cases & Examples
--------------------

Example 1: Simple Parallel Execution
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

**Goal**: Run ``hifast.sep`` on all FITS files in a directory, using 10 parallel processes.

.. code-block:: bash

   hifast.sh /path/to/data/*.fits -n 10 -c "python -m hifast.sep | --step 5 --smooth poly --outdir ./output"

For each file, the script effectively runs a command like this:
``python -m hifast.sep /path/to/data/file1.fits --step 5 --smooth poly --outdir ./output``

Example 2: Multi-Step Pipeline with a ``.par`` File
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For more complex workflows, you can define a sequence of commands in a ``.par`` file. The script will automatically chain them together, feeding the output of one step as the input to the next.

**Goal**: Run a two-step pipeline (baseline removal, then multi-beam processing) on a list of HDF5 files.

**Step 1**: Create a file list named ``files.txt``:

.. code-block:: text

   /path/to/data/file_M01.hdf5
   /path/to/data/file_M02.hdf5
   /path/to/data/file_M03.hdf5

**Step 2**: Create a command parameter file named ``commands.par``:

.. code-block:: text

   # The output of the first command is the input for the second.
   # Note: The continuation character "" must not have spaces after it.
   python -m hifast.bld | --method arPLS --lam 1e7 --nproc 5 --outdir ./
   python -m hifast.multi | --tr --tr_method smooth --keep_rfi

**Step 3**: Execute the script with logging enabled:

.. code-block:: bash

   hifast.sh -i files.txt -n 10 -c commands.par -s

How it works:
1. ``hifast.sh`` reads the file paths from ``files.txt``.
2. For each file, it runs ``python -m hifast.bld ...``.
3. It captures the output filename from the first step and automatically uses it as the input for the second step, ``python -m hifast.multi ...``.
4. The ``-s`` flag saves the output and error logs for each process into the ``./log/`` directory.

.. warning::
   Be mindful of the total resources used. In the pipeline example, if ``-n 10`` is set for ``hifast.sh`` and ``--nproc 5`` is set for ``hifast.bld``, the total number of threads used could be up to ``10 * 5 = 50``. Adjust the ``-n`` parameter based on your system's capacity.
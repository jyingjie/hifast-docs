``hifast.<subcommand>`` General Parameters
==============================================

- Most ``hifast`` commands, used as ``hifast.<subcommand>``, can be executed in the terminal with the command ``python -m hifast..<subcommand>``. This should be followed by the file path, and parameters prefixed with either a single dash ``-`` and a letter, or two dashes ``--`` and a string.
- To access a comprehensive description of all available parameters, use the command ``python -m hifast.xxx -h | more``.
- The intermediate files generated are typically in hdf5 format. To view the specific commands and parameters used for creating these files, execute the following terminal commands:

  - ``h5dump -g /Header /path_to_file/obs-M01-specs_T.hdf5``: Displays the command and parameter details of the file.
  - ``h5ls -r /path_to_file/obs-M01-specs_T.hdf5``: Lists the contents of the file in detail.

cwlVersion: v1.2
class: Workflow

# Workflow with File and Directory inputs.
# The streamflow.yml port bindings tell streamflow WHERE to find these files —
# they may live on a remote HPC system rather than the local machine.

inputs:
  param_file:
    type: File          # a configuration/parameter file
  data_dir:
    type: Directory     # a directory of input data

outputs:
  result:
    type: string
    outputSource: process/result

steps:
  inspect:
    run: inspect.cwl
    in:
      param_file: param_file
      data_dir: data_dir
    out: [summary]

  process:
    run: process.cwl
    in:
      summary: inspect/summary
    out: [result]

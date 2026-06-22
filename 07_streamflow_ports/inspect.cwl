#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

baseCommand: ["/bin/sh", "-c"]

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.param_file)
      - $(inputs.data_dir)

inputs:
  param_file:
    type: File
  data_dir:
    type: Directory

arguments:
  - valueFrom: >
      echo "param: $(inputs.param_file.basename), datadir: $(inputs.data_dir.basename)" > summary.txt

outputs:
  summary:
    type: File
    outputBinding:
      glob: summary.txt

stdout: stdout.txt

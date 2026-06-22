#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

baseCommand: ["/bin/sh", "-c"]

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.summary)

inputs:
  summary:
    type: File

arguments:
  # tee writes to report.txt AND stdout simultaneously.
  # stdout is captured as stdout.txt → used for the string output.
  - valueFrom: "cat $(inputs.summary.basename) | tee report.txt"

outputs:
  result:
    type: string
    outputBinding:
      glob: stdout.txt
      loadContents: true
      outputEval: $(self[0].contents.trim())
  report:
    type: File
    outputBinding:
      glob: report.txt

stdout: stdout.txt

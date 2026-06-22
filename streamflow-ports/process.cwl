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
  - valueFrom: "cat $(inputs.summary.basename)"

outputs:
  result:
    type: string
    outputBinding:
      glob: stdout.txt
      loadContents: true
      outputEval: $(self[0].contents.trim())

stdout: stdout.txt

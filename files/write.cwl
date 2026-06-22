#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

# Writes a string to a file.
# Output port type is File — the next step receives a file object, not a string.

baseCommand: ["/bin/sh", "-c"]

requirements:
  - class: InlineJavascriptRequirement

inputs:
  text:
    type: string

arguments:
  - valueFrom: "printf '%s\n' $(inputs.text) > output.txt"

outputs:
  outfile:
    type: File
    outputBinding:
      glob: output.txt    # CWL collects this file from the working directory

#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

# Counts words in a File input.
#
# Key concept: File inputs must be staged into the tool's working directory
# via InitialWorkDirRequirement before the tool can access them.
# The tool then references the file by its basename (not the original path).

baseCommand: ["/bin/sh", "-c"]

requirements:
  - class: InlineJavascriptRequirement
  - class: InitialWorkDirRequirement
    listing:
      - $(inputs.infile)    # stage the file into the working directory

inputs:
  infile:
    type: File              # receives a File object from the upstream step

arguments:
  # Use .basename — the tool sees the file in its CWD, not the original path
  - valueFrom: "wc -w < $(inputs.infile.basename)"

outputs:
  word_count:
    type: string
    outputBinding:
      glob: stdout.txt
      loadContents: true
      outputEval: $(self[0].contents.trim())

stdout: stdout.txt

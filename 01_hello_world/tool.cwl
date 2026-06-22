#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

# Simplest possible CWL tool.
#
# Anatomy:
#   baseCommand  — the executable to run
#   inputs       — typed ports; values come from inputs.yml at runtime
#   arguments    — extra args built from input values via $(inputs.X) expressions
#   stdout       — redirect stdout to this file
#   outputs      — what to collect after the tool finishes
#
# Run: /bin/sh -c "echo Hello, <name>!"

baseCommand: ["/bin/sh", "-c"]

requirements:
  - class: InlineJavascriptRequirement

inputs:
  name:
    type: string          # the only input port; value comes from inputs.yml

arguments:
  - valueFrom: "echo 'Hello, $(inputs.name)!'"

outputs:
  greeting:
    type: string
    outputBinding:
      glob: stdout.txt         # find this file in the tool's working directory
      loadContents: true       # read its contents into memory
      outputEval: $(self[0].contents.trim())   # return as a trimmed string

stdout: stdout.txt

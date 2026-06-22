#!/usr/bin/env cwl-runner
cwlVersion: v1.2
class: CommandLineTool

# Demonstrates the four main inputBinding styles (how inputs map to CLI args).
#
# Uses `echo` so the constructed command line is visible in the output.
#
# With {first: "hello", second: "world", times: 3}:
#   → echo --times 3 hello world
#   output: "--times 3 hello world"
#
# With label: "greeting" added:
#   → echo --times 3 hello world --label greeting
#   output: "--times 3 hello world --label greeting"

baseCommand: echo

requirements:
  - class: InlineJavascriptRequirement

inputs:

  # 1. POSITIONAL — value placed at this numeric position on the command line.
  #    Lower position numbers come first.
  first:
    type: string
    inputBinding:
      position: 1

  second:
    type: string
    inputBinding:
      position: 2

  # 2. PREFIX — produces "--times <value>" on the command line.
  #    Position 0 puts it before the positional args.
  times:
    type: int
    inputBinding:
      prefix: --times
      position: 0

  # 3. OPTIONAL — type ending in "?" means the value may be null.
  #    When null (omitted from inputs.yml), the argument is dropped entirely.
  label:
    type: string?
    inputBinding:
      prefix: --label
      position: 3

  # 4. BOOLEAN FLAG — when true, the flag is emitted; when false, it is omitted.
  verbose:
    type: boolean?
    inputBinding:
      prefix: --verbose
      position: 4

outputs:
  # The output shows exactly what command line CWL constructed.
  command_line:
    type: string
    outputBinding:
      glob: stdout.txt
      loadContents: true
      outputEval: $(self[0].contents.trim())

stdout: stdout.txt

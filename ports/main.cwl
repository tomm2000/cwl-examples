cwlVersion: v1.2
class: Workflow

# Demonstrates how workflow-level ports wire to tool-level ports.
#
# Workflow inputs are "source" ports.
# Each step has "in" ports (connected to sources) and "out" ports (connected to sinks).
# A workflow output collects from a step's out port via outputSource.
#
# Port wiring rules:
#   workflow input  → step in port:   use the input name directly
#   step out port   → step in port:   use "stepname/portname"
#   step out port   → workflow output: outputSource: "stepname/portname"

inputs:
  word:
    type: string
  count:
    type: int
  tag:
    type: string?    # optional — may be omitted from inputs.yml

outputs:
  step1_result:
    type: string
    outputSource: step1/command_line    # collect from step1's "command_line" out port

  step2_result:
    type: string
    outputSource: step2/command_line    # collect from step2's "command_line" out port

steps:
  step1:
    run: tool.cwl
    in:
      first: word     # workflow input "word"  → tool input "first"
      second: word    # same source, different tool port
      times: count    # workflow input "count" → tool input "times"
      label: tag      # optional: passed through only when tag is set
    out: [command_line]

  step2:
    run: tool.cwl
    in:
      first: step1/command_line   # step1's output → step2's "first" input port
      second: word                # workflow input can be reused by any step
      times: count
    out: [command_line]

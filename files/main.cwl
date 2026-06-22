cwlVersion: v1.2
class: Workflow

# Demonstrates File-typed ports: one step produces a File, the next consumes it.
#
# Data flow:
#   inputs.message (string)
#     → write step: produces output.txt as a File object
#       → count step: receives the File, stages it, counts words
#         → outputs.word_count (string)

inputs:
  message:
    type: string

outputs:
  word_count:
    type: string
    outputSource: count/word_count

steps:
  write:
    run: write.cwl
    in:
      text: message
    out: [outfile]           # outfile port carries a File object

  count:
    run: count.cwl
    in:
      infile: write/outfile  # File object passed from write's outfile port
    out: [word_count]

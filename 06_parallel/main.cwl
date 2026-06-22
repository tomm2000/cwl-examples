cwlVersion: v1.2
class: Workflow

# Scatter-based parallelism: step2 runs once per element in the input array.
# N is determined at runtime by the array length — no static fan-out needed.
# Streamflow dispatches each scatter instance to the HPC deployment automatically.

requirements:
  ScatterFeatureRequirement: {}
  InlineJavascriptRequirement: {}

inputs:
  elements:
    type: string[]    # N elements → N parallel step2 instances

outputs:
  out_element:
    type: string
    outputSource: step3/out_element

steps:
  step1:
    run: step1.cwl
    in:
      in_element: elements
    out: [out_element]
    scatter: in_element          # produces string[] output

  step2:
    run: step2.cwl
    in:
      in_element: step1/out_element   # string[] — scatter propagates automatically
    out: [out_element]
    scatter: in_element

  step3:
    run: step3.cwl
    in:
      in_elements: step2/out_element  # string[] gathered automatically into step3
    out: [out_element]

cwlVersion: v1.2
class: Workflow

requirements:
  MultipleInputFeatureRequirement: {}
  InlineJavascriptRequirement: {}
  StepInputExpressionRequirement: {}
  ScatterFeatureRequirement: {}

inputs: 
  elements_1:
    type: string[]


outputs: 
  elements_2:
    type: string
    outputSource: gather/out_element


steps:
# ============== Launch Server ==============
  step1:
    run: step1.cwl
    in:
      in_element: elements_1
    out: [ out_element ]
    scatter: in_element

  step2:
    run: step2.cwl
    in:
      in_element: step1/out_element
    out: [ out_element ]
    scatter: in_element

  step3:
    run: step3.cwl
    in:
      in_element: step2/out_element
    out: [ out_element ]
    scatter: in_element

  gather:
    run: gather.cwl
    in:
      in_elements: step3/out_element
    out: [ out_element ]
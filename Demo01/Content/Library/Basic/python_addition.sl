namespace: Basic
operation:
  name: python_addition
  inputs:
    - number1
    - number2
  python_action:
    use_jython: false
    script: |-
      # do not remove the execute function
      def execute(number1, number2):
          addition = number1 + number2
          return {"return_result": addition}
      # you can add additional helper methods below.
  outputs:
    - return_result
  results:
    - SUCCESS

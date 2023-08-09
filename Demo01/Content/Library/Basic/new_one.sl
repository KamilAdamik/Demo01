namespace: Basic
flow:
  name: new_one
  workflow:
    - run_command:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: netstat
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      run_command:
        x: 240
        'y': 120
        navigate:
          1785e1e8-4360-fdc8-4843-a1f87e304a48:
            targetId: 3cbed410-8f0c-00e0-d5e4-cca9506c408f
            port: SUCCESS
    results:
      SUCCESS:
        3cbed410-8f0c-00e0-d5e4-cca9506c408f:
          x: 400
          'y': 120

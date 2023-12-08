namespace: Flows
flow:
  name: Flow1
  workflow:
    - run_command:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: ipconfig
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
        x: 200
        'y': 120
        navigate:
          c6715ec9-e376-c5c5-2524-b3992cc73316:
            targetId: b2a35b48-c494-33c5-1d05-725110d48f16
            port: SUCCESS
    results:
      SUCCESS:
        b2a35b48-c494-33c5-1d05-725110d48f16:
          x: 360
          'y': 120

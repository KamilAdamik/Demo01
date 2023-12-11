namespace: Flows
flow:
  name: testFEBJ
  workflow:
    - run_command:
        do:
          io.cloudslang.base.cmd.run_command:
            - command: ipconfig /all
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE_1
  results:
    - SUCCESS
    - FAILURE_1
extensions:
  graph:
    steps:
      run_command:
        x: 100
        'y': 250
        navigate:
          6ee7423e-a3d4-8547-64bc-59ae3af538cf:
            targetId: e26d029b-2c4d-f143-b3b8-dbe432c32a7b
            port: SUCCESS
          0354b9cb-eb38-8870-72e7-036cf5594027:
            targetId: 353bc449-7782-72a8-aa3f-4f357fa00970
            port: FAILURE
    results:
      SUCCESS:
        e26d029b-2c4d-f143-b3b8-dbe432c32a7b:
          x: 400
          'y': 125
      FAILURE_1:
        353bc449-7782-72a8-aa3f-4f357fa00970:
          x: 400
          'y': 375

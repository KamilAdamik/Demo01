namespace: Flows
flow:
  name: test2FEBJ
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
          9b114ac6-5e51-4273-1507-57c57ed03c4e:
            targetId: 7f645cfc-129a-68c1-3127-f70d0aea32c4
            port: SUCCESS
          bfe1b5ba-b5ea-49f9-c532-25df1d4fbf99:
            targetId: 46900946-5e0b-4d99-9b83-425e2617c764
            port: FAILURE
    results:
      SUCCESS:
        7f645cfc-129a-68c1-3127-f70d0aea32c4:
          x: 400
          'y': 125
      FAILURE_1:
        46900946-5e0b-4d99-9b83-425e2617c764:
          x: 400
          'y': 375

namespace: Custom
flow:
  name: numpy_test
  workflow:
    - calculate_mean:
        do:
          Custom.calculate_mean: []
        navigate:
          - SUCCESS: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      calculate_mean:
        x: 160
        'y': 200
        navigate:
          2385ec41-df0f-0d5c-3039-de612998ffc8:
            targetId: 7f2e3683-2971-3b65-9934-4bf2a5e9dcda
            port: SUCCESS
    results:
      SUCCESS:
        7f2e3683-2971-3b65-9934-4bf2a5e9dcda:
          x: 320
          'y': 200

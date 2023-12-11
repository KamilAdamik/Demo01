namespace: Flows
flow:
  name: test2FEBJ
  workflow:
    - get_cell:
        do:
          io.cloudslang.base.excel.get_cell: []
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: FAILURE
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      get_cell:
        x: 100
        'y': 250
        navigate:
          c3e6aa58-b960-3e45-0c12-a11ff4d29473:
            targetId: 0062e29d-a616-c41d-ec50-706f4879acbf
            port: SUCCESS
          e3d091dc-e871-d0fb-8a9b-23ab16a5152b:
            targetId: 955537fd-96fc-9de3-1ed8-3181710b0418
            port: FAILURE
    results:
      SUCCESS:
        0062e29d-a616-c41d-ec50-706f4879acbf:
          x: 400
          'y': 125
      FAILURE:
        955537fd-96fc-9de3-1ed8-3181710b0418:
          x: 400
          'y': 375

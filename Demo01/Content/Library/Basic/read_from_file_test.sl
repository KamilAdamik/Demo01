namespace: Basic
flow:
  name: read_from_file_test
  workflow:
    - read_from_file:
        do:
          io.cloudslang.base.filesystem.read_from_file:
            - file_path: /tmp/test.txt
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      read_from_file:
        x: 160
        'y': 120
        navigate:
          df03921e-ed4b-507b-d929-30dc5b56a948:
            targetId: be1c94b3-79db-3333-b035-0123d1f18fa5
            port: SUCCESS
    results:
      SUCCESS:
        be1c94b3-79db-3333-b035-0123d1f18fa5:
          x: 320
          'y': 120

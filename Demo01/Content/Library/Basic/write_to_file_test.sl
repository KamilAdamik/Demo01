namespace: Basic
flow:
  name: write_to_file_test
  workflow:
    - write_to_file:
        do:
          io.cloudslang.base.filesystem.write_to_file:
            - file_path: 'C:/Temp/test.txt'
            - text: this is a test text
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      write_to_file:
        x: 240
        'y': 160
        navigate:
          d1f44556-be0b-c862-6e46-d9191616e845:
            targetId: c8cdc93a-5311-be03-85cb-c497f86b00b9
            port: SUCCESS
    results:
      SUCCESS:
        c8cdc93a-5311-be03-85cb-c497f86b00b9:
          x: 440
          'y': 160

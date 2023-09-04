namespace: Basic
flow:
  name: Ping2
  workflow:
    - ping_target_host:
        do:
          io.cloudslang.base.samples.utils.ping_target_host:
            - target_host: yahoo.com
        publish:
          - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: python_regex
    - python_regex:
        do:
          Basic.python_regex:
            - regex: "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}"
            - text: '${return_result}'
        publish:
          - ip_address: '${match_text}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ping_target_host:
        x: 40
        'y': 160
      python_regex:
        x: 240
        'y': 160
        navigate:
          1d1dcc8c-0809-6c47-178c-be785dc11fc3:
            targetId: 17f8052b-9940-ab11-6204-756df0c14992
            port: SUCCESS
    results:
      SUCCESS:
        17f8052b-9940-ab11-6204-756df0c14992:
          x: 440
          'y': 160

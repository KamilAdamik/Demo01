namespace: Basic
flow:
  name: Ping
  workflow:
    - ping_target_host:
        do:
          io.cloudslang.base.samples.utils.ping_target_host:
            - target_host: google.com
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      ping_target_host:
        x: 240
        'y': 120
        navigate:
          ee322a87-9d29-5253-5633-2490039fe88a:
            targetId: 17f8052b-9940-ab11-6204-756df0c14992
            port: SUCCESS
    results:
      SUCCESS:
        17f8052b-9940-ab11-6204-756df0c14992:
          x: 440
          'y': 160

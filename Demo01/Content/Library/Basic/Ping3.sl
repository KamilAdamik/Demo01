namespace: Basic
flow:
  name: Ping3
  inputs:
    - host: "${get_sp('Basic.host')}"
  workflow:
    - ping_target_host:
        do:
          io.cloudslang.base.samples.utils.ping_target_host:
            - target_host: '${host}'
        publish:
          - ping_result: '${return_result}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: match_regex
    - match_regex:
        do:
          io.cloudslang.base.strings.match_regex:
            - regex: "\\b(?:[0-9]{1,3}\\.){3}[0-9]{1,3}\\b"
            - text: '${ping_result}'
        publish:
          - ip_address: '${match_text}'
        navigate:
          - MATCH: SUCCESS
          - NO_MATCH: CUSTOM
  results:
    - FAILURE
    - SUCCESS
    - CUSTOM
extensions:
  graph:
    steps:
      ping_target_host:
        x: 80
        'y': 120
      match_regex:
        x: 280
        'y': 120
        navigate:
          a03372fe-33ba-fc91-b7ab-c7e26cdd6ac6:
            targetId: 96d27842-a16d-8cc4-d98d-e24a1e05f484
            port: MATCH
          fc9a3258-560d-1547-c37f-a7294676eb56:
            targetId: dc6b4f0c-cc17-44b5-4f27-588ab087e822
            port: NO_MATCH
    results:
      SUCCESS:
        96d27842-a16d-8cc4-d98d-e24a1e05f484:
          x: 520
          'y': 120
      CUSTOM:
        dc6b4f0c-cc17-44b5-4f27-588ab087e822:
          x: 520
          'y': 280

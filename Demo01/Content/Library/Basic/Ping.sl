namespace: Basic
flow:
  name: Ping
  workflow:
    - ping_target_host:
        do:
          io.cloudslang.base.samples.utils.ping_target_host:
            - target_host: yahoo.com
        publish:
          - return_result
        navigate:
          - FAILURE: on_failure
          - SUCCESS: match_regex
    - match_regex:
        do:
          io.cloudslang.base.strings.match_regex:
            - regex: "[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}\\.[0-9]{1,3}"
            - text: '${return_result}'
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
        x: 40
        'y': 160
      match_regex:
        x: 240
        'y': 160
        navigate:
          62c5e1e9-ca85-ddf6-c930-927787eca392:
            targetId: 17f8052b-9940-ab11-6204-756df0c14992
            port: MATCH
          e850eb30-8603-0740-8b85-4ca36e66cbba:
            targetId: bdd84267-e5f4-41a3-0e68-6d8cb392082b
            port: NO_MATCH
    results:
      SUCCESS:
        17f8052b-9940-ab11-6204-756df0c14992:
          x: 440
          'y': 160
      CUSTOM:
        bdd84267-e5f4-41a3-0e68-6d8cb392082b:
          x: 360
          'y': 360

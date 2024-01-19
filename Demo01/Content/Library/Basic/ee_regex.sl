namespace: Basic
flow:
  name: ee_regex
  workflow:
    - do_nothing:
        do:
          io.cloudslang.base.utils.do_nothing:
            - selection: '942,66,194,737,833,982,607,703,903,240'
            - regex: "\\\\b([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\\\b"
        publish:
          - selection
          - regex
          - match: '${cs_regex(selection, regex)}'
        navigate:
          - SUCCESS: SUCCESS
          - FAILURE: on_failure
  outputs:
    - match_text: '${match_text}'
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      do_nothing:
        x: 120
        'y': 160
        navigate:
          52729056-061c-317c-da32-5e6b22300500:
            targetId: b26e9609-8bf7-62a3-6fd7-f21b0a514403
            port: SUCCESS
    results:
      SUCCESS:
        b26e9609-8bf7-62a3-6fd7-f21b0a514403:
          x: 280
          'y': 160

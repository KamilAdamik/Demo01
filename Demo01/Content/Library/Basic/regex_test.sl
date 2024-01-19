namespace: Basic
flow:
  name: regex_test
  workflow:
    - match_regex:
        do:
          io.cloudslang.base.strings.match_regex:
            - regex: "\\\\b([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\\\b"
            - text: '942,66,194,737,833,982,607,703,903,240'
        publish:
          - expression_match: "${cs_regex(text,\"\\\\b([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\\\b\")}"
          - test_match: "${cs_regex(text,\"\\\\b([01]?[0-9]?[0-9]|2[0-4][0-9]|25[0-5])\\\\b\")}"
          - json_path_test: '${cs_json_query(test, "$.store.*")}'
        navigate:
          - MATCH: SUCCESS
          - NO_MATCH: SUCCESS
  results:
    - SUCCESS
extensions:
  graph:
    steps:
      match_regex:
        x: 160
        'y': 160
        navigate:
          d064e503-d1ce-6217-7c91-3bee85440845:
            targetId: 8371a69e-3f82-d953-0e26-97f835a914c0
            port: MATCH
          9db8f56e-02ae-1201-f235-5752e141dd04:
            targetId: 8371a69e-3f82-d953-0e26-97f835a914c0
            port: NO_MATCH
    results:
      SUCCESS:
        8371a69e-3f82-d953-0e26-97f835a914c0:
          x: 400
          'y': 160

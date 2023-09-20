namespace: Basic
flow:
  name: test_date_parsing
  workflow:
    - parse_date:
        do:
          io.cloudslang.base.datetime.parse_date:
            - date: '2023-Sep-10 00:00'
            - date_format: 'yyyy-MMM-dd HH:mm'
            - date_locale_lang: en
            - out_format: 'yyyy-MM-dd HH:mm:ss.SSS Z'
        navigate:
          - SUCCESS: date_to_unix
          - FAILURE: on_failure
    - date_to_unix:
        do:
          Basic.date_to_unix:
            - date_str: '2023-Sep-10 00:00'
            - format_str: '%Y-%b-%d %H:%M'
            - date: '2023-Sep-10 00:00'
            - date_1: '2023-Sep-10 00:00'
        publish:
          - unix_timestamp
        navigate:
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      parse_date:
        x: 40
        'y': 200
      date_to_unix:
        x: 200
        'y': 120
        navigate:
          2e175be3-1129-7a19-173a-a9c081ff82c9:
            targetId: 628d5da1-a762-2c6a-fbf7-8dcd3fdf6975
            port: SUCCESS
    results:
      SUCCESS:
        628d5da1-a762-2c6a-fbf7-8dcd3fdf6975:
          x: 320
          'y': 40

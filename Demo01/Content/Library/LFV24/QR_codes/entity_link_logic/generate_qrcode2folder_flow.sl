namespace: LFV24.QR_codes.entity_link_logic
flow:
  name: generate_qrcode2folder_flow
  inputs:
    - qr_codes_folder: /tmp/qr_codes
    - asset_tag: XYZ789
  workflow:
    - generate_qrcode2folder:
        do:
          LFV24.QR_codes.entity_link_logic.generate_qrcode2folder:
            - asset_tag: '${asset_tag}'
            - qr_codes_folder: '${qr_codes_folder}'
        publish:
          - python_operation_result: '${result}'
          - qr_code_path
        navigate:
          - SUCCESS: check_for_error
    - check_for_error:
        do:
          io.cloudslang.base.strings.match_regex:
            - regex: Error
            - text: '${python_operation_result}'
        navigate:
          - MATCH: FAILURE_PYTHON_OPERATION
          - NO_MATCH: SUCCESS
  outputs:
    - python_operation_result: '${python_operation_result}'
    - qr_code_path: '${qr_code_path}'
  results:
    - SUCCESS
    - FAILURE_PYTHON_OPERATION
extensions:
  graph:
    steps:
      generate_qrcode2folder:
        x: 120
        'y': 160
      check_for_error:
        x: 360
        'y': 160
        navigate:
          a47c21f2-d193-d4f3-0ac1-26123de022e6:
            targetId: d3333308-b9fb-e3e4-4e61-34db1996aa80
            port: MATCH
          1e6f4581-2023-ce9f-c105-7a7f1234bfc6:
            targetId: 03851ab8-9693-e499-8f98-fe6236fc2fc8
            port: NO_MATCH
    results:
      SUCCESS:
        03851ab8-9693-e499-8f98-fe6236fc2fc8:
          x: 600
          'y': 80
      FAILURE_PYTHON_OPERATION:
        d3333308-b9fb-e3e4-4e61-34db1996aa80:
          x: 600
          'y': 280
